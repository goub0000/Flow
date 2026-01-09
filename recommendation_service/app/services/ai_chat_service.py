"""
AI Chat Service
================
Provides AI-powered chat responses with provider support:
- Primary: Google Gemini (Free tier available)
- Fallback: OpenAI GPT (if configured)
- Final fallback: FAQ matching

Features:
- Conversation context management
- Rate limiting
- Token counting
- Confidence scoring
- Auto-escalation detection
"""

import os
import logging
import asyncio
from typing import Optional, List, Dict, Any, Tuple
from datetime import datetime, timedelta
from dataclasses import dataclass
from enum import Enum
import json
import re

logger = logging.getLogger(__name__)

# Try importing AI libraries
try:
    import google.generativeai as genai
    GEMINI_AVAILABLE = True
except ImportError:
    GEMINI_AVAILABLE = False
    logger.warning("Google Generative AI library not installed. Gemini will not be available.")

try:
    import openai
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False
    logger.warning("OpenAI library not installed. GPT fallback will not be available.")

try:
    import tiktoken
    TIKTOKEN_AVAILABLE = True
except ImportError:
    TIKTOKEN_AVAILABLE = False
    logger.warning("Tiktoken not installed. Token counting will use estimates.")


class AIProvider(str, Enum):
    GEMINI = "gemini"
    OPENAI = "openai"
    FAQ = "faq"
    NONE = "none"


@dataclass
class ChatResponse:
    """Response from AI chat service"""
    content: str
    provider: AIProvider
    confidence: float
    tokens_used: int
    quick_actions: Optional[List[Dict[str, Any]]] = None
    sources: Optional[List[str]] = None
    should_escalate: bool = False
    escalation_reason: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class AIChatService:
    """AI-powered chat service with Gemini as primary provider"""

    # System prompt for Flow EdTech context
    SYSTEM_PROMPT = """You are Flow Assistant, a helpful AI assistant for the Flow EdTech platform.

Flow is an AI-powered education technology platform that helps:
- Students: Find universities, track applications, access courses, connect with counselors
- Parents: Monitor their children's educational progress and applications
- Institutions: Manage students, courses, and educational content
- Counselors: Provide guidance and support to students

Your role:
1. Answer questions about Flow's features and how to use the platform
2. Help users navigate the application
3. Provide educational guidance and support
4. Be friendly, helpful, and concise
5. If you don't know something, admit it and suggest contacting support

Important guidelines:
- Keep responses concise (2-3 paragraphs max)
- Use bullet points for lists
- Suggest relevant quick actions when appropriate
- If the user seems frustrated or the question is complex, suggest talking to a human agent
- Never make up information about specific universities or application deadlines

Current user context will be provided with each message."""

    # Sensitive topics that should trigger escalation consideration
    SENSITIVE_TOPICS = [
        "refund", "cancel subscription", "delete account", "complaint",
        "legal", "lawsuit", "discrimination", "harassment", "billing issue",
        "payment problem", "not working", "broken", "angry", "frustrated"
    ]

    # Keywords that indicate user wants human support
    HUMAN_REQUEST_KEYWORDS = [
        "human", "agent", "person", "real person", "talk to someone",
        "speak to someone", "customer service", "support team", "representative"
    ]

    def __init__(self):
        """Initialize AI chat service with configured providers"""
        # Load configuration from environment
        self.gemini_api_key = os.getenv("GEMINI_API_KEY")
        # Use gemini-2.5-flash as default (best availability and performance)
        self.gemini_model = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")

        self.openai_api_key = os.getenv("OPENAI_API_KEY")
        self.openai_model = os.getenv("OPENAI_MODEL", "gpt-3.5-turbo")

        self.max_tokens = int(os.getenv("AI_MAX_TOKENS", "1024"))
        self.temperature = float(os.getenv("AI_TEMPERATURE", "0.7"))
        self.timeout = int(os.getenv("AI_TIMEOUT", "30"))
        self.context_window = int(os.getenv("AI_CONTEXT_WINDOW", "10"))

        # Initialize clients
        self.gemini_model_instance = None
        self.openai_client = None

        if GEMINI_AVAILABLE and self.gemini_api_key:
            # Try multiple model names in order of preference
            model_options = [
                self.gemini_model,
                "gemini-2.5-flash",
                "gemini-2.0-flash-exp",
                "gemini-2.0-flash",
            ]
            genai.configure(api_key=self.gemini_api_key)

            for model_name in model_options:
                try:
                    self.gemini_model_instance = genai.GenerativeModel(
                        model_name=model_name,
                        system_instruction=self.SYSTEM_PROMPT,
                        generation_config=genai.GenerationConfig(
                            max_output_tokens=self.max_tokens,
                            temperature=self.temperature,
                        )
                    )
                    self.gemini_model = model_name
                    logger.info(f"Gemini client initialized with model: {model_name}")
                    break
                except Exception as e:
                    logger.warning(f"Failed to initialize Gemini with model {model_name}: {e}")
                    continue

            if not self.gemini_model_instance:
                logger.error("Failed to initialize any Gemini model")

        if OPENAI_AVAILABLE and self.openai_api_key:
            self.openai_client = openai.OpenAI(api_key=self.openai_api_key)
            logger.info("OpenAI client initialized as fallback")

        # Rate limiting (in-memory, consider Redis for production)
        self.rate_limits: Dict[str, List[datetime]] = {}
        self.rate_limit_max = int(os.getenv("CHAT_RATE_LIMIT", "15"))  # Gemini free tier: 15/min
        self.rate_limit_window = 60  # seconds

        # Token encoder for counting
        self.encoder = None
        if TIKTOKEN_AVAILABLE:
            try:
                self.encoder = tiktoken.get_encoding("cl100k_base")
            except Exception as e:
                logger.warning(f"Failed to load tiktoken encoder: {e}")

    def count_tokens(self, text: str) -> int:
        """Count tokens in text"""
        if self.encoder:
            return len(self.encoder.encode(text))
        # Rough estimate: ~4 characters per token
        return len(text) // 4

    def check_rate_limit(self, user_id: str) -> bool:
        """Check if user is within rate limit. Returns True if allowed."""
        now = datetime.now()
        window_start = now - timedelta(seconds=self.rate_limit_window)

        # Clean old entries
        if user_id in self.rate_limits:
            self.rate_limits[user_id] = [
                t for t in self.rate_limits[user_id] if t > window_start
            ]
        else:
            self.rate_limits[user_id] = []

        # Check limit
        if len(self.rate_limits[user_id]) >= self.rate_limit_max:
            return False

        # Record this request
        self.rate_limits[user_id].append(now)
        return True

    def should_escalate(self, message: str, confidence: float = 1.0) -> Tuple[bool, Optional[str]]:
        """Check if conversation should be escalated to human agent"""
        message_lower = message.lower()

        # Check for explicit human request
        for keyword in self.HUMAN_REQUEST_KEYWORDS:
            if keyword in message_lower:
                return True, "user_request"

        # Check for sensitive topics
        for topic in self.SENSITIVE_TOPICS:
            if topic in message_lower:
                return True, "sensitive_topic"

        # Check confidence threshold
        if confidence < 0.3:
            return True, "low_confidence"

        return False, None

    def build_context_messages(
        self,
        message: str,
        conversation_history: List[Dict[str, Any]],
        user_context: Optional[Dict[str, Any]] = None
    ) -> List[Dict[str, str]]:
        """Build message list with conversation context"""
        messages = []

        # Add system context about user if available
        if user_context:
            context_str = f"\n\nCurrent user context:\n"
            if user_context.get("user_name"):
                context_str += f"- Name: {user_context['user_name']}\n"
            if user_context.get("user_role"):
                context_str += f"- Role: {user_context['user_role']}\n"
            if user_context.get("current_page"):
                context_str += f"- Currently viewing: {user_context['current_page']}\n"
            if user_context.get("pending_items"):
                context_str += f"- Pending items: {', '.join(user_context['pending_items'])}\n"
        else:
            context_str = ""

        # Add recent conversation history (last N messages)
        recent_history = conversation_history[-self.context_window:] if conversation_history else []
        for msg in recent_history:
            role = "user" if msg.get("sender") == "user" else "model"
            messages.append({
                "role": role,
                "parts": [msg.get("content", "")]
            })

        # Add current message
        messages.append({
            "role": "user",
            "parts": [message + context_str]
        })

        return messages

    async def get_gemini_response(
        self,
        messages: List[Dict[str, Any]]
    ) -> Optional[ChatResponse]:
        """Get response from Google Gemini API"""
        if not self.gemini_model_instance:
            return None

        try:
            # Build chat history for Gemini
            history = []
            current_message = None

            for msg in messages:
                if msg == messages[-1]:
                    # Last message is the current user message
                    current_message = msg["parts"][0] if msg["parts"] else ""
                else:
                    history.append({
                        "role": msg["role"],
                        "parts": msg["parts"]
                    })

            # Start chat with history
            chat = self.gemini_model_instance.start_chat(history=history)

            # Send current message
            response = await asyncio.to_thread(
                chat.send_message,
                current_message
            )

            content = response.text

            # Estimate tokens (Gemini doesn't always return token counts in free tier)
            tokens_used = self.count_tokens(current_message) + self.count_tokens(content)

            # Estimate confidence based on response characteristics
            confidence = self._estimate_confidence(content)

            return ChatResponse(
                content=content,
                provider=AIProvider.GEMINI,
                confidence=confidence,
                tokens_used=tokens_used,
                quick_actions=self._extract_quick_actions(content),
                metadata={"model": self.gemini_model}
            )

        except Exception as e:
            logger.error(f"Gemini error: {e}", exc_info=True)
            return None

    async def get_openai_response(
        self,
        messages: List[Dict[str, str]]
    ) -> Optional[ChatResponse]:
        """Get response from OpenAI API (fallback)"""
        if not self.openai_client:
            return None

        try:
            # Convert to OpenAI format
            openai_messages = [
                {"role": "system", "content": self.SYSTEM_PROMPT}
            ]
            for msg in messages:
                role = "user" if msg["role"] == "user" else "assistant"
                content = msg["parts"][0] if isinstance(msg.get("parts"), list) else msg.get("content", "")
                openai_messages.append({
                    "role": role,
                    "content": content
                })

            response = await asyncio.to_thread(
                self.openai_client.chat.completions.create,
                model=self.openai_model,
                messages=openai_messages,
                max_tokens=self.max_tokens,
                temperature=self.temperature
            )

            content = response.choices[0].message.content
            tokens_used = response.usage.total_tokens if response.usage else 0

            # Estimate confidence
            confidence = self._estimate_confidence(content)

            return ChatResponse(
                content=content,
                provider=AIProvider.OPENAI,
                confidence=confidence,
                tokens_used=tokens_used,
                quick_actions=self._extract_quick_actions(content),
                metadata={"model": self.openai_model}
            )

        except Exception as e:
            logger.error(f"OpenAI error: {e}", exc_info=True)
            return None

    def _estimate_confidence(self, response: str) -> float:
        """Estimate confidence based on response characteristics"""
        confidence = 0.8  # Base confidence

        response_lower = response.lower()

        # Lower confidence indicators
        uncertainty_phrases = [
            "i'm not sure", "i don't know", "i'm uncertain",
            "might be", "could be", "possibly", "perhaps",
            "i think", "i believe", "contact support"
        ]
        for phrase in uncertainty_phrases:
            if phrase in response_lower:
                confidence -= 0.15

        # Higher confidence indicators
        confident_phrases = [
            "you can", "to do this", "here's how", "follow these steps"
        ]
        for phrase in confident_phrases:
            if phrase in response_lower:
                confidence += 0.05

        return max(0.1, min(1.0, confidence))

    def _extract_quick_actions(self, response: str) -> Optional[List[Dict[str, Any]]]:
        """Extract or suggest quick actions based on response content"""
        actions = []
        response_lower = response.lower()

        # Map keywords to quick actions
        action_triggers = {
            "sign up": {"id": "register", "label": "Sign Up", "action": "navigate_register"},
            "register": {"id": "register", "label": "Sign Up", "action": "navigate_register"},
            "contact support": {"id": "support", "label": "Contact Support", "action": "email_support"},
            "email us": {"id": "support", "label": "Email Support", "action": "email_support"},
            "browse courses": {"id": "courses", "label": "Browse Courses", "action": "navigate_courses"},
            "view applications": {"id": "applications", "label": "My Applications", "action": "navigate_applications"},
        }

        for trigger, action in action_triggers.items():
            if trigger in response_lower and action not in actions:
                actions.append(action)
                if len(actions) >= 3:  # Max 3 quick actions
                    break

        return actions if actions else None

    async def get_response(
        self,
        message: str,
        conversation_history: List[Dict[str, Any]] = None,
        user_context: Optional[Dict[str, Any]] = None,
        user_id: Optional[str] = None
    ) -> ChatResponse:
        """
        Get AI response with fallback chain:
        1. Gemini (primary - free tier)
        2. OpenAI (fallback - if configured)
        3. FAQ matching (final fallback)
        """
        # Check rate limit
        if user_id and not self.check_rate_limit(user_id):
            return ChatResponse(
                content="You're sending messages too quickly. Please wait a moment before trying again.",
                provider=AIProvider.NONE,
                confidence=1.0,
                tokens_used=0,
                should_escalate=False
            )

        # Build context messages
        messages = self.build_context_messages(
            message,
            conversation_history or [],
            user_context
        )

        response = None

        # Try Gemini first (free tier)
        if self.gemini_model_instance:
            try:
                response = await asyncio.wait_for(
                    self.get_gemini_response(messages),
                    timeout=self.timeout
                )
                if response:
                    logger.info("Response generated by Gemini")
            except asyncio.TimeoutError:
                logger.warning("Gemini request timed out, trying fallback")

        # Fallback to OpenAI if configured
        if not response and self.openai_client:
            try:
                response = await asyncio.wait_for(
                    self.get_openai_response(messages),
                    timeout=self.timeout
                )
                if response:
                    logger.info("Response generated by OpenAI (fallback)")
            except asyncio.TimeoutError:
                logger.warning("OpenAI request timed out")

        # Final fallback to FAQ matching
        if not response:
            response = await self.get_faq_response(message)

        # Check if we should escalate
        if response:
            should_esc, reason = self.should_escalate(message, response.confidence)
            response.should_escalate = should_esc
            response.escalation_reason = reason

        return response

    async def get_faq_response(self, message: str) -> ChatResponse:
        """Get response from FAQ database (final fallback)"""
        # This would query the chatbot_faqs table
        # For now, return a generic fallback
        fallback_content = """I apologize, but I'm having trouble processing your request right now.

Here are some things you can try:
- Rephrase your question
- Check our Help Center for common topics
- Contact our support team for personalized assistance

Would you like me to connect you with a human agent?"""

        return ChatResponse(
            content=fallback_content,
            provider=AIProvider.FAQ,
            confidence=0.3,
            tokens_used=0,
            quick_actions=[
                {"id": "support", "label": "Talk to Human", "action": "escalate"},
                {"id": "help", "label": "Help Center", "action": "navigate_help"}
            ],
            should_escalate=True,
            escalation_reason="ai_unavailable"
        )

    async def generate_summary(self, messages: List[Dict[str, Any]]) -> str:
        """Generate a summary of the conversation"""
        if not messages:
            return ""

        # Extract just the text content
        content = "\n".join([
            f"{m.get('sender', 'unknown')}: {m.get('content', '')}"
            for m in messages[:20]  # Limit to first 20 messages
        ])

        prompt = f"Summarize this conversation in 1-2 sentences:\n\n{content}"

        try:
            if self.gemini_model_instance:
                response = await asyncio.to_thread(
                    self.gemini_model_instance.generate_content,
                    prompt
                )
                return response.text
        except Exception as e:
            logger.error(f"Failed to generate summary: {e}")

        # Fallback: use first user message
        for m in messages:
            if m.get("sender") == "user":
                text = m.get("content", "")
                return text[:100] + "..." if len(text) > 100 else text

        return "Conversation"

    async def extract_topics(self, messages: List[Dict[str, Any]]) -> List[str]:
        """Extract main topics from conversation"""
        topics = set()

        # Simple keyword extraction
        topic_keywords = {
            "application": ["application", "apply", "admission", "deadline"],
            "courses": ["course", "class", "lesson", "learning"],
            "university": ["university", "college", "school", "institution"],
            "pricing": ["price", "cost", "fee", "payment", "subscription"],
            "account": ["account", "profile", "settings", "password"],
            "technical": ["error", "bug", "not working", "problem", "issue"],
            "counseling": ["counselor", "guidance", "advice", "session"],
        }

        # Check all messages
        for msg in messages:
            content = msg.get("content", "").lower()
            for topic, keywords in topic_keywords.items():
                if any(kw in content for kw in keywords):
                    topics.add(topic)

        return list(topics)


# Singleton instance
_ai_chat_service: Optional[AIChatService] = None


def get_ai_chat_service() -> AIChatService:
    """Get or create AI chat service instance"""
    global _ai_chat_service
    if _ai_chat_service is None:
        _ai_chat_service = AIChatService()
    return _ai_chat_service

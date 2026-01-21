-- =============================================
-- Page Contents CMS Schema
-- Enables admin-editable footer pages
-- =============================================

-- Create page_contents table for storing editable page content
CREATE TABLE IF NOT EXISTS page_contents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    page_slug VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    subtitle VARCHAR(500),
    content JSONB NOT NULL DEFAULT '{}',
    meta_description VARCHAR(300),
    status VARCHAR(20) DEFAULT 'published' CHECK (status IN ('draft', 'published', 'archived')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);

-- Create index for faster slug lookups
CREATE INDEX IF NOT EXISTS idx_page_contents_slug ON page_contents(page_slug);
CREATE INDEX IF NOT EXISTS idx_page_contents_status ON page_contents(status);

-- Create trigger to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_page_contents_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_page_contents_updated_at ON page_contents;
CREATE TRIGGER trigger_update_page_contents_updated_at
    BEFORE UPDATE ON page_contents
    FOR EACH ROW
    EXECUTE FUNCTION update_page_contents_updated_at();

-- Enable Row Level Security
ALTER TABLE page_contents ENABLE ROW LEVEL SECURITY;

-- Public can read published pages (no auth required)
DROP POLICY IF EXISTS "Public can read published pages" ON page_contents;
CREATE POLICY "Public can read published pages" ON page_contents
    FOR SELECT
    USING (status = 'published');

-- Admins can manage all content
DROP POLICY IF EXISTS "Admins can manage pages" ON page_contents;
CREATE POLICY "Admins can manage pages" ON page_contents
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM user_roles
            WHERE user_id = auth.uid()
            AND role IN ('SuperAdmin', 'ContentAdmin', 'Admin')
        )
    );

-- =============================================
-- Seed initial content for all 16 footer pages
-- =============================================

INSERT INTO page_contents (page_slug, title, subtitle, content, meta_description, status)
VALUES
-- About Page
('about', 'About Flow EdTech', 'Empowering students to find their perfect educational path',
'{
    "mission": "Our mission is to democratize access to higher education by providing intelligent, personalized guidance to students worldwide.",
    "vision": "We envision a world where every student has the tools and knowledge to make informed decisions about their educational journey.",
    "story": "Flow EdTech was founded in 2023 by a team of education enthusiasts and technologists who experienced firsthand the challenges of navigating the complex world of higher education. Our platform leverages cutting-edge AI and machine learning to match students with universities and programs that align with their unique goals, interests, and circumstances.",
    "values": [
        {"title": "Student-First", "description": "Every decision we make prioritizes student success and wellbeing."},
        {"title": "Innovation", "description": "We continuously push boundaries to improve how students discover opportunities."},
        {"title": "Accessibility", "description": "Education guidance should be available to everyone, regardless of background."},
        {"title": "Transparency", "description": "We believe in honest, clear information to help students make informed decisions."}
    ],
    "team": [
        {"name": "Leadership Team", "description": "Our executive team brings decades of combined experience in education technology and student success."}
    ]
}'::jsonb,
'Learn about Flow EdTech''s mission to help students find their perfect educational path through AI-powered guidance.',
'published'),

-- Contact Page
('contact', 'Contact Us', 'We''d love to hear from you',
'{
    "email": "support@flowedtech.com",
    "phone": "+1 (555) 123-4567",
    "address": {
        "street": "123 Education Lane",
        "city": "San Francisco",
        "state": "CA",
        "zip": "94105",
        "country": "United States"
    },
    "social_links": {
        "twitter": "https://twitter.com/flowedtech",
        "linkedin": "https://linkedin.com/company/flowedtech",
        "facebook": "https://facebook.com/flowedtech",
        "instagram": "https://instagram.com/flowedtech"
    },
    "support_hours": "Monday - Friday, 9:00 AM - 6:00 PM PST",
    "response_time": "We typically respond within 24 hours"
}'::jsonb,
'Get in touch with Flow EdTech. Contact us for support, partnerships, or general inquiries.',
'published'),

-- Privacy Policy
('privacy', 'Privacy Policy', 'Your privacy matters to us',
'{
    "last_updated": "2024-01-15",
    "sections": [
        {
            "title": "Information We Collect",
            "content": "We collect information you provide directly to us, such as when you create an account, fill out a form, or communicate with us. This includes your name, email address, educational background, and preferences."
        },
        {
            "title": "How We Use Your Information",
            "content": "We use the information we collect to provide, maintain, and improve our services, to personalize your experience, to communicate with you, and to comply with legal obligations."
        },
        {
            "title": "Information Sharing",
            "content": "We do not sell your personal information. We may share your information with educational institutions you express interest in, service providers who assist our operations, and when required by law."
        },
        {
            "title": "Data Security",
            "content": "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction."
        },
        {
            "title": "Your Rights",
            "content": "You have the right to access, correct, or delete your personal information. You may also opt out of certain communications and data processing activities."
        },
        {
            "title": "Contact Us",
            "content": "If you have questions about this Privacy Policy, please contact us at privacy@flowedtech.com."
        }
    ]
}'::jsonb,
'Flow EdTech Privacy Policy - Learn how we collect, use, and protect your personal information.',
'published'),

-- Terms of Service
('terms', 'Terms of Service', 'Please read these terms carefully',
'{
    "last_updated": "2024-01-15",
    "sections": [
        {
            "title": "Acceptance of Terms",
            "content": "By accessing or using Flow EdTech services, you agree to be bound by these Terms of Service and all applicable laws and regulations."
        },
        {
            "title": "Use of Services",
            "content": "You may use our services only for lawful purposes and in accordance with these Terms. You agree not to misuse our services or help anyone else do so."
        },
        {
            "title": "User Accounts",
            "content": "You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account."
        },
        {
            "title": "Intellectual Property",
            "content": "The service and its original content, features, and functionality are owned by Flow EdTech and are protected by international copyright, trademark, and other intellectual property laws."
        },
        {
            "title": "Limitation of Liability",
            "content": "Flow EdTech shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service."
        },
        {
            "title": "Changes to Terms",
            "content": "We reserve the right to modify these terms at any time. We will notify users of any material changes via email or through the platform."
        }
    ]
}'::jsonb,
'Flow EdTech Terms of Service - Understand the terms and conditions of using our platform.',
'published'),

-- Cookies Policy
('cookies', 'Cookie Policy', 'How we use cookies',
'{
    "last_updated": "2024-01-15",
    "sections": [
        {
            "title": "What Are Cookies",
            "content": "Cookies are small text files that are placed on your device when you visit our website. They help us provide you with a better experience by remembering your preferences and understanding how you use our services."
        },
        {
            "title": "Types of Cookies We Use",
            "content": "We use essential cookies (required for the site to function), analytics cookies (to understand usage patterns), functional cookies (to remember your preferences), and marketing cookies (to deliver relevant content)."
        },
        {
            "title": "Managing Cookies",
            "content": "You can control and manage cookies through your browser settings. Please note that disabling certain cookies may affect the functionality of our services."
        },
        {
            "title": "Third-Party Cookies",
            "content": "Some cookies are placed by third-party services that appear on our pages, such as analytics providers and advertising partners."
        }
    ]
}'::jsonb,
'Flow EdTech Cookie Policy - Learn about the cookies we use and how to manage them.',
'published'),

-- Data Protection
('data-protection', 'Data Protection', 'How we protect your data',
'{
    "last_updated": "2024-01-15",
    "sections": [
        {
            "title": "Our Commitment",
            "content": "Flow EdTech is committed to protecting your personal data and respecting your privacy. We comply with applicable data protection laws including GDPR and CCPA."
        },
        {
            "title": "Data Collection",
            "content": "We collect only the data necessary to provide our services. This includes account information, educational preferences, and usage data to improve your experience."
        },
        {
            "title": "Data Storage",
            "content": "Your data is stored securely on encrypted servers. We implement industry-standard security measures to protect against unauthorized access."
        },
        {
            "title": "Data Retention",
            "content": "We retain your data only for as long as necessary to provide our services or as required by law. You can request deletion of your data at any time."
        },
        {
            "title": "Your Rights",
            "content": "You have the right to access, rectify, erase, restrict processing, data portability, and object to processing of your personal data."
        }
    ]
}'::jsonb,
'Flow EdTech Data Protection - Understand how we protect and manage your personal data.',
'published'),

-- Compliance
('compliance', 'Compliance', 'Our regulatory compliance',
'{
    "last_updated": "2024-01-15",
    "sections": [
        {
            "title": "Regulatory Framework",
            "content": "Flow EdTech operates in compliance with international education regulations, data protection laws, and consumer protection standards."
        },
        {
            "title": "GDPR Compliance",
            "content": "We are fully compliant with the General Data Protection Regulation (GDPR) for users in the European Economic Area."
        },
        {
            "title": "CCPA Compliance",
            "content": "California residents have specific rights under the California Consumer Privacy Act (CCPA), which we fully respect and implement."
        },
        {
            "title": "FERPA Compliance",
            "content": "We comply with the Family Educational Rights and Privacy Act (FERPA) when handling educational records."
        },
        {
            "title": "Accessibility",
            "content": "We strive to make our platform accessible to all users, following WCAG 2.1 guidelines."
        }
    ]
}'::jsonb,
'Flow EdTech Compliance - Learn about our commitment to regulatory compliance and standards.',
'published'),

-- Careers
('careers', 'Careers at Flow EdTech', 'Join our mission to transform education',
'{
    "intro": "At Flow EdTech, we are building the future of education technology. Join our team of passionate innovators and help students worldwide achieve their educational dreams.",
    "benefits": [
        {"title": "Competitive Compensation", "description": "Salary packages that recognize your skills and contributions"},
        {"title": "Remote-First Culture", "description": "Work from anywhere with flexible hours"},
        {"title": "Health & Wellness", "description": "Comprehensive health insurance and wellness programs"},
        {"title": "Learning Budget", "description": "Annual budget for courses, conferences, and professional development"},
        {"title": "Equity Options", "description": "Share in our success with stock options"},
        {"title": "Paid Time Off", "description": "Generous vacation policy and paid holidays"}
    ],
    "positions": [
        {"title": "Senior Frontend Engineer", "department": "Engineering", "location": "Remote", "type": "Full-time"},
        {"title": "Product Designer", "department": "Design", "location": "Remote", "type": "Full-time"},
        {"title": "Data Scientist", "department": "AI/ML", "location": "Remote", "type": "Full-time"},
        {"title": "Education Content Specialist", "department": "Content", "location": "Remote", "type": "Full-time"}
    ],
    "application_email": "careers@flowedtech.com"
}'::jsonb,
'Join Flow EdTech - Explore career opportunities and help transform education technology.',
'published'),

-- Press
('press', 'Press & Media', 'News and media resources',
'{
    "intro": "Welcome to the Flow EdTech press center. Here you will find our latest news, press releases, and media resources.",
    "kit_url": "/downloads/flow-edtech-press-kit.zip",
    "contacts": [
        {"name": "Media Relations", "email": "press@flowedtech.com", "phone": "+1 (555) 123-4568"}
    ],
    "releases": [
        {
            "title": "Flow EdTech Raises Series A Funding",
            "date": "2024-01-10",
            "excerpt": "Flow EdTech announces $10M Series A funding to expand AI-powered education matching platform."
        },
        {
            "title": "Platform Reaches 100,000 Student Users",
            "date": "2023-11-15",
            "excerpt": "Flow EdTech celebrates milestone of helping over 100,000 students find their educational path."
        },
        {
            "title": "Partnership with Leading Universities Announced",
            "date": "2023-09-20",
            "excerpt": "Flow EdTech partners with 50+ universities to provide direct application pathways for students."
        }
    ],
    "media_assets": {
        "logos": "/downloads/logos.zip",
        "screenshots": "/downloads/screenshots.zip",
        "founder_photos": "/downloads/team-photos.zip"
    }
}'::jsonb,
'Flow EdTech Press Center - Latest news, press releases, and media resources.',
'published'),

-- Partners
('partners', 'Partner With Us', 'Grow together with Flow EdTech',
'{
    "intro": "Partner with Flow EdTech to reach motivated students and expand your educational offerings. We work with institutions, organizations, and technology providers worldwide.",
    "partner_types": [
        {
            "type": "Educational Institutions",
            "description": "Universities, colleges, and schools can list programs and connect directly with qualified applicants.",
            "benefits": ["Direct applicant pipeline", "Enhanced visibility", "Application management tools", "Analytics dashboard"]
        },
        {
            "type": "Corporate Partners",
            "description": "Companies can sponsor scholarships, internships, and career development programs.",
            "benefits": ["Talent pipeline access", "Brand visibility", "CSR opportunities", "Custom programs"]
        },
        {
            "type": "Technology Partners",
            "description": "EdTech companies can integrate with our platform to extend functionality.",
            "benefits": ["API access", "Joint marketing", "Revenue sharing", "Technical support"]
        }
    ],
    "current_partners": [
        {"name": "Partner universities and institutions worldwide", "count": "500+"}
    ],
    "contact_email": "partners@flowedtech.com"
}'::jsonb,
'Partner with Flow EdTech - Explore partnership opportunities for institutions and organizations.',
'published'),

-- Help Center
('help', 'Help Center', 'Find answers to your questions',
'{
    "intro": "Welcome to the Flow EdTech Help Center. Find answers to common questions or contact our support team for assistance.",
    "faqs": [
        {
            "category": "Account",
            "question": "How do I create an account?",
            "answer": "Click the Sign Up button on the homepage and follow the registration process. You will need to provide your email address and create a password."
        },
        {
            "category": "Account",
            "question": "How do I reset my password?",
            "answer": "Click Forgot Password on the login page and enter your email address. We will send you a link to reset your password."
        },
        {
            "category": "Applications",
            "question": "How do I track my applications?",
            "answer": "Log into your account and navigate to the Applications section in your dashboard. You can see the status of all your applications there."
        },
        {
            "category": "Applications",
            "question": "Can I withdraw an application?",
            "answer": "Yes, you can withdraw an application at any time before a decision is made. Go to your Applications dashboard and click Withdraw on the relevant application."
        },
        {
            "category": "Recommendations",
            "question": "How does the recommendation system work?",
            "answer": "Our AI analyzes your profile, preferences, academic background, and goals to suggest programs and institutions that best match your criteria."
        },
        {
            "category": "Billing",
            "question": "Is Flow EdTech free to use?",
            "answer": "Basic features are free for all students. Premium features and services may require a subscription or one-time payment."
        }
    ],
    "support_email": "support@flowedtech.com",
    "support_hours": "Monday - Friday, 9:00 AM - 6:00 PM PST"
}'::jsonb,
'Flow EdTech Help Center - Find answers to common questions and get support.',
'published'),

-- Documentation
('docs', 'Documentation', 'Platform documentation and guides',
'{
    "intro": "Welcome to the Flow EdTech documentation. Here you will find comprehensive guides on using our platform.",
    "sections": [
        {
            "title": "Getting Started",
            "content": "New to Flow EdTech? Start here to learn how to create your account, complete your profile, and begin exploring educational opportunities.",
            "code_examples": []
        },
        {
            "title": "Profile Setup",
            "content": "A complete profile helps our AI provide better recommendations. Learn how to add your academic history, test scores, interests, and career goals.",
            "code_examples": []
        },
        {
            "title": "Exploring Programs",
            "content": "Use our search and filter tools to discover programs that match your criteria. Save favorites and compare options side by side.",
            "code_examples": []
        },
        {
            "title": "Applications",
            "content": "Apply directly through Flow EdTech to participating institutions. Track your application status and receive updates in real-time.",
            "code_examples": []
        },
        {
            "title": "Recommendations",
            "content": "Understand how our recommendation engine works and how to improve the suggestions you receive.",
            "code_examples": []
        }
    ]
}'::jsonb,
'Flow EdTech Documentation - Guides and tutorials for using our platform.',
'published'),

-- API Documentation
('api-docs', 'API Documentation', 'Developer documentation and API reference',
'{
    "intro": "Welcome to the Flow EdTech API documentation. Our API allows partners to integrate with our platform and access educational data.",
    "base_url": "https://api.flowedtech.com/v1",
    "authentication": "All API requests require authentication via API key or OAuth 2.0 token.",
    "sections": [
        {
            "title": "Authentication",
            "content": "Learn how to authenticate your API requests using API keys or OAuth 2.0.",
            "code_examples": [
                {
                    "language": "curl",
                    "code": "curl -H \"Authorization: Bearer YOUR_API_KEY\" https://api.flowedtech.com/v1/programs"
                }
            ]
        },
        {
            "title": "Programs Endpoint",
            "content": "Retrieve information about educational programs, including search and filtering capabilities.",
            "code_examples": [
                {
                    "language": "curl",
                    "code": "curl https://api.flowedtech.com/v1/programs?country=USA&level=masters"
                }
            ]
        },
        {
            "title": "Institutions Endpoint",
            "content": "Access data about educational institutions, including profiles and program offerings.",
            "code_examples": [
                {
                    "language": "curl",
                    "code": "curl https://api.flowedtech.com/v1/institutions/{id}"
                }
            ]
        },
        {
            "title": "Rate Limits",
            "content": "API requests are limited to 1000 requests per hour for standard accounts. Contact us for higher limits.",
            "code_examples": []
        }
    ],
    "support_email": "api-support@flowedtech.com"
}'::jsonb,
'Flow EdTech API Documentation - Developer guides and API reference.',
'published'),

-- Community
('community', 'Community', 'Join our global community',
'{
    "intro": "Connect with fellow students, alumni, and education enthusiasts in the Flow EdTech community.",
    "forums": [
        {"name": "General Discussion", "description": "Chat about anything education-related", "url": "/community/general"},
        {"name": "Application Tips", "description": "Share and learn application strategies", "url": "/community/applications"},
        {"name": "Country-Specific", "description": "Connect with students in your target country", "url": "/community/countries"},
        {"name": "Program Reviews", "description": "Read and write reviews about programs", "url": "/community/reviews"}
    ],
    "events": [
        {"name": "Monthly Webinars", "description": "Live sessions with admissions officers and education experts"},
        {"name": "Virtual Fairs", "description": "Connect with universities from around the world"},
        {"name": "Peer Mentorship", "description": "Get guidance from students who have been through the process"}
    ],
    "social_links": {
        "discord": "https://discord.gg/flowedtech",
        "reddit": "https://reddit.com/r/flowedtech",
        "twitter": "https://twitter.com/flowedtech"
    },
    "newsletter_signup": true
}'::jsonb,
'Flow EdTech Community - Connect with students and education enthusiasts worldwide.',
'published'),

-- Blog
('blog', 'Blog', 'Insights and updates from Flow EdTech',
'{
    "intro": "Stay updated with the latest insights on education, application tips, and Flow EdTech news.",
    "categories": ["Education News", "Application Tips", "Student Stories", "Product Updates", "Industry Insights"],
    "featured_posts": [
        {
            "title": "Top 10 Tips for Your University Application",
            "excerpt": "Expert advice on crafting a standout application that gets noticed by admissions committees.",
            "author": "Sarah Chen",
            "date": "2024-01-08",
            "category": "Application Tips",
            "slug": "top-10-application-tips"
        },
        {
            "title": "How AI is Transforming Education Matching",
            "excerpt": "Discover how machine learning helps students find their perfect educational fit.",
            "author": "Michael Johnson",
            "date": "2024-01-05",
            "category": "Industry Insights",
            "slug": "ai-education-matching"
        },
        {
            "title": "Student Success Story: From Flow to Harvard",
            "excerpt": "Read how one student used Flow EdTech to navigate their path to an Ivy League acceptance.",
            "author": "Emily Rodriguez",
            "date": "2024-01-02",
            "category": "Student Stories",
            "slug": "student-success-harvard"
        }
    ],
    "subscribe_cta": "Subscribe to our newsletter for weekly education insights."
}'::jsonb,
'Flow EdTech Blog - Education insights, application tips, and student success stories.',
'published'),

-- Mobile Apps
('mobile-apps', 'Mobile Apps', 'Flow EdTech on the go',
'{
    "intro": "Take Flow EdTech with you wherever you go. Our mobile apps give you full access to your educational journey from your smartphone or tablet.",
    "features": [
        {"title": "Push Notifications", "description": "Get instant updates on application status changes and deadlines"},
        {"title": "Offline Access", "description": "Save programs and information for viewing without internet"},
        {"title": "Document Scanner", "description": "Scan and upload documents directly from your device"},
        {"title": "Biometric Login", "description": "Secure access with fingerprint or face recognition"},
        {"title": "Dark Mode", "description": "Comfortable viewing in any lighting condition"}
    ],
    "requirements": {
        "ios": "iOS 14.0 or later",
        "android": "Android 8.0 or later"
    },
    "download_links": {
        "app_store": "https://apps.apple.com/app/flowedtech",
        "play_store": "https://play.google.com/store/apps/details?id=com.flowedtech"
    },
    "qr_codes": {
        "ios": "/images/qr-ios.png",
        "android": "/images/qr-android.png"
    }
}'::jsonb,
'Download Flow EdTech mobile apps for iOS and Android.',
'published')

ON CONFLICT (page_slug) DO UPDATE SET
    title = EXCLUDED.title,
    subtitle = EXCLUDED.subtitle,
    content = EXCLUDED.content,
    meta_description = EXCLUDED.meta_description,
    status = EXCLUDED.status,
    updated_at = NOW();

-- Grant permissions
GRANT SELECT ON page_contents TO anon;
GRANT SELECT ON page_contents TO authenticated;
GRANT ALL ON page_contents TO service_role;

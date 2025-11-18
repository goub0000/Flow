"""
Scheduled Reports Service
Processes and sends automated reports on schedule
"""
import asyncio
import logging
from typing import List, Dict, Any, Optional
from datetime import datetime
from supabase import create_client, Client
import os
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail, Attachment, FileContent, FileName, FileType, Disposition
import base64
import json

logger = logging.getLogger(__name__)


class ScheduledReportsService:
    """Service for processing scheduled reports"""

    def __init__(self):
        self.supabase: Client = create_client(
            os.getenv("SUPABASE_URL"),
            os.getenv("SUPABASE_SERVICE_KEY")  # Use service role key for admin operations
        )
        self.sendgrid_api_key = os.getenv("SENDGRID_API_KEY")
        self.from_email = os.getenv("REPORT_FROM_EMAIL", "reports@flow.com")

    async def process_due_reports(self) -> Dict[str, Any]:
        """
        Process all scheduled reports that are due
        Returns statistics about processed reports
        """
        stats = {
            "processed": 0,
            "succeeded": 0,
            "failed": 0,
            "errors": []
        }

        try:
            # Get all active reports that are due
            response = self.supabase.table("scheduled_reports") \
                .select("*") \
                .eq("is_active", True) \
                .lte("next_run_at", datetime.now().isoformat()) \
                .execute()

            reports = response.data
            logger.info(f"Found {len(reports)} reports due for processing")

            for report in reports:
                stats["processed"] += 1
                try:
                    await self._process_single_report(report)
                    stats["succeeded"] += 1
                    logger.info(f"Successfully processed report: {report['title']}")
                except Exception as e:
                    stats["failed"] += 1
                    error_msg = f"Failed to process report '{report['title']}': {str(e)}"
                    stats["errors"].append(error_msg)
                    logger.error(error_msg)

                    # Mark as failed in database
                    self.supabase.rpc("mark_report_executed", {
                        "report_id": report["id"],
                        "execution_status": "failed",
                        "error_msg": str(e)
                    }).execute()

        except Exception as e:
            logger.error(f"Error in process_due_reports: {str(e)}")
            stats["errors"].append(f"Main process error: {str(e)}")

        return stats

    async def _process_single_report(self, report: Dict[str, Any]) -> None:
        """Process a single scheduled report"""
        report_id = report["id"]

        try:
            # Generate report data
            report_data = await self._generate_report_data(report)

            # Generate report file based on format
            file_content, file_name = await self._generate_report_file(
                report, report_data
            )

            # Send email to recipients
            await self._send_report_email(
                recipients=report["recipients"],
                subject=f"Scheduled Report: {report['title']}",
                report_title=report["title"],
                description=report.get("description"),
                file_content=file_content,
                file_name=file_name,
                format=report["format"]
            )

            # Mark as completed
            self.supabase.rpc("mark_report_executed", {
                "report_id": report_id,
                "execution_status": "completed"
            }).execute()

        except Exception as e:
            logger.error(f"Error processing report {report_id}: {str(e)}")
            raise

    async def _generate_report_data(self, report: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generate report data by fetching metrics
        """
        metrics = report["metrics"]
        report_data = {}

        for metric in metrics:
            try:
                value = await self._fetch_metric_value(metric, report["frequency"])
                report_data[metric] = value
            except Exception as e:
                logger.warning(f"Failed to fetch metric '{metric}': {str(e)}")
                report_data[metric] = "N/A"

        return report_data

    async def _fetch_metric_value(self, metric: str, frequency: str) -> Any:
        """
        Fetch a specific metric value
        This should be customized based on your actual data structure
        """
        # Example implementations - customize based on your needs
        if metric == "total_users":
            response = self.supabase.table("profiles").select("id", count="exact").execute()
            return response.count

        elif metric == "new_registrations":
            # Get registrations based on frequency
            days = {"daily": 1, "weekly": 7, "monthly": 30}.get(frequency, 7)
            from datetime import timedelta
            since = (datetime.now() - timedelta(days=days)).isoformat()

            response = self.supabase.table("profiles") \
                .select("id", count="exact") \
                .gte("created_at", since) \
                .execute()
            return response.count

        elif metric == "total_applications":
            response = self.supabase.table("applications").select("id", count="exact").execute()
            return response.count

        elif metric == "application_acceptance_rate":
            # Calculate acceptance rate
            total_response = self.supabase.table("applications").select("id", count="exact").execute()
            accepted_response = self.supabase.table("applications") \
                .select("id", count="exact") \
                .eq("status", "accepted") \
                .execute()

            total = total_response.count or 0
            accepted = accepted_response.count or 0

            if total > 0:
                rate = (accepted / total) * 100
                return f"{rate:.1f}%"
            return "0%"

        elif metric == "active_sessions":
            # Example: Count users active in last 24 hours
            from datetime import timedelta
            since = (datetime.now() - timedelta(hours=24)).isoformat()

            response = self.supabase.table("profiles") \
                .select("id", count="exact") \
                .gte("last_seen_at", since) \
                .execute()
            return response.count

        elif metric == "revenue":
            # Placeholder - implement based on your payment system
            return "$0.00"

        elif metric == "user_engagement":
            # Placeholder - implement based on your engagement tracking
            return "N/A"

        elif metric == "conversion_rate":
            # Placeholder - implement based on your conversion tracking
            return "N/A"

        else:
            return "N/A"

    async def _generate_report_file(
        self, report: Dict[str, Any], report_data: Dict[str, Any]
    ) -> tuple[bytes, str]:
        """
        Generate report file in the specified format
        Returns (file_content, file_name)
        """
        format = report["format"]
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

        if format == "json":
            content = json.dumps({
                "title": report["title"],
                "description": report.get("description"),
                "generated_at": datetime.now().isoformat(),
                "frequency": report["frequency"],
                "metrics": report_data
            }, indent=2)
            return content.encode(), f"report_{timestamp}.json"

        elif format == "csv":
            # Generate CSV
            import csv
            import io

            output = io.StringIO()
            writer = csv.writer(output)

            # Header
            writer.writerow(["Metric", "Value"])

            # Data
            for key, value in report_data.items():
                metric_name = key.replace("_", " ").title()
                writer.writerow([metric_name, value])

            return output.getvalue().encode(), f"report_{timestamp}.csv"

        elif format == "pdf":
            # For PDF, we'd need additional libraries like reportlab
            # For now, return JSON and recommend adding PDF library
            logger.warning("PDF generation not fully implemented, returning JSON")
            content = json.dumps(report_data, indent=2)
            return content.encode(), f"report_{timestamp}.txt"

        else:
            raise ValueError(f"Unsupported format: {format}")

    async def _send_report_email(
        self,
        recipients: List[str],
        subject: str,
        report_title: str,
        description: Optional[str],
        file_content: bytes,
        file_name: str,
        format: str
    ) -> None:
        """
        Send report via email using SendGrid
        """
        if not self.sendgrid_api_key:
            logger.warning("SendGrid API key not configured, skipping email")
            return

        try:
            # Build email body
            html_content = f"""
            <html>
                <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
                    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                        <h2 style="color: #2563eb;">{report_title}</h2>
                        {f'<p style="color: #666;">{description}</p>' if description else ''}

                        <div style="background-color: #f3f4f6; padding: 15px; border-radius: 8px; margin: 20px 0;">
                            <p style="margin: 0;"><strong>Report Type:</strong> Scheduled {format.upper()} Report</p>
                            <p style="margin: 5px 0 0 0;"><strong>Generated:</strong> {datetime.now().strftime('%B %d, %Y at %I:%M %p')}</p>
                        </div>

                        <p>Please find your scheduled report attached to this email.</p>

                        <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 30px 0;">

                        <p style="font-size: 12px; color: #9ca3af;">
                            This is an automated report from Flow EdTech Platform.<br>
                            To manage your scheduled reports, please visit the admin dashboard.
                        </p>
                    </div>
                </body>
            </html>
            """

            # Create message
            message = Mail(
                from_email=self.from_email,
                to_emails=recipients,
                subject=subject,
                html_content=html_content
            )

            # Add attachment
            encoded_file = base64.b64encode(file_content).decode()

            attachment = Attachment(
                FileContent(encoded_file),
                FileName(file_name),
                FileType(self._get_mime_type(format)),
                Disposition('attachment')
            )
            message.attachment = attachment

            # Send email
            sg = SendGridAPIClient(self.sendgrid_api_key)
            response = sg.send(message)

            if response.status_code >= 200 and response.status_code < 300:
                logger.info(f"Email sent successfully to {len(recipients)} recipients")
            else:
                logger.error(f"Failed to send email: {response.status_code}")

        except Exception as e:
            logger.error(f"Error sending email: {str(e)}")
            raise

    def _get_mime_type(self, format: str) -> str:
        """Get MIME type for file format"""
        mime_types = {
            "pdf": "application/pdf",
            "csv": "text/csv",
            "json": "application/json"
        }
        return mime_types.get(format, "application/octet-stream")


# Singleton instance
_service_instance = None


def get_scheduled_reports_service() -> ScheduledReportsService:
    """Get or create the scheduled reports service instance"""
    global _service_instance
    if _service_instance is None:
        _service_instance = ScheduledReportsService()
    return _service_instance

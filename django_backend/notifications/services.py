from pyfcm import FCMNotification
from django.conf import settings
import logging

logger = logging.getLogger(__name__)

class NotificationService:
    def __init__(self):
        self.push_service = FCMNotification(api_key=settings.FCM_SERVER_KEY)
    
    @classmethod
    def send_to_single(cls, token, title, body, data=None):
        try:
            service = cls()
            result = service.push_service.notify_single_device(
                registration_id=token,
                message_title=title,
                message_body=body,
                data_message=data or {}
            )
            return result.get('success', 0) > 0
        except Exception as e:
            logger.error(f"خطأ في إرسال الإشعار: {e}")
            return False
    
    @classmethod
    def send_to_multiple(cls, tokens, title, body, data=None):
        try:
            service = cls()
            result = service.push_service.notify_multiple_devices(
                registration_ids=tokens,
                message_title=title,
                message_body=body,
                data_message=data or {}
            )
            return result.get('success', 0)
        except Exception as e:
            logger.error(f"خطأ في إرسال الإشعارات المتعددة: {e}")
            return 0
    
    @classmethod
    def send_to_topic(cls, topic, title, body, data=None):
        try:
            service = cls()
            result = service.push_service.notify_topic_subscribers(
                topic_name=topic,
                message_title=title,
                message_body=body,
                data_message=data or {}
            )
            return result.get('success', 0) > 0
        except Exception as e:
            logger.error(f"خطأ في إرسال إشعار الموضوع: {e}")
            return False
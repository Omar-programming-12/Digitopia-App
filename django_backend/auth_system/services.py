from django.core.mail import send_mail
from django.conf import settings
from .models import EmailVerification
import logging

logger = logging.getLogger(__name__)

class EmailService:
    @staticmethod
    def send_otp_email(email, otp_code):
        subject = 'رمز التحقق - تطبيق ديجيتوبيا'
        message = f'''
مرحباً،

رمز التحقق الخاص بك هو: {otp_code}

هذا الرمز صالح لمدة 10 دقائق فقط.
لا تشارك هذا الرمز مع أي شخص آخر.

شكراً لاستخدامك تطبيق ديجيتوبيا
        '''
        
        try:
            send_mail(
                subject=subject,
                message=message,
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[email],
                fail_silently=False,
            )
            return True
        except Exception as e:
            logger.error(f"Failed to send OTP email to {email}: {str(e)}")
            return False

class OTPService:
    @staticmethod
    def create_otp(email):
        # حذف أي OTP قديم غير مستخدم لنفس البريد
        EmailVerification.objects.filter(
            email=email, 
            is_verified=False
        ).delete()
        
        # إنشاء OTP جديد
        verification = EmailVerification.objects.create(email=email)
        
        # إرسال البريد الإلكتروني
        if EmailService.send_otp_email(email, verification.otp_code):
            return verification
        else:
            verification.delete()
            return None
    
    @staticmethod
    def verify_otp(email, otp_code):
        try:
            verification = EmailVerification.objects.get(
                email=email,
                otp_code=otp_code,
                is_verified=False
            )
            
            verification.attempts += 1
            verification.save()
            
            if not verification.can_attempt():
                return {'success': False, 'message': 'انتهت صلاحية الرمز أو تم تجاوز عدد المحاولات'}
            
            verification.is_verified = True
            verification.save()
            
            return {'success': True, 'message': 'تم التحقق بنجاح'}
            
        except EmailVerification.DoesNotExist:
            return {'success': False, 'message': 'رمز التحقق غير صحيح'}
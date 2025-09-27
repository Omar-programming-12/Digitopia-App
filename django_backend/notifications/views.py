from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import FCMToken, NotificationLog
from .serializers import FCMTokenSerializer, NotificationSerializer, CustomNotificationSerializer
from .services import NotificationService
import logging

logger = logging.getLogger(__name__)

class RegisterTokenView(APIView):
    def post(self, request):
        serializer = FCMTokenSerializer(data=request.data)
        if serializer.is_valid():
            user_id = serializer.validated_data['user_id']
            token = serializer.validated_data['token']
            platform = serializer.validated_data['platform']
            
            # تحديث أو إنشاء token
            fcm_token, created = FCMToken.objects.update_or_create(
                user_id=user_id,
                token=token,
                defaults={'platform': platform, 'is_active': True}
            )
            
            return Response({
                'message': 'تم تسجيل Token بنجاح',
                'created': created
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class MealNotificationView(APIView):
    def post(self, request):
        serializer = NotificationSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.validated_data
            
            # جلب جميع الـ tokens النشطة
            active_tokens = FCMToken.objects.filter(is_active=True).values_list('token', flat=True)
            
            if not active_tokens:
                return Response({
                    'message': 'لا توجد أجهزة مسجلة لإرسال الإشعارات'
                }, status=status.HTTP_200_OK)
            
            # إرسال الإشعار
            notification_data = {
                'meal_name': data['meal_name'],
                'location': data['location'],
                'user_name': data['user_name'],
                'image_url': data.get('image_url', ''),
                'type': 'new_meal'
            }
            
            result = NotificationService.send_to_multiple(
                tokens=list(active_tokens),
                title=data['title'],
                body=data['body'],
                data=notification_data
            )
            
            # حفظ سجل الإشعار
            NotificationLog.objects.create(
                notification_type=data['notification_type'],
                title=data['title'],
                body=data['body'],
                data=notification_data,
                sent_to_count=len(active_tokens),
                success_count=result
            )
            
            return Response({
                'message': 'تم إرسال الإشعار بنجاح',
                'sent_to': len(active_tokens),
                'success_count': result,
                'failure_count': len(active_tokens) - result
            }, status=status.HTTP_200_OK)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CustomNotificationView(APIView):
    def post(self, request):
        serializer = CustomNotificationSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.validated_data
            
            active_tokens = FCMToken.objects.filter(is_active=True).values_list('token', flat=True)
            
            if not active_tokens:
                return Response({
                    'message': 'لا توجد أجهزة مسجلة'
                }, status=status.HTTP_200_OK)
            
            result = NotificationService.send_to_multiple(
                tokens=list(active_tokens),
                title=data['title'],
                body=data['body'],
                data=data.get('data', {})
            )
            
            NotificationLog.objects.create(
                notification_type=data['notification_type'],
                title=data['title'],
                body=data['body'],
                data=data.get('data'),
                sent_to_count=len(active_tokens),
                success_count=result
            )
            
            return Response({
                'message': 'تم إرسال الإشعار المخصص بنجاح',
                'sent_to': len(active_tokens),
                'success_count': result,
                'failure_count': len(active_tokens) - result
            }, status=status.HTTP_200_OK)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
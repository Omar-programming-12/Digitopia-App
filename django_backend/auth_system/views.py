from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import SendOTPSerializer, VerifyOTPSerializer
from .services import OTPService
import logging

logger = logging.getLogger(__name__)

class SendOTPView(APIView):
    def post(self, request):
        serializer = SendOTPSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            
            verification = OTPService.create_otp(email)
            
            if verification:
                return Response({
                    'success': True,
                    'message': 'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
                    'email': email
                }, status=status.HTTP_200_OK)
            else:
                return Response({
                    'success': False,
                    'message': 'فشل في إرسال رمز التحقق. يرجى المحاولة مرة أخرى'
                }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        return Response({
            'success': False,
            'errors': serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)

class VerifyOTPView(APIView):
    def post(self, request):
        serializer = VerifyOTPSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            otp_code = serializer.validated_data['otp_code']
            
            result = OTPService.verify_otp(email, otp_code)
            
            if result['success']:
                return Response(result, status=status.HTTP_200_OK)
            else:
                return Response(result, status=status.HTTP_400_BAD_REQUEST)
        
        return Response({
            'success': False,
            'errors': serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)
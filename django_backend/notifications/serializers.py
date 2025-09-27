from rest_framework import serializers
from .models import FCMToken, NotificationLog

class FCMTokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = FCMToken
        fields = ['user_id', 'token', 'platform']

class NotificationSerializer(serializers.Serializer):
    user_name = serializers.CharField(max_length=100)
    meal_name = serializers.CharField(max_length=200)
    location = serializers.CharField(max_length=200)
    image_url = serializers.URLField(required=False, allow_blank=True)
    notification_type = serializers.CharField(max_length=20)
    title = serializers.CharField(max_length=200)
    body = serializers.CharField(max_length=500)

class CustomNotificationSerializer(serializers.Serializer):
    title = serializers.CharField(max_length=200)
    body = serializers.CharField(max_length=500)
    notification_type = serializers.CharField(max_length=20)
    data = serializers.JSONField(required=False)
from django.contrib import admin
from .models import EmailVerification

@admin.register(EmailVerification)
class EmailVerificationAdmin(admin.ModelAdmin):
    list_display = ['email', 'otp_code', 'is_verified', 'attempts', 'created_at', 'expires_at']
    list_filter = ['is_verified', 'created_at']
    search_fields = ['email']
    readonly_fields = ['created_at', 'expires_at']
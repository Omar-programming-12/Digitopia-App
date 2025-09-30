from django.urls import path
from .views import RegisterTokenView, MealNotificationView, CustomNotificationView

urlpatterns = [
    path('register-token/', RegisterTokenView.as_view(), name='register_token'),
    path('meal-added/', MealNotificationView.as_view(), name='meal_notification'),
    path('send/', CustomNotificationView.as_view(), name='custom_notification'),
]
from django.test import TestCase
from rest_framework.test import APITestCase
from django.urls import reverse

class NotificationAPITest(APITestCase):
    def test_send_notification(self):
        url = reverse('send-notification')
        data = {
            'title': 'وجبة جديدة',
            'body': 'تم إضافة وجبة جديدة',
            'topic': 'meals'
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, 200)
# coding=utf-8
from django.urls import path

from .views import Index
from rest_framework_jwt.views import obtain_jwt_token


urlpatterns = [
    path('', Index.as_view(), name='accounts_index'),
]

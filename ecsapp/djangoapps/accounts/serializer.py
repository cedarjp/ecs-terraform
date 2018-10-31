# -*- coding: utf-8 -*-

from django.contrib.auth import get_user_model
from rest_framework.serializers import ModelSerializer, CharField


class AccountSerializer(ModelSerializer):
    password = CharField(write_only=True, required=True)

    class Meta:
        model = get_user_model()
        fields = ('id', 'email', 'password')

    def create(self, validated_data):
        return self.Meta.model.objects.create_user(**validated_data)

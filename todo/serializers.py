from rest_framework.serializers import ModelSerializer
from .models import *

class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'


    def to_representation(self, instance):
        data = super().to_representation(instance)
        data["Profile"] = {
            "username": instance.auth_user.username,
            "name": instance.auth_user.first_name + ' ' + instance.auth_user.last_name,
            "email": instance.auth_user.email
        }

        return data

class ListSerializer(ModelSerializer):
    class Meta:
        model = List
        fields = '__all__'

class TaskSerializer(ModelSerializer):
    class Meta:
        model = Task
        fields = '__all__'
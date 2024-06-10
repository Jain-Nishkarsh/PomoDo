from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet
from .serializers import *
from .models import *
from rest_framework.permissions import IsAuthenticated
from rest_framework import renderers
from rest_framework.response import Response
from django.contrib.auth.models import User as AuthUser

# Create your views here.
class UserViewSet(ModelViewSet):
    # permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer
    lookup_field = 'static_id'
    queryset = User.objects.all()
    # renderer_classes = (renderers.JSONRenderer, renderers.TemplateHTMLRenderer)

    def create(self, request):
        data = request.data
        try:
            auth_user, created = AuthUser.objects.get_or_create(
                username=data['username'],
                email=data['email'],
                first_name=data['first_name'],
                last_name=data['last_name']
            )

            if created:
                auth_user.set_password(data['password'])
                auth_user.save()

                user, create = User.objects.get_or_create(
                    auth_user=auth_user,
                )

                newlist, create = List.objects.get_or_create(
                    name="Default List",
                    owner=user,
                )

                return Response(
                    data={
                        "message": "User created successfully"
                    },
                    status=201,
                )

            else:
                return Response(
                    data={
                        "message": "User already exists"
                    },
                    status=400,
                )

        except KeyError as e:
            return Response(
                data={
                    "message": f"Missing required field: {e}"
                },
                status=400,
            )
        
class ListViewSet(ModelViewSet):
    # permission_classes = [IsAuthenticated]
    serializer_class = ListSerializer
    lookup_field = 'static_id'
    queryset = List.objects.all()
    # renderer_classes = (renderers.JSONRenderer, renderers.TemplateHTMLRenderer)

    def create(self, request):
        data = request.data
        try:
            user = User.objects.get(auth_user=request.user)
            List.objects.get_or_create(
                name=data['name'],
                owner=user,
            )

            return Response(
                data={
                    "message": "List created successfully"
                },
                status=201,
            )

        except KeyError as e:
            return Response(
                data={
                    "message": f"Missing required field: {e}"
                },
                status=400,
            )
        
class TaskViewSet(ModelViewSet):
    # permission_classes = [IsAuthenticated]
    serializer_class = TaskSerializer
    lookup_field = 'static_id'
    queryset = Task.objects.all()
    # renderer_classes = (renderers.JSONRenderer, renderers.TemplateHTMLRenderer)

    def create(self, request):
        data = request.data
        try:
            print(request.user)
            user = User.objects.get(auth_user__id=request.user.id)
            if 'list' not in data:
                data['list'] = user.lists.first().static_id

            list = List.objects.get(static_id=data['list'])
            print(list.owner.auth_user, request.user)
            # if (list.owner.auth_user != request.user):
            #     return Response(
            #         data={
            #             "message": "You are not authorized to create tasks for this list"
            #         },
            #         status=401,
            #     )
            
            # Task.objects.get_or_create(
            #     list=list,
            #     title=data['title'],
            #     due_date=data['due_date'],
            # )

            return Response(
                data={
                    "message": "Task created successfully"
                },
                status=201,
            )

        except KeyError as e:
            return Response(
                data={
                    "message": f"Missing required field: {e}"
                },
                status=400,
            )
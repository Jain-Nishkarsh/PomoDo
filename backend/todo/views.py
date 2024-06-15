from django.shortcuts import render
from rest_framework.viewsets import ModelViewSet, GenericViewSet
from rest_framework.decorators import action
from django.contrib.auth import authenticate
from rest_framework.exceptions import status
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.exceptions import ObjectDoesNotExist
from .serializers import *
from .models import *
from rest_framework.response import Response
from django.contrib.auth.models import User as AuthUser
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated

class AuthViewSet(GenericViewSet):
    queryset = AuthUser.objects.all()

    @action(detail=False, methods=["post"])
    def login(self, request):
        username = request.data.get("username")
        password = request.data.get("password")

        user = authenticate(username=username, password=password)
        if user is not None:
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            })
        else:
            return Response({"error": "Invalid username or password"}, status=status.HTTP_400_BAD_REQUEST)

# Create your views here.
class UserViewSet(ModelViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer
    lookup_field = 'static_id'
    queryset = User.objects.all()

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
    permission_classes = [IsAuthenticated]
    serializer_class = ListSerializer
    lookup_field = 'static_id'
    queryset = List.objects.all()

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

    def create(self, request):
        data = request.data
        try:
            # user = User.objects.get(auth_user=request.user)
            user = User.objects.get(auth_user=AuthUser.objects.get(username='nishkarsh'))
            if 'list' not in data:
                data['list'] = user.lists.first().static_id

            Task.objects.create(
                list=List.objects.get(static_id=data['list']),
                title=data['title'],
                due_date=data['due_date'],
            )

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

    def partial_update(self, request, *args, **kwargs):
        try:
            task = Task.objects.get(static_id=kwargs['static_id'])
        except ObjectDoesNotExist:
            return Response({"error": "Task not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = TaskSerializer(task, data=request.data, partial=True) # set partial=True to update a data partially

        if serializer.is_valid():
            serializer.save()
            if serializer.validated_data.get('completed', None):
                task.completed_at = datetime.datetime.now()
            else:
                task.completed_at = None
            task.save()
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
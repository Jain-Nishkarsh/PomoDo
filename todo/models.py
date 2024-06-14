import datetime
from django.db import models
from django.contrib.auth import get_user_model
import uuid

# Create your models here.
class User(models.Model):
    static_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    auth_user = models.OneToOneField(get_user_model(), on_delete=models.CASCADE)
    daily_goal = models.IntegerField(default=4)

    @property
    def name(self):
        return self.auth_user.first_name + ' ' + self.auth_user.last_name

    def __str__(self):
        return self.name
    
class List(models.Model):
    static_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    name = models.CharField(max_length=100)
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='lists')

    def __str__(self):
        return f"{self.owner.name} - {self.name}"
    
class Task(models.Model):
    static_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    list = models.ForeignKey(List, on_delete=models.CASCADE, related_name='tasks')
    title = models.CharField(max_length=150)
    completed = models.BooleanField(default=False)
    due_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.list.name} - {self.title}"
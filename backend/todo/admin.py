from django.contrib import admin
from .models import *

# Register your models here.
admin.site.register(List)
admin.site.register(Task)

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)
    readonly_fields = ('static_id',)

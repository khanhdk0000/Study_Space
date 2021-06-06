from django.urls import path

from . import views
app_name = 'music'
urlpatterns = [
    path('', views.index, name='index'),
    path('about/', views.about, name='about'),
    path('mqtt/', views.mqtt, name='mqtt')
]
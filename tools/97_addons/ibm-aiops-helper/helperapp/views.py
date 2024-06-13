from django.shortcuts import render
from django.template import loader
# Create your views here.
from django.http import HttpResponse
from pathlib import Path


def index1(request):
    return HttpResponse("Hello, world. You're at the polls index.")


def index(request):
    image_name='bear.png'
    path = Path('./static/images/characters/'+image_name)

    template = loader.get_template("helperapp/home.html")
    context = {
        'loggedin': 'loggedin',
        'aimanager_url': 'aimanager_url',
        'aimanager_user': 'aimanager_user',
        'aimanager_pwd': 'aimanager_pwd',
        'DEMO_USER': 'DEMO_USER',
        'DEMO_PWD': 'DEMO_PWD',
        'INSTANCE_NAME': 'INSTANCE_NAME',
        'INSTANCE_IMAGE': path,
        'ADMIN_MODE': 'ADMIN_MODE',
        'PAGE_TITLE': 'Demo UI for ' + 'INSTANCE_NAME',
        'PAGE_NAME': 'index'

    }
    return HttpResponse(template.render(context, request))
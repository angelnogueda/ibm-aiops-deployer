FROM python:3.10.13 as build   
ENV DockerHOME=/home/app/demoui  

# set work directory  
RUN mkdir -p $DockerHOME  

# where your code lives  
WORKDIR $DockerHOME  

RUN touch builddate

# set environment variables  
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

# install dependencies  
RUN pip install --upgrade pip  

RUN python -m pip install Django

RUN pip install confluent-kafka

# Install Openshift Client
RUN wget  -O oc.tar.gz https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2024-01-06-084517/openshift-client-linux-4.14.0-0.okd-2024-01-06-084517.tar.gz && tar xfvz oc.tar.gz && mv oc /usr/local/bin && mv kubectl /usr/local/bin/ && rm oc.tar.gz

RUN apt update && apt install -y jq && rm -rf /var/lib/apt/lists/*

# copy whole project to your docker home directory. 
COPY . $DockerHOME  
# run this command to install all dependencies  
RUN pip install -r requirements.txt 

# port where the Django app runs  
EXPOSE 8000  

RUN pwd
RUN ls -al


# start server  
CMD python manage.py runserver 0.0.0.0:8000
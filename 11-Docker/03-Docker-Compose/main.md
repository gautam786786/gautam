## What is Docker Compose?

With Compose, you use a YAML file to configure your application’s services (containers). Then, with a single command, you can build, start or delete your application services.


Why Docker Compose exists? 
Running multiple containers is a very common scenario.

Take for example a WordPress (WP) application. It consists of a WordPress service that talks to a MySQL database.


We could run both containers using two docker run commands with a bunch of cli arguments. The db container might be started like this:
```t
docker run -d \
  --name db \
  --restart always \
  -v db_data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=supersecret \
  -e MYSQL_DATABASE=exampledb \
  -e MYSQL_USER=exampleuser \
  -e MYSQL_PASSWORD=examplepass \
  mysql:5.7
  ```
We could create or remove networks with docker network commands, and modify docker run to take the network as an argument.

Typing out these verbose commands might be fine once or twice. But as the number of containers and configurations grows, they become increasingly harder to manage.

With Compose, we simply define the application’s configuration on a YAML file (named docker-compose.yml by default) like this:
```t
version: '3.9'
services:
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_ROOT_PASSWORD: supersecret
    volumes:
      - db_data:/var/lib/mysql
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
    volumes:
      - wordpress_data:/var/www/html
volumes:
  wordpress_data:
  db_data:
  ```
This file defines 2 services, db and wordpress. It also specifies the configuration options for each - like the image, environment variables, published ports, volumes, etc.


After creating this file, we execute docker compose up, and Docker builds and runs our entire application in a new isolated environment (bridge network by default).

Similarly, we can use the docker compose down command to tear everything down (except volumes).


How to use Docker Compose?
Source code for this demo: https://github.com/AluBhorta/docker-compose-demo

First of all, make sure you have installed:
```t
Docker
Docker Compose
```
NOTE: since Compose version 2, we use docker compose command instead of docker-compose. This tutorial uses version 2.

Step 2: Create a sample web application
Open up a terminal, create a new directory and switch into it:
```t
mkdir docker-compose-demo
cd docker-compose-demo
```
Add the code for a simple Python web app on a file named app.py:
```t
import time
import redis
from flask import Flask
app = Flask(__name__)
cache = redis.Redis(host='redis', port=6379)
@app.route('/')
def hello():
    count = cache.incr('hits')
    return 'Hello World! I have been seen {} times.\n'.format(count)
```
This creates a Flask app with a single HTTP endpoint (/). This endpoint returns how many times it has been visited. The count is stored and incremented as an integer with a key named hits in a Redis host named redis.

Then we add the Python dependencies to a requirements.txt file:
```t
flask
redis
```
After that, we create a Dockerfile - to create a Docker image based on this application:
```t
FROM python:3.7-alpine
WORKDIR /code
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . .
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
CMD ["flask", "run"]
```
This tells Docker to:

1) Build an image starting with the Python 3.7 Alpine Linux image
2) Set the working directory to /code
3) Install gcc and other dependencies with the apk package manager
4) Copy requirements.txt from host to image
5) Install the Python dependencies with pip
6) Add metadata to the image to describe that the container is listening on port 5000
7) Copy the current directory . in the project to the workdir . in the image
8) Set environment variables used by the flask command
9) Set the default command for the container to flask run
1) Then we create a docker-compose.yml file for us to use Docker Compose:
```t
version: "3.9"
services:
  redis:
    image: "redis:alpine"
  web:
    build: .
    ports:
      - "8000:5000"
    depends_on:
      - redis
```
This Compose file defines two services: web and redis.
The redis service uses a public redis:alpine image pulled from the Docker Hub registry.

The web service uses an image that’s built from the Dockerfile in the current directory (.). It then maps port 8000 on the host to port 5000 on the container where the flask server will be running. 
It also specifies that web depends on redis so that Docker knows to start redis before web.

NOTE: since Compose creates a new bridge network on project startup, web can reach redis simply by using the service’s name ie. redis.

Step 3: Run and test the application

```t
docker compose up
```
Docker will automatically pull the redis image, build our web image and start the containers.

Once deployed, we should now be able to reach the application at localhost:8000 on your browser.

Or alternatively, use curl on a separate terminal to reach the flask application like so:

```t
curl localhost:8000
```
You should see something like this:

Hello World! I have been seen 1 times.
The count is incremented every time we make a request.

We can list the containers of the Compose project with:

```t
docker compose ps
```
NOTE: docker compose up will by default attach to your terminal and print the logs from the services. We can use ctrl+c to detach that terminal, but it will stop the services.

To run the services in the background, use -d the flag:

```t
docker compose up -d
```
If you want to view the logs, use:
```t
docker compose logs -f
```
NOTE: -f will follow the log output as new logs are generated.

Step 4: Modify the application

The web container is printing out a warning:

WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
In production, we definitely want to run a production-grade server like gunicorn instead of the development server, we get with flask run.

So, let’s first add gunicorn to requirements.txt:
```t
flask
redis
gunicorn
```
Then remove the last 3 instructions of Dockerfile and add a new CMD instruction:
```t
FROM python:3.7-alpine
WORKDIR /code
RUN apk add --no-cache gcc musl-dev linux-headers
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . .
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```
Images built from this Dockerfile will now run gunicorn instead of the flask dev server.

Once we’ve made the changes, we need to rebuild the web image:
```t
docker compose build
```
Then we restart the web service to use the new image:
```t
docker compose up web -d --no-deps -t 1
```
NOTE:

--no-deps tells Docker not to (re)start dependent services.
-t 1 specifies the container shutdown timeout of 1 second instead of the default 10s.
Try to reach web again:

curl localhost:8000
It should work as expected.

But if you check the logs:

docker compose logs web -f
You will notice we don’t have the warning anymore since we’re using gunicorn.

Step 5: Clean up
To remove all the services, we simply run:
```t
docker compose down
```
If we had defined volumes in the services (like in the WordPress example), the volumes wouldn’t be automatically removed with docker compose down. This is mainly to avoid accidental deletion of data.

To tear down everything including volumes, use the -v flag:
```t
docker compose down -v
```
Congratulations! You can now Compose! 🙌

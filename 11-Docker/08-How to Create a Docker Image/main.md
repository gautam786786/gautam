How to Create a Docker Image

 You can start a container using this image simply by executing the following command:

docker container run --rm --detach --name default-nginx --publish 8080:80 nginx

# b379ecd5b6b9ae27c144e4fa12bdc5d0635543666f75c14039eea8d5f38e3f56

docker container ls

# CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
# b379ecd5b6b9        nginx               "/docker-entrypoint.…"   8 seconds ago       Up 8 seconds        0.0.0.0:8080->80/tcp   default-nginx

Now, if you visit http://127.0.0.1:8080 in the browser, you'll see a default response page.

In order to make a custom NGINX image, 

 In my opinion the image should be as follows:

The image should have NGINX pre-installed which can be done using a package manager or can be built from source.

The image should start NGINX automatically upon running.

That's simple. If you've cloned the project repository linked in this book, go inside the project root and look for a directory named custom-nginx in there.

Now, create a new file named Dockerfile inside that directory. A Dockerfile is a collection of instructions that, once processed by the daemon, results in an image. Content for the Dockerfile is as follows:

FROM ubuntu:latest

EXPOSE 80

RUN apt-get update && \
    apt-get install nginx -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]

Every valid Dockerfile starts with a FROM instruction. This instruction sets the base image for your resultant image. By setting ubuntu:latest as the base image here, you get all the goodness of Ubuntu already available in your custom image, so you can use things like the apt-get command for easy package installation.

The EXPOSE instruction is used to indicate the port that needs to be published. Using this instruction doesn't mean that you won't need to --publish the port. You'll still need to use the --publish option explicitly. This EXPOSE instruction works like a documentation for someone who's trying to run a container using your image. It also has some other uses that I won't be discussing here.

The RUN instruction in a Dockerfile executes a command inside the container shell. The apt-get update && apt-get install nginx -y command checks for updated package versions and installs NGINX. The apt-get clean && rm -rf /var/lib/apt/lists/* command is used for clearing the package cache because you don't want any unnecessary baggage in your image. These two commands are simple Ubuntu stuff, nothing fancy. The RUN instructions here are written in shell form. These can also be written in exec form. You can consult the official reference for more information.

Finally the CMD instruction sets the default command for your image. This instruction is written in exec form here comprising of three separate parts. Here, nginx refers to the NGINX executable. The -g and daemon off are options for NGINX. Running NGINX as a single process inside containers is considered a best practice hence the usage of this option. The CMD instruction can also be written in shell form. You can consult the official reference for more information.

 you can build an image out of it. J

docker image build .

# Sending build context to Docker daemon  3.584kB

To perform an image build, the daemon needs two very specific pieces of information. These are the name of the Dockerfile and the build context. In the command issued above:

docker image build is the command for building the image. The daemon finds any file named Dockerfile within the context.

The . at the end sets the context for this build. The context means the directory accessible by the daemon during the build process.

Now to run a container using this image, you can use the container run command coupled with the image ID that you received as the result of the build process. In my case the id is 3199372aa3fc evident by the Successfully built 3199372aa3fc line in the previous code block.

docker container run --rm --detach --name custom-nginx-packaged --publish 8080:80 3199372aa3fc

# ec09d4e1f70c903c3b954c8d7958421cdd1ae3d079b57f929e44131fbf8069a0

docker container ls

# CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
# ec09d4e1f70c        3199372aa3fc        "nginx -g 'daemon of…"   23 seconds ago      Up 22 seconds       0.0.0.0:8080->80/tcp   custom-nginx-packaged

To verify, visit http://127.0.0.1:8080 and you should see the default response page.
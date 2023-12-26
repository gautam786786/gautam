Bash:

# To delete all containers including its volumes use,
docker rm -vf $(docker ps -aq)

# To delete all the images,
docker rmi -f $(docker images -aq)

Remember, you should remove all the containers before removing all the images from which those containers were created.

Windows - Powershell

docker images -a -q | % { docker image rm $_ -f }
Windows - cmd.exe

for /F %i in ('docker images -a -q') do docker rmi -f %i

# Docker - Essential Commands
- The below are the list of essential commands we are in need 

|     Commands                 |    Description                                  |
| ------------------------------- | --------------------------------------------- |
| docker ps | List all running containers |
| docker ps -a | List all containers stopped, running |
| docker stop container-id | Stop the container which is running |
| docker start container-id | Start the container which is stopped |
| docker restart container-id | Restart the container which is running |
| docker port container-id | List port mappings of a specific container |
| docker rm container-id or name | Remove the stopped container |
| docker rm -f container-id or name| Remove the running container forcefully |
| docker pull image-info | Pull the image from docker hub repository |
| docker pull stacksimplify/springboot-helloworld-rest-api:2.0.0-RELEASE | Pull the image from docker hub repository |
| docker exec -it container-name /bin/sh | Connect to linux container and execute commands in container |
| docker rmi image-id | Remove the docker image |
| docker logout | Logout from docker hub |
| docker login -u username -p password | Login to docker hub |
| docker stats | Display a live stream of container(s) resource usage statistics |
| docker top container-id or name | Display the running processes of a container |
| docker version | Show the Docker version information |
| docker system prune | pune images 
| docker system prune -a | prune all images
| 


https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes


# Look at all the containers that are currently running or have run in the past:
docker ps -a

# How to Run a Container
docker run <image name>

Better way of dispatching commands to the docker daemon.

docker <object> <command> <options>

In this syntax:

- object indicates the type of Docker object you'll be manipulating. This can be a container, image, network or volume object.

- command indicates the task to be carried out by the daemon, that is the run command.

- options can be any valid parameter that can override the default behavior of the command, like the --publish option for port mapping.

Now, following this syntax, the run command can be written as follows:

# docker container run <image name>

The image name can be of any image from an online registry or your local system. 

To run a container using this image, execute following command on your terminal:
```bash
docker container run --publish 8080:80 fhsinchy/hello-dock
```

The command is pretty self-explanatory. The only portion that may require some explanation is the --publish 8080:80 portion which will be explained in the next sub-section.


### How to List Containers
```bash
docker container ls
```

The container ls command only lists the containers that are currently running on your system. In order to list out the containers that have run in the past you can use the --all or -a option.

docker container ls --all

# CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                     PORTS                  NAMES
# 9f21cb777058        fhsinchy/hello-dock   "/docker-entrypoint.…"   2 minutes ago       Up 2 minutes               0.0.0.0:8080->80/tcp   gifted_sammet
# 6cf52771dde1        fhsinchy/hello-dock   "/docker-entrypoint.…"   3 minutes ago       Exited (0) 3 minutes ago                          reverent_torvalds
# 128ec8ceab71        hello-world           "/hello"                 4 minutes ago       Exited (0) 4 minutes ago                          exciting_chebyshev

As you can see, the second container in the list reverent_torvalds was created earlier and has exited with the status code 0, which indicates that no error was produced during the runtime of the container.

### How to Name or Rename a Container

By default, every container has two identifiers. They are as follows:

CONTAINER ID - a random 64 character-long string.

NAME - combination of two random words, joined with an underscore.

Naming a container can be achieved using the --name option. To run another container using the fhsinchy/hello-dock image with the name hello-dock-container you can execute the following command:

docker container run --detach --publish 8888:80 --name hello-dock-container fhsinchy/hello-dock

# b1db06e400c4c5e81a93a64d30acc1bf821bed63af36cab5cdb95d25e114f5fb

The 8080 port on local network is occupied by the gifted_sammet container (the container created in the previous sub-section). That's why you'll have to use a different port number, like 8888. Now to verify, run the container ls command:

docker container ls

# CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                  NAMES
# b1db06e400c4        fhsinchy/hello-dock   "/docker-entrypoint.…"   28 seconds ago      Up 26 seconds       0.0.0.0:8888->80/tcp   hello-dock-container
# 9f21cb777058        fhsinchy/hello-dock   "/docker-entrypoint.…"   4 minutes ago       Up 4 minutes        0.0.0.0:8080->80/tcp   gifted_sammet

A new container with the name of hello-dock-container has been started.

You can even rename old containers using the container rename command. Syntax for the command is as follows:

docker container rename <container identifier> <new name>

To rename the gifted_sammet container to hello-dock-container-2, execute following command:

docker container rename gifted_sammet hello-dock-container-2

The command doesn't yield any output but you can verify that the changes have taken place using the container ls command. The rename command works for containers both in running state and stopped state.

### How to Stop or Kill a Running Container

Containers running in the foreground can be stopped by simply closing the terminal window or hitting ctrl + c. Containers running in the background, however, can not be stopped in the same way.

There are two commands that deal with this task. 

docker container stop <container identifier>

Where container identifier can either be the id or the name of the container.

I hope that you remember the container you started in the previous section. It's still running in the background. Get the identifier for that container using docker container ls (I'll be using hello-dock-container container for this demo). Now execute the following command to stop the container:

docker container stop hello-dock-container

# hello-dock-container

If you use the name as identifier, you'll get the name thrown back to you as output. The stop command shuts down a container gracefully by sending a SIGTERM signal. If the container doesn't stop within a certain period, a SIGKILL signal is sent which shuts down the container immediately.

In cases where you want to send a SIGKILL signal instead of a SIGTERM signal, you may use the container kill command instead. The container kill command follows the same syntax as the stop command.

docker container kill hello-dock-container-2

# hello-dock-container-2

### How to Restart a Container

When I say restart I mean two scenarios specifically. They are as follows:

Restarting a container that has been previously stopped or killed.

Rebooting a running container.

The container start command can be used to start any stopped or killed container. The syntax of the command is as follows:

docker container start <container identifier>

You can get the list of all containers by executing the container ls --all command. Then look for the containers with Exited status.

docker container ls --all

# CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                        PORTS               NAMES
# b1db06e400c4        fhsinchy/hello-dock   "/docker-entrypoint.…"   3 minutes ago       Exited (0) 47 seconds ago                         hello-dock-container
# 9f21cb777058        fhsinchy/hello-dock   "/docker-entrypoint.…"   7 minutes ago       Exited (137) 17 seconds ago                       hello-dock-container-2
# 6cf52771dde1        fhsinchy/hello-dock   "/docker-entrypoint.…"   7 minutes ago       Exited (0) 7 minutes ago                          reverent_torvalds
# 128ec8ceab71        hello-world           "/hello"                 9 minutes ago       Exited (0) 9 minutes ago                          exciting_chebyshev

Now to restart the hello-dock-container container, you may execute the following command:

docker container start hello-dock-container

# hello-dock-container

Now you can ensure that the container is running by looking at the list of running containers using the container ls command.

The container start command starts any container in detached mode by default and retains any port configurations made previously. So if you visit http://127.0.0.1:8080 now, you should be able to access the hello-dock application just like before.

Now, in scenarios where you would like to reboot a running container you may use the container restart command. The container restart command follows the exact syntax as the container start command.

docker container restart hello-dock-container-2

# hello-dock-container-2

The main difference between the two commands is that the container restart command attempts to stop the target container and then starts it back up again, whereas the start command just starts an already stopped container.

In case of a stopped container, both commands are exactly the same. But in case of a running container, you must use the container restart command.

### How to Create a Container Without Running

container create command creates a container from a given image.

container start command starts a container that has been already created.

Now, to perform the demonstration shown in the "How to Run a Container" section using these two commands, you can do something like the following:

docker container create --publish 8080:80 fhsinchy/hello-dock

# 2e7ef5098bab92f4536eb9a372d9b99ed852a9a816c341127399f51a6d053856

docker container ls --all

# CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
# 2e7ef5098bab        fhsinchy/hello-dock   "/docker-entrypoint.…"   30 seconds ago      Created                                 hello-dock

Evident by the output of the container ls --all command, a container with the name of hello-dock has been created using the fhsinchy/hello-dock image. The STATUS of the container is Created at the moment, and, given that it's not running, it won't be listed without the use of the --all option.

Once the container has been created, it can be started using the container start command.

docker container start hello-dock

# hello-dock

docker container ls

# CONTAINER ID        IMAGE                 COMMAND                  CREATED              STATUS              PORTS                  NAMES
# 2e7ef5098bab        fhsinchy/hello-dock   "/docker-entrypoint.…"   About a minute ago   Up 29 seconds       0.0.0.0:8080->80/tcp   hello-dock

The container STATUS has changed from Created to Up 29 seconds which indicates that the container is now in running state. The port configuration has also shown up in the PORTS column which was previously empty.‌

Although you can get away with the container run command for the majority of the scenarios, there will be some situations later on in the book that require you to use this container create command.

### How to Remove Dangling Containers

As you've already seen, containers that have been stopped or killed remain in the system. 

In order to remove a stopped container you can use the container rm command. The generic syntax is as follows:

docker container rm <container identifier>

To find out which containers are not running, use the container ls --all command and look for containers with Exited status.

docker container ls --all

# CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                      PORTS                  NAMES
# b1db06e400c4        fhsinchy/hello-dock   "/docker-entrypoint.…"   6 minutes ago       Up About a minute           0.0.0.0:8888->80/tcp   hello-dock-container
# 9f21cb777058        fhsinchy/hello-dock   "/docker-entrypoint.…"   10 minutes ago      Up About a minute           0.0.0.0:8080->80/tcp   hello-dock-container-2
# 6cf52771dde1        fhsinchy/hello-dock   "/docker-entrypoint.…"   10 minutes ago      Exited (0) 10 minutes ago                          reverent_torvalds
# 128ec8ceab71        hello-world           "/hello"                 12 minutes ago      Exited (0) 12 minutes ago                          exciting_chebyshev

As can be seen in the output, the containers with ID 6cf52771dde1 and 128ec8ceab71 are not running. To remove the 6cf52771dde1 you can execute the following command:

docker container rm 6cf52771dde1

# 6cf52771dde1

You can check if the container was deleted or not by using the container ls command. You can also remove multiple containers at once by passing their identifiers one after another separated by spaces.

Or, instead of removing individual containers, if you want to remove all dangling containers at one go, you can use the container prune command.

You can check the container list using the container ls --all command to make sure that the dangling containers have been removed:

docker container ls --all

# CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                  NAMES
# b1db06e400c4        fhsinchy/hello-dock   "/docker-entrypoint.…"   8 minutes ago       Up 3 minutes        0.0.0.0:8888->80/tcp   hello-dock-container
# 9f21cb777058        fhsinchy/hello-dock   "/docker-entrypoint.…"   12 minutes ago      Up 3 minutes        0.0.0.0:8080->80/tcp   hello-dock-container-2

If you are following the book exactly as written so far, you should only see the hello-dock-container and hello-dock-container-2 in the list. I would suggest stopping and removing both containers before going on to the next section.

There is also the --rm option for the container run  and container start commands which indicates that you want the containers removed as soon as they're stopped. To start another hello-dock container with the --rm option, execute the following command:

docker container run --rm --detach --publish 8888:80 --name hello-dock-volatile fhsinchy/hello-dock

# 0d74e14091dc6262732bee226d95702c21894678efb4043663f7911c53fb79f3

You can use the container ls command to verify that the container is running:

docker container ls

# CONTAINER ID   IMAGE                 COMMAND                  CREATED              STATUS              PORTS                  NAMES
# 0d74e14091dc   fhsinchy/hello-dock   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8888->80/tcp   hello-dock-volatile

Now if you stop the container and then check again with the container ls --all command:

docker container stop hello-dock-volatile

# hello-dock-volatile

docker container ls --all

# CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

The container has been removed automatically. From now on I'll use the --rm option for most of the containers. I'll explicitly mention where it's not needed.

### How to Run a Container in Interactive Mode

docker container run --rm -it ubuntu

# root@dbb1f56b9563:/# cat /etc/os-release
# NAME="Ubuntu"

As you can see from the output of the cat /etc/os-release command, I am indeed interacting with the bash running inside the Ubuntu container.

The -it option sets the stage for you to interact with any interactive program inside a container. This option is actually two separate options mashed together.

The -i or --interactive option connects you to the input stream of the container, so that you can send inputs to bash.

The -t or --tty option makes sure that you get some good formatting and a native terminal-like experience by allocating a pseudo-tty.

You need to use the -it option whenever you want to run a container in interactive mode. Another example can be running the node image as follows:

docker container run -it node

# Welcome to Node.js v15.0.0.
# Type ".help" for more information.
# > ['farhan', 'hasin', 'chowdhury'].map(name => name.toUpperCase())
# [ 'FARHAN', 'HASIN', 'CHOWDHURY' ]

Any valid JavaScript code can be executed in the node shell. Instead of writing -it you can be more verbose by writing --interactive --tty separately.

How to Execute Commands Inside a Container

In the Hello World in Docker section of this book, you've seen me executing a command inside an Alpine Linux container. It went something like this:

docker run alpine uname -a
# Linux f08dbbe9199b 5.8.0-22-generic #23-Ubuntu SMP Fri Oct 9 00:34:40 UTC 2020 x86_64 Linux

In this command, I've executed the uname -a command inside an Alpine Linux container. Scenarios like this (where all you want to do is to execute a certain command inside a certain container) are pretty common.

Assume that you want encode a string using the base64 program. This is something that's available in almost any Linux or Unix based operating system (but not on Windows).

In this situation you can quickly spin up a container using images like busybox and let it do the job.

The generic syntax for encoding a string using base64 is as follows:

echo -n my-secret | base64

# bXktc2VjcmV0

And the generic syntax for passing a command to a container that is not running is as follows:

docker container run <image name> <command>

To perform the base64 encoding using the busybox image, you can execute the following command:

docker container run --rm busybox sh -c "echo -n my-secret | base64

# bXktc2VjcmV0

What happens here is that, in a container run command, whatever you pass after the image name gets passed to the default entry point of the image.

An entry point is like a gateway to the image. Most of the images except the executable images (explained in the Working With Executable Images sub-section) use shell or sh as the default entry-point. So any valid shell command can be passed to them as arguments.
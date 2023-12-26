### How to Understand the Many Layers of a Docker Image

For this demonstration, I'll be using the custom-nginx:packaged image from the previous sub-section.

To visualize the many layers of an image, you can use the image history command. The various layers of the custom-nginx:packaged image can be visualized as follows:

docker image history custom-nginx:packaged

# IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
# 7f16387f7307        5 minutes ago       /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B                             
# 587c805fe8df        5 minutes ago       /bin/sh -c apt-get update &&     apt-get ins…   60MB                
# 6fe4e51e35c1        6 minutes ago       /bin/sh -c #(nop)  EXPOSE 80                    0B                  
# d70eaf7277ea        17 hours ago        /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  

There are eight layers of this image. The upper most layer is the latest one and as you go down the layers get older. The upper most layer is the one that you usually use for running containers.

Now, let's have a closer look at the images beginning from image d70eaf7277ea down to 7f16387f7307. 

d70eaf7277ea was created by /bin/sh -c #(nop)  CMD ["/bin/bash"] which indicates that the default shell inside Ubuntu has been loaded successfully.

6fe4e51e35c1 was created by /bin/sh -c #(nop)  EXPOSE 80 which was the second instruction in your code.

587c805fe8df was created by /bin/sh -c apt-get update && apt-get install nginx -y && apt-get clean && rm -rf /var/lib/apt/lists/* which was the third instruction in your code. You can also see that this image has a size of 60MB given all necessary packages were installed during the execution of this instruction.

Finally the upper most layer 7f16387f7307 was created by /bin/sh -c #(nop)  CMD ["nginx", "-g", "daemon off;"] which sets the default command for this image.

As you can see, the image comprises of many read-only layers, each recording a new set of changes to the state triggered by certain instructions. When you start a container using an image, you get a new writable layer on top of the other layers.

This layering phenomenon that happens every time you work with Docker has been made possible by an amazing technical concept called a union file system. Here, union means union in set theory. According to Wikipedia -

It allows files and directories of separate file systems, known as branches, to be transparently overlaid, forming a single coherent file system. Contents of directories which have the same path within the merged branches will be seen together in a single merged directory, within the new, virtual filesystem.

By utilizing this concept, Docker can avoid data duplication and can use previously created layers as a cache for later builds. This results in compact, efficient images that can be used everywhere.

How to Build NGINX from Source

In order to build NGINX from source, you first need the source of NGINX. If you've cloned my projects repository you'll see a file named nginx-1.19.2.tar.gz inside the custom-nginx directory. You'll use this archive as the source for building NGINX.

 The image creation process this time can be done in seven steps. These are as follows:

Get a good base image for building the application, like ubuntu.

Install necessary build dependencies on the base image.

Copy the nginx-1.19.2.tar.gz file inside the image.

Extract the contents of the archive and get rid of it.

Configure the build, compile and install the program using the make tool.

Get rid of the extracted source code.

Run nginx executable.

Now that you have a plan, let's begin by opening up old Dockerfile and updating its contents as follows:

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install build-essential\ 
                    libpcre3 \
                    libpcre3-dev \
                    zlib1g \
                    zlib1g-dev \
                    libssl1.1 \
                    libssl-dev \
                    -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY nginx-1.19.2.tar.gz .

RUN tar -xvf nginx-1.19.2.tar.gz && rm nginx-1.19.2.tar.gz

RUN cd nginx-1.19.2 && \
    ./configure \
        --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --pid-path=/var/run/nginx.pid \
        --with-http_ssl_module && \
    make && make install

RUN rm -rf /nginx-1.19.2

CMD ["nginx", "-g", "daemon off;"]

As you can see, the code inside the Dockerfile reflects the seven steps I talked about above.

The FROM instruction sets Ubuntu as the base image making an ideal environment for building any application.

The RUN instruction installs standard packages necessary for building NGINX from source.

The COPY instruction here is something new. This instruction is responsible for copying the the nginx-1.19.2.tar.gz file inside the image. The generic syntax for the COPY instruction is COPY <source> <destination> where source is in your local filesystem and the destination is inside your image. The . as the destination means the working directory inside the image which is by default / unless set otherwise.

The second RUN instruction here extracts the contents from the archive using tar and gets rid of it afterwards.

The archive file contains a directory called nginx-1.19.2 containing the source code. So on the next step, you'll have to cd inside that directory and perform the build process. You can read the How to Install Software from Source Code… and Remove it Afterwards article to learn more on the topic.

Once the build and installation is complete, you remove the nginx-1.19.2 directory using rm command.

On the final step you start NGINX in single process mode just like you did before.

Now to build an image using this code, execute the following command:

docker image build --tag custom-nginx:built .

# Step 1/7 : FROM ubuntu:latest
#  ---> d70eaf7277ea
# Step 2/7 : RUN apt-get update &&     apt-get install build-essential                    libpcre3                     libpcre3-dev                     zlib1g                     zlib1g-dev                     libssl-dev                     -y &&     apt-get clean && rm -rf /var/lib/apt/lists/*
#  ---> Running in 2d0aa912ea47
### LONG INSTALLATION STUFF GOES HERE ###
# Removing intermediate container 2d0aa912ea47
#  ---> cbe1ced3da11
# Step 3/7 : COPY nginx-1.19.2.tar.gz .
#  ---> 7202902edf3f
# Step 4/7 : RUN tar -xvf nginx-1.19.2.tar.gz && rm nginx-1.19.2.tar.gz
 ---> Running in 4a4a95643020
### LONG EXTRACTION STUFF GOES HERE ###
# Removing intermediate container 4a4a95643020
#  ---> f9dec072d6d6
# Step 5/7 : RUN cd nginx-1.19.2 &&     ./configure         --sbin-path=/usr/bin/nginx         --conf-path=/etc/nginx/nginx.conf         --error-log-path=/var/log/nginx/error.log         --http-log-path=/var/log/nginx/access.log         --with-pcre         --pid-path=/var/run/nginx.pid         --with-http_ssl_module &&     make && make install
#  ---> Running in b07ba12f921e
### LONG CONFIGURATION AND BUILD STUFF GOES HERE ###
# Removing intermediate container b07ba12f921e
#  ---> 5a877edafd8b
# Step 6/7 : RUN rm -rf /nginx-1.19.2
#  ---> Running in 947e1d9ba828
# Removing intermediate container 947e1d9ba828
#  ---> a7702dc7abb7
# Step 7/7 : CMD ["nginx", "-g", "daemon off;"]
#  ---> Running in 3110c7fdbd57
# Removing intermediate container 3110c7fdbd57
#  ---> eae55f7369d3
# Successfully built eae55f7369d3
# Successfully tagged custom-nginx:built

This code is alright but there are some places where we can make improvements.

Instead of hard coding the filename like nginx-1.19.2.tar.gz, you can create an argument using the ARG instruction. This way, you'll be able to change the version or filename by just changing the argument.

Instead of downloading the archive manually, you can let the daemon download the file during the build process. There is another instruction like COPY called the ADD instruction which is capable of adding files from the internet.

Open up the Dockerfile file and update its content as follows:

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install build-essential\ 
                    libpcre3 \
                    libpcre3-dev \
                    zlib1g \
                    zlib1g-dev \
                    libssl1.1 \
                    libssl-dev \
                    -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG FILENAME="nginx-1.19.2"
ARG EXTENSION="tar.gz"

ADD https://nginx.org/download/${FILENAME}.${EXTENSION} .

RUN tar -xvf ${FILENAME}.${EXTENSION} && rm ${FILENAME}.${EXTENSION}

RUN cd ${FILENAME} && \
    ./configure \
        --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --pid-path=/var/run/nginx.pid \
        --with-http_ssl_module && \
    make && make install

RUN rm -rf /${FILENAME}}

CMD ["nginx", "-g", "daemon off;"]

The code is almost identical to the previous code block except for a new instruction called ARG on line 13, 14 and the usage of the ADD instruction on line 16. Explanation for the updated code is as follows:

The ARG instruction lets you declare variables like in other languages. These variables or arguments can later be accessed using the ${argument name} syntax. Here, I've put the filename nginx-1.19.2 and the file extension tar.gz in two separate arguments. This way I can switch between newer versions of NGINX or the archive format by making a change in just one place. In the code above, I've added default values to the variables. Variable values can be passed as options of the image build command as well. You can consult the official reference for more details.

In the ADD instruction, I've formed the download URL dynamically using the arguments declared above. The https://nginx.org/download/${FILENAME}.${EXTENSION} line will result in something like https://nginx.org/download/nginx-1.19.2.tar.gz during the build process. You can change the file version or the extension by changing it in just one place thanks to the ARG instruction.

The ADD instruction doesn't extract files obtained from the internet by default, hence the usage of tar on line 18.

The rest of the code is almost unchanged. You should be able to understand the usage of the arguments by yourself now. Finally let's try to build an image from this updated code.

docker image build --tag custom-nginx:built .

# Step 1/9 : FROM ubuntu:latest
#  ---> d70eaf7277ea
# Step 2/9 : RUN apt-get update &&     apt-get install build-essential                    libpcre3                     libpcre3-dev                     zlib1g                     zlib1g-dev                     libssl-dev                     -y &&     apt-get clean && rm -rf /var/lib/apt/lists/*
#  ---> cbe1ced3da11
### LONG INSTALLATION STUFF GOES HERE ###
# Step 3/9 : ARG FILENAME="nginx-1.19.2"
#  ---> Running in 33b62a0e9ffb
# Removing intermediate container 33b62a0e9ffb
#  ---> fafc0aceb9c8
# Step 4/9 : ARG EXTENSION="tar.gz"
#  ---> Running in 5c32eeb1bb11
# Removing intermediate container 5c32eeb1bb11
#  ---> 36efdf6efacc
# Step 5/9 : ADD https://nginx.org/download/${FILENAME}.${EXTENSION} .
# Downloading [==================================================>]  1.049MB/1.049MB
#  ---> dba252f8d609
# Step 6/9 : RUN tar -xvf ${FILENAME}.${EXTENSION} && rm ${FILENAME}.${EXTENSION}
#  ---> Running in 2f5b091b2125
### LONG EXTRACTION STUFF GOES HERE ###
# Removing intermediate container 2f5b091b2125
#  ---> 2c9a325d74f1
# Step 7/9 : RUN cd ${FILENAME} &&     ./configure         --sbin-path=/usr/bin/nginx         --conf-path=/etc/nginx/nginx.conf         --error-log-path=/var/log/nginx/error.log         --http-log-path=/var/log/nginx/access.log         --with-pcre         --pid-path=/var/run/nginx.pid         --with-http_ssl_module &&     make && make install
#  ---> Running in 11cc82dd5186
### LONG CONFIGURATION AND BUILD STUFF GOES HERE ###
# Removing intermediate container 11cc82dd5186
#  ---> 6c122e485ec8
# Step 8/9 : RUN rm -rf /${FILENAME}}
#  ---> Running in 04102366960b
# Removing intermediate container 04102366960b
#  ---> 6bfa35420a73
# Step 9/9 : CMD ["nginx", "-g", "daemon off;"]
#  ---> Running in 63ee44b571bb
# Removing intermediate container 63ee44b571bb
#  ---> 4ce79556db1b
# Successfully built 4ce79556db1b
# Successfully tagged custom-nginx:built

Now you should be able to run a container using the custom-nginx:built image.

docker container run --rm --detach --name custom-nginx-built --publish 8080:80 custom-nginx:built

# 90ccdbc0b598dddc4199451b2f30a942249d85a8ed21da3c8d14612f17eed0aa

docker container ls

# CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                  NAMES
# 90ccdbc0b598        custom-nginx:built   "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:8080->80/tcp   custom-nginx-built

A container using the custom-nginx:built-v2 image has been successfully run. The container should be accessible at http://127.0.0.1:8080 now.

And here is the trusty default response page from NGINX. You can visit the official reference site to learn more about the available instructions.

How to Optimize Docker Images
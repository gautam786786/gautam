## 1) Create a Dockerfile

With containers, the process will be:

1. Choose a base docker image with application dependencies and libraries (steps 1 and 2 for VMs).
2. Build the application.
3. Deploy the application into the image.

This process will be described into a file called *Dockerfile*. Let's see the following example:


```dockerfile
# Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY "WebApp.csproj" .
RUN dotnet restore "WebApp.csproj"
COPY . .
RUN dotnet build "WebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApp.dll"]
```

Note that in this Dockerfile, we are using 2 different docker images. One is used to build the application (sdk). And a second one is used to run the app (aspnet).

## 2) Build docker image

Run the same command and assign a name to the image:

```bash
$ docker build --rm -t webapp:1.0 .
```

Check the images exists:

```bash
$ docker images
```

## 3) Run a docker image

Let's run a container based on the image created earlier:

```bash
$ docker run --rm -d -p 5000:80/tcp webapp:1.0
```

Open web browser on *localhost:5000* to see the application running.

List the running docker containers:

```bash
$ docker ps
```

## 3) Run a command inside a docker container
Explore the command docker exec.
```bash
$ docker exec <CONTAINER_ID> -- ls
```

## 5) Stop a container

Explore the command docker stop.
```bash
$ docker stop <CONTAINER_ID>
```

## 6) Remove a container

Explore the command docker rm.
```bash
$ docker rm <CONTAINER_ID>
```

## 7) Remove an image

Explore the command docker rmi.
```bash
$ docker rmi <IMAGE_ID_OR_NAME>
```

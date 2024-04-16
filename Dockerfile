###########################################
# BASE IMAGE
###########################################

FROM ubuntu AS build     //sets base image from ubuntu and assign it the alias "build"

RUN apt-get update && apt-get install -y golang-go       //go lang installation

ENV GO111MODULE=off          //environment varaible off as specific to certain project not for all Go applications

COPY . .                   // copies all files from current directory (where dockerfile resides ) into build stage contianer

RUN CGO_ENABLED=0 go build -o /app .   //build go applicaton and (.)places the compiled binary at the location /app within the container 


############################################
# HERE STARTS THE MAGIC OF MULTI STAGE BUILD
############################################

FROM scratch //distroless minimization images till now

# Copy the compiled binary from the build stage
COPY --from=build /app /app

# Set the entrypoint for the container to run the binary
ENTRYPOINT ["/app"]

/* This multi-stage build separates the build process (stage 1) from the final image (stage 2). Stage 1 builds your Go application in a larger Ubuntu image with the necessary tools. Then, stage 2 takes only the compiled binary and places it in a minimal "scratch" image, resulting in a smaller and more efficient final image. */

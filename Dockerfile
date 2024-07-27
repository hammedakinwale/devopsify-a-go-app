# Stage 1: Build the Go application
FROM golang:1.22.5 as base

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod file
COPY go.mod ./

# download dependencies
RUN go mod download

# Copy the rest of the application's source code
COPY . .

# Build the Go application
RUN go build -o main .

# Stage 2: Create the distroless image
FROM gcr.io/distroless/base

# Copy the built Go binary from the builder stage
COPY --from=base /app/main .

# Copy the static files
COPY --from=base /app/static ./static

# expose the app on port 8080

EXPOSE 8080

# run the the built app
CMD [ "./main" ]

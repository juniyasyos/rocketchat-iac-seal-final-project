# Stage 1: Build the Go binary
FROM golang:1.23-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy go.mod files first for dependency caching
COPY go.mod .

# Download dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go binary
RUN go build -o main .

# Stage 2: Create a lightweight image with the Go binary
FROM alpine:3.18

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory
WORKDIR /app

# Copy the built Go binary from the builder stage
COPY --from=builder /app/main .

# Change ownership of the binary to the non-root user
RUN chown appuser:appgroup /app/main

# Run the application as the non-root user
USER appuser

# Expose the port
EXPOSE 8080

# Set the entry point command
CMD ["./main"]

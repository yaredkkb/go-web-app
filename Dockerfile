FROM golang:1.22 AS build

WORKDIR /app

# Copy the module definition file
COPY go.mod ./

# Copy the rest of your source code
COPY . .

# Compiles your application directly into a static binary
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o main main.go

# FINAL STAGE - DISTROLESS IMAGE
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

COPY --from=build --chown=nonroot:nonroot /app/main ./main

USER nonroot:nonroot

EXPOSE 8080

CMD ["./main"]

# FIXED: Changed 'As' to uppercase 'AS'
FROM golang:1.22 AS build

WORKDIR /app

# go.sum might not exist yet if you haven't run go mod tidy, 
# using a wildcard ensures the build doesn't crash if it's missing
COPY go.mod go.sum* ./

RUN go mod download

COPY . .

# Compiles your root main.go file into the 'main' binary target
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o main main.go

# FINAL STAGE - DISTROLESS IMAGE
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

COPY --from=build --chown=nonroot:nonroot /app/main ./main

# Note: Only keep this line if you have a folder named 'static' in your repository!
COPY --from=build --chown=nonroot:nonroot /app/static ./static

USER nonroot:nonroot

EXPOSE 8080

CMD ["./main"]

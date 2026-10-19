FROM golang:1.23-alpine

WORKDIR /app

# 1. Copy the dependency manifests first
COPY go.mod go.sum ./

# 2. Download the dependencies 
RUN go mod download

# 3. Copy the rest of your source code repository
COPY . .

RUN go build -o main .

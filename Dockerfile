FROM golang:1.23-alpine 

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o main .

#FINAL STAGE - DISTROLESS IMAGE

FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

COPY --from=build --chown=nonroot:nonroot /app/main ./main

COPY --from=build --chown=nonroot:nonroot /app/static ./static

USER nonroot:nonroot

EXPOSE 8080

CMD ["./main"]
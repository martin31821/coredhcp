# build stage
FROM golang:1.17-alpine as builder
ENV GO111MODULE=on
WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
WORKDIR /app/cmds/coredhcp
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

# final stage
FROM scratch
COPY --from=builder /app/cmds/coredhcp/coredhcp /app/
EXPOSE 8080
VOLUME /data
WORKDIR /data
ENTRYPOINT ["/app/coredhcp"]

# Build the Go program
FROM golang:1.23 AS builder
RUN apt-get update && apt-get install -y wget xz-utils
RUN cd /usr/local/bin && wget -O- https://github.com/upx/upx/releases/download/v4.2.4/upx-4.2.4-amd64_linux.tar.xz | tar -Jxvf- --strip-components=1 upx-4.2.4-amd64_linux/upx


WORKDIR /app
COPY . .
RUN go mod init smol
RUN CGO_ENABLED=0 go build -o smol -ldflags="-w -s" .
RUN upx --best --lzma smol

# Create a minimal runtime image
FROM scratch
COPY --from=builder /app/smol /smol
CMD ["/smol"]

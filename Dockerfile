FROM golang:1.26.3-alpine AS builder

WORKDIR /app

RUN adduser -D -g '' appuser

RUN apk add --no-cache ca-certificates

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 \
    GOOS=linux \
    go build -ldflags="-w -s" -o git-shield ./cmd/main.go


# Final stage
FROM scratch

# Copy the info about user
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Copy the certificates 
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

WORKDIR /app

COPY --from=builder --chown=appuser:appuser /app/git-shield .

USER appuser

EXPOSE 4123

CMD ["./git-shield"]
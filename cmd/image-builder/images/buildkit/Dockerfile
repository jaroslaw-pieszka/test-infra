FROM alpine:3.17.1 AS creds

RUN apk add --no-cache curl && \
  curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v2.1.5/docker-credential-gcr_linux_amd64-2.1.5.tar.gz" \
  | tar xz docker-credential-gcr \
  && chmod +x docker-credential-gcr && mv docker-credential-gcr /usr/bin/

FROM europe-docker.pkg.dev/kyma-project/prod/testimages/buildpack-go:v20231128-9bb59ac6 AS builder

WORKDIR /
COPY . /app/
RUN cd /app/cmd/image-builder && CGO_ENABLED=0 go build -o /app/image-builder -a -ldflags '-extldflags "-static"' .

FROM moby/buildkit:v0.11.1-rootless

COPY --from=creds /usr/bin/docker-credential-gcr /usr/bin/
RUN docker-credential-gcr configure-docker --registries=eu.gcr.io,europe-docker.pkg.dev

ENV USE_BUILDKIT=true

COPY --from=builder /app/image-builder /image-builder

ENTRYPOINT ["/image-builder"]

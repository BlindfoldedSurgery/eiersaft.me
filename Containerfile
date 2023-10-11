FROM debian:stable-slim as builder

RUN apt-get update && \
    apt-get install -y git

COPY --from=ghcr.io/getzola/zola:v0.17.2 /bin/zola /bin/zola
RUN chmod +x /bin/zola

WORKDIR /usr/app

COPY config.toml config.toml
COPY content content
COPY static static
COPY templates templates
RUN git clone https://github.com/cydave/zola-theme-papermod themes/zola-theme-papermod

RUN /bin/zola build

FROM nginxinc/nginx-unprivileged:1.25.2-alpine-slim

COPY --from=builder /usr/app/public/ /usr/share/nginx/html/

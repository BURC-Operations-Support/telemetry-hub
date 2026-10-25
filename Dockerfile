# syntax=docker/dockerfile:1

FROM ubuntu:26.04

WORKDIR /workspace

COPY --chmod=755 ./scripts/verify-platform.sh /usr/local/bin/verify-platform.sh

COPY --from=ghcr.io/astral-sh/uv:0.12.19 /uv /uvx /usr/local/bin/

ENV UV_PROJECT_ENVIRONMENT="/opt/venv"

RUN uv python install 3.14

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/local/bin/verify-platform.sh

CMD ["bash"]
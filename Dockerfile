# syntax=docker/dockerfile:1
#
# TITLE: Telemetry Hub
# DESCRIPTION: Base Docker image for BURC Telemetry Hub project
# AUTHOR: Cole H. Shaigec
# DATE: November 2026
# MAINTAINERS: Boston University Robotics Club
#
# USAGE: 
#   make <command>
#
# NOTES:
#   The project Makefile provides a predefined Docker interface for this project.
#   Where possible, use the Makefile interface instead of direct Docker invocations.


# ------------------------------------------------------------
# Stage 1: Development
# Installs club-standard Ubuntu image, Python, and core developer tooling
# TODO: This stage should be linked to the eventual CMBE club-standard Ubuntu distro
# ------------------------------------------------------------
FROM ubuntu:26.04 AS development

WORKDIR /workspace

COPY --chmod=755 ./scripts/verify-platform.sh /usr/local/bin/verify-platform.sh

COPY --from=ghcr.io/astral-sh/uv:0.12.19 /uv /uvx /usr/local/bin/

ENV UV_PROJECT_ENVIRONMENT="/opt/venv"
ENV UV_PYTHON_INSTALL_DIR="/opt/python"

RUN uv python install 3.14

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/local/bin/verify-platform.sh

CMD ["bash"]

# ------------------------------------------------------------
# Stage 2: Builder
# Copies development build context into /workspace
# Establishes locked venv, builds wheel, and installs project into venv
# Kept separate from Runtime to keep build tooling out of deployed image
# ------------------------------------------------------------

FROM development AS builder

COPY . .

RUN uv sync --locked --no-dev --no-install-project \
    && uv build --wheel \
    && uv pip install \
        --python /opt/venv/bin/python \
        --no-deps \
        dist/*.whl

# ------------------------------------------------------------
# Stage 3: Runtime
# Copies packaged wheel into runtime image
# Ensures that service runs as non-root user
# Will be published to GHCR for deployment
# ------------------------------------------------------------

FROM ubuntu:26.04 AS runtime

WORKDIR /app

# Copy uv-managed Python installation from builder
COPY --from=builder /opt/python /opt/python

# Copy locked production virtual environment
COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN useradd --system --no-create-home --shell /usr/sbin/nologin telemetry

USER telemetry

ENTRYPOINT ["telemetryhub"]
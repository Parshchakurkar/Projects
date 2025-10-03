FROM python:3.13.5-slim AS base

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apache2-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /seed

# Copy the source code into the container.
COPY . .
RUN python3 make-data.py

# Run the application.
CMD ["/seed/generate-votes.sh"]

FROM python:3.13.5-slim AS base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

# Add curl for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download dependencies as a separate step to take advantage of Docker's caching.
COPY Requirement.txt  ./Requirement.txt
RUN pip install --no-cache-dir -r Requirement.txt

#watch file system change
RUN pip install watchdog
ENV FLASK_ENV=PreProd

# Run the application.
CMD ["python3" , "app.py"]

FROM  base AS final
# Copy the source code into the container.
COPY . .

# Expose the port that the application listens on.
EXPOSE 80

# Define our command to be run when launching the container
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:80", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]
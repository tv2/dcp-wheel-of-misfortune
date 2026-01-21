# Use Python slim image for smaller size
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy the application script
COPY application.py .

# Make the script executable
RUN chmod +x application.py

# Disable Python output buffering
ENV PYTHONUNBUFFERED=1

# Expose health check port
EXPOSE 8080

# Set the entrypoint to the script
ENTRYPOINT ["python3", "-u", "application.py"]

# Default parameters (can be overridden)
CMD ["--size", "100kb", "--interval", "0.5", "--health-port", "8080"]

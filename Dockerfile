# Use the official PostgreSQL image as the base image
FROM postgres:latest

WORKDIR /app

# Expose PostgreSQL port
EXPOSE 5432
# Use the official Python image as the base image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /dbt_project

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*


RUN update-ca-certificates

# Install dbt and any additional dependencies
RUN pip install dbt

# Set up environment variables
ENV DBT_PROFILE=default
ENV DBT_TARGET=dev

# Set the entrypoint command for the container
ENTRYPOINT ["dbt"]

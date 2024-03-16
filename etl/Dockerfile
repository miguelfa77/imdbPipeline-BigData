FROM python:3.12-slim

WORKDIR /app

RUN pip install pandas requests mysql-connector-python sqlalchemy

# Copy the ELT script
COPY etl_script.py .

# Add the cron job
# This example runs the script every day at 3am.
# Adjust the cron timing as needed.
#RUN echo "0 3 * * * python /app/etl_script.py" | crontab -


# Set the default command to run the ELT script
CMD ["python", "etl_script.py"]
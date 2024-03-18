FROM python:3.10-slim

WORKDIR /app

RUN pip install pandas requests mysql-connector-python sqlalchemy

# Copy the ELT script
COPY etl_script.py .

# cron job
#RUN echo "* * * * * python /app/etl_script.py" | crontab -


# Set the default command to run the ELT script
CMD ["python", "etl_script.py"]
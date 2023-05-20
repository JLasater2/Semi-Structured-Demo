# 
# This script generates security event log data containing
# a source IP from a sample IP geolocation dataset in Snowflake.
# This lookup allows for referential integrity between this data set
# and the data to be joined to - IP geolocation data.
#

from faker import Faker
import json
import random
import snowflake.connector
import csv
import datetime
import config

# Instantiate the Faker object
fake = Faker()

# Create a list to store the firewall logs
security_event_logs = []

# Set the number of logs to generate
num_logs = 56087

# Define the date range for the logs
start_date =config.start_date
end_date = config.end_date

# Retrieve credentials
with open('../Common/faker.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    for row in csvreader:
        password = row[1]

# Set up a connection to Snowflake to read in IPs
conn = snowflake.connector.connect(
    user='faker',
    password=password,
    account='rr33146.us-east-2.aws',
    warehouse='compute_wh',
    database='ipinfo_free_ip_geolocation_sample',
    schema='demo',
    role='faker_read_only'
)

# Execute a SQL query to retrieve the Source IP column from your Snowflake table
cursor = conn.cursor()
cursor.execute('SELECT start_ip FROM ipinfo_free_ip_geolocation_sample.demo.location')
rows = cursor.fetchall()

# Loop through the number of logs to generate
for i in range(num_logs):
    # Generate a random date between the start and end dates
    date = fake.date_between_dates(date_start=start_date, date_end=end_date)
    
    # Generate random IP addresses
    source_ip = random.choice(rows)[0]
    dest_ip = fake.ipv4()

    # Generate random port numbers
    source_port = random.randint(1024, 65535)
    dest_port = random.randint(1, 1023)

    # Generate random protocol
    protocol = random.choice(['TCP', 'UDP'])

    # Generate random action
    action = random.choice(['Allowed', 'Blocked'])

    # Create a dictionary to represent the firewall log
    security_event_log = {
        'Date': date.strftime('%Y-%m-%d'),
        'Time': fake.time(),
        'Source IP': source_ip,
        'Destination IP': dest_ip,
        'Protocol': protocol,
        'Source Port': source_port,
        'Destination Port': dest_port,
        'Action': action#,
       # 'Rule': rule
    }

    # Append the firewall log dictionary to the list
    security_event_logs.append(security_event_log)

# Write the list of firewall logs to a JSON file
with open('faker/output/security_event_log.json', 'w') as file:
    json.dump(security_event_logs, file, indent=4)
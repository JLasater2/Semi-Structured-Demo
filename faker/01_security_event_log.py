from faker import Faker
import json
import random
import snowflake.connector

# Instantiate the Faker object
fake = Faker()

# Create a list to store the firewall logs
firewall_logs = []

# Set the number of logs to generate
num_logs = 10

# Set up a connection to Snowflake
conn = snowflake.connector.connect(
    user='faker',
    password='fakermaker#',
    account='rr33146.us-east-2.aws',
    warehouse='compute_wh',
    database='ipinfo_free_ip_geolocation_sample',
    schema='demo'
)

# Execute a SQL query to retrieve the Source IP column from your Snowflake table
cursor = conn.cursor()
cursor.execute('SELECT * FROM ipinfo_free_ip_geolocation_sample.demo.location')
rows = cursor.fetchall()

# Loop through the number of logs to generate
for i in range(num_logs):
    # Generate random IP addresses
    source_ip = fake.ipv4()
    dest_ip = fake.ipv4()

    # Generate random port numbers
    source_port = random.randint(1024, 65535)
    dest_port = random.randint(1, 1023)

    # Generate random protocol
    protocol = random.choice(['TCP', 'UDP'])

    # Generate random action
    action = random.choice(['Allowed', 'Blocked'])

    # Generate a random rule name
    rule = fake.word()

    # Create a dictionary to represent the firewall log
    firewall_log = {
        'Date': fake.date(),
        'Time': fake.time(),
        'Source IP': source_ip,
        'Destination IP': dest_ip,
        'Protocol': protocol,
        'Source Port': source_port,
        'Destination Port': dest_port,
        'Action': action,
        'Rule': rule
    }

    # Append the firewall log dictionary to the list
    firewall_logs.append(firewall_log)

# Write the list of firewall logs to a JSON file
with open('faker/output/firewall_log.json', 'w') as file:
    json.dump(firewall_logs, file)
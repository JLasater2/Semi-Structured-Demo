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
US_IP_cursor = conn.cursor()
US_IP_cursor.execute("SELECT start_ip FROM ipinfo_free_ip_geolocation_sample.demo.location WHERE country = 'US' and region = 'Colorado' and contains(start_ip, '.')")
US_IPs = US_IP_cursor.fetchall()

source_IP_compromised_cursor = conn.cursor()
source_IP_compromised_cursor.execute("SELECT start_ip FROM ipinfo_free_ip_geolocation_sample.demo.location WHERE country not in('US', 'IN') and contains(start_ip, '.')")
non_US_IPs_compromised = source_IP_compromised_cursor.fetchall()

# Loop through the number of logs to generate
for i in range( config.security_event_log_num_logs ):

    # Generate logs indicating an account was compromised
    if random.random() < config.security_event_log_pct_compromised_activity:

          # Generate a random date between the start and end dates
        date = fake.date_between_dates( date_start = config.compromised_start_date, date_end = config.compromised_end_date )

        # Generate random IP addresses
        source_ip = random.choice(non_US_IPs_compromised)[0]
        dest_ip = fake.ipv4()

        # Randomly select user name
        username = config.compromised_user_name

        # Generate random port numbers
        source_port = random.randint(1024, 65535)
        dest_port = random.randint(1, 1023)

        # Generate random protocol
        protocol = random.choice(['TCP', 'UDP'])

        # Generate random action
        action = random.choice(['Allowed', 'Blocked'])

    else:

        # Generate a random date between the start and end dates
        date = fake.date_between_dates( date_start = config.start_date, date_end = config.end_date )
        
        # Generate random IP addresses
        source_ip = random.choice(US_IPs)[0]
        dest_ip = fake.ipv4()

        # Randomly select user name
        username = random.choice( config.usernames )

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
        'Username' : username,
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

print("Done!")
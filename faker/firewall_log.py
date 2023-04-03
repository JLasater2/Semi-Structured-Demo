from faker import Faker
import json
import random

# Instantiate the Faker object
fake = Faker()

# Create a list to store the firewall logs
firewall_logs = []

# Set the number of logs to generate
num_logs = 10

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
with open('firewall_logs.json', 'w') as file:
    json.dump(firewall_logs, file)
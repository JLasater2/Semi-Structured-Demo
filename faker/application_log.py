from faker import Faker
import json
import random

# Instantiate the Faker object
fake = Faker()

# Create a list to store the application logs
app_logs = []

# Set the number of logs to generate
num_logs = 1000

# Loop through the number of logs to generate
for i in range(num_logs):
    # Generate a random event type
    event_type = random.choice(['Info', 'Warning', 'Error'])

    # Generate a random username
    username = fake.user_name()

    # Generate a random IP address
    ip_address = fake.ipv4()

    # Generate a random error message
    error_message = fake.sentence()

    # Create a dictionary to represent the application log
    app_log = {
        'Date': fake.date(),
        'Time': fake.time(),
        'Application': 'Sales System',
        'Event Type': event_type,
        'Event Description': fake.sentence(),
        'Username': username,
        'IP Address': ip_address,
        'Error Message': error_message
    }

    # Append the application log dictionary to the list
    app_logs.append(app_log)

# Write the list of application logs to a JSON file
with open('faker/output/application_log.json', 'w') as file:
    json.dump(app_logs, file, indent=4)


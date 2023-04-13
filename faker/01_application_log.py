from faker import Faker
import json
import random
import datetime

# Instantiate the Faker object
fake = Faker()

# Create a list to store the application logs
app_logs = []

# Define the date range for the logs
start_date = datetime.date(2023, 4, 1)
end_date = datetime.date(2023, 4, 10)

event_description = ''

# Set the number of logs to generate
num_logs = 100

# Loop through the number of logs to generate
for i in range(num_logs):
    # Generate a random event type
    event_type = random.choice(['Info', 'Warning', 'Error'])

    if event_type == "Error":
        event_description = "Login failed"
    elif event_type == "Info":
        event_description = "Account profile -  account " + str(random.randint(100000000, 9999999999))

    # Generate a random username
    username = fake.user_name()

    # Generate a random IP address
    ip_address = fake.ipv4()

    # Create a dictionary to represent the application log
    app_log = {
        'Date': str(fake.date_between_dates(date_start=start_date, date_end=end_date)),
        'Time': fake.time(),
        'Application': 'Sales System',
        'Event Type': event_type,
        'Event Description': event_description,
        'Username': username,
        #'IP Address': ip_address,
        #'Error Message': error_message
    }

    # Append the application log dictionary to the list
    app_logs.append(app_log)

# Write the list of application logs to a JSON file
with open('faker/output/application_log.json', 'w') as file:
    json.dump(app_logs, file, indent=4)


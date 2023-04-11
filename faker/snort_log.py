from faker import Faker
import json
import random
from datetime import datetime, timedelta

# Instantiate the Faker object
fake = Faker()

# Create a list to store the application logs
app_logs = []

# Set the number of logs to generate
num_logs = 1000

# Set date boundaries
start_date = datetime.strptime('2023-01-01', '%Y-%m-%d')
end_date = datetime.strptime('2023-04-20', '%Y-%m-%d')

# Loop through the number of logs to generate
for i in range(num_logs):
    # # Generate a random event type
    # event_type = random.choice(['Info', 'Warning', 'Error'])

    # if event_type == 'Error':
    #     error_message = "Login failed"
    # else:
    #     error_message = ''

    # Generate a random IP address
    source_ip = fake.ipv4()

    # Generate a random IP address
    dest_ip = fake.ipv4()

    # Generate a random alert classification
    msg = random.choice(['attempted-admin', 'attempted-recon', 'attempted-user', 'policy-violation','shellcode-detect','trojan-activity'])

    # Priority
    priority = random.choice([1,2,3,4])

    # Create a dictionary to represent the application log
    app_log = {
        'Date': fake.date_between(start_date=start_date, end_date=end_date).strftime('%Y-%m-%d'),
        'Time': fake.time(),
        'Source IP': source_ip,
        'Dest IP': dest_ip,
        'Application': 'Sales System',
        'Alert': {
            'Msg': msg,
            # 'Event Type': event_type,
            'Desc': fake.sentence(),
            # 'Error Message': error_message,
            'Priority': priority
        }
        
    }

    # Append the application log dictionary to the list
    app_logs.append(app_log)

# Write the list of application logs to a JSON file
with open('faker/output/snort_log.json', 'w') as file:
    json.dump(app_logs, file, indent=4)


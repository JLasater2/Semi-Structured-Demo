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

    # Define the choices for the event types and their corresponding probabilities
    event_type_choices = [
        ('Cust Profile Maint', 0.1),
        ('Cust Profile View', 0.5),
        ('Account Maint', 0.1),
        ('Account View', 0.3)
    ]

    # Create a weighted list of event types
    event_types = [c[0] for c in event_type_choices for i in range(int(c[1]*10))]

    # Randomly select an event type from the weighted list
    event_type = random.choice(event_types)

    # Generate a random username
    username = fake.user_name()

    # Generate a random IP address
    ip_address = fake.ipv4()

    # Create a dictionary to represent the application log
    app_log = {
        'Date': str(fake.date_between_dates(date_start=start_date, date_end=end_date)),
        'Time': fake.time(),
        'Username': username,
        'Application':  'CustInsight360', 
        'Event Type': event_type
    }

    # Add account details if the event type is 'Account View'
    if event_type == 'Account View':
        # Set random account type
        app_log['Event Details'] = {}
        app_log['Event Details']['Account Type'] = random.choice(['Platinum Checking', 'Premier Savings', 'Advantage Money Market'])

        # Generate fake acct number
        app_log['Event Details']['Account Number'] = str(random.randint(100000000, 9999999999))

        # Generate fake currency amount between two amounts
        min_amount = 10000.50
        max_amount = 999000.25
        current_balance = round(fake.random.uniform(min_amount, max_amount), 2)
        app_log['Event Details']['Current Balance'] = current_balance

    # Add customer details if the event type is 'Cust Profile View'
    if event_type == 'Cust Profile View':
        app_log['Event Details'] = {}
        app_log['Event Details']['Customer ID']  = 'TX-' + str(random.randint(100000000, 9999999999))

    # Add customer details if the event type is 'Cust Profile Maint'
    if event_type == 'Cust Profile Maint':
        app_log['Event Details'] = {}
        app_log['Event Details']['Primary Phone']  = {}
        app_log['Event Details']['Primary Phone']['Previous Value'] = fake.phone_number()
        app_log['Event Details']['Primary Phone']['New Value'] = fake.phone_number()

    # Add customer details if the event type is 'Account Maint'
    if event_type == 'Account Maint':
        # Generate fake acct number
        app_log['Event Details'] = {}
        app_log['Event Details']['Account Number'] = str(random.randint(100000000, 9999999999))
        app_log['Event Details']['Add authorized signor'] = 'TX-' + str(random.randint(100000000, 9999999999))

    # Append the application log dictionary to the list
    app_logs.append(app_log)

# Write the list of application logs to a JSON file
with open('faker/output/application_log.json', 'w') as file:
    json.dump(app_logs, file, indent=4)


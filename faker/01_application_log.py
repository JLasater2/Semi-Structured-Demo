from faker import Faker
import json
import random
import datetime
import config

# Instantiate the Faker object
fake = Faker()

# Create a list to store the application logs
app_logs = []

event_description = ''

# Define a list of distinct usernames
usernames = []
usernames.append("norman58") # add bad guy
while len(usernames) < 45:
    username = fake.user_name()
    if username not in usernames:
        usernames.append(username)

# Set the number of logs to generate
num_logs = 20587 

# Loop through the number of logs to generate
for i in range(num_logs):

    # For 30% of the records, use a specified user name 
    # else for the other 70% generate a random user name
    if random.random() < 0.2:
        username = "norman58"  #the bad guy

        # Define the date range for the logs
        start_date = datetime.date(2023, 5, 1)
        end_date = datetime.date(2023, 5, 10)

        # Define the choices for the event types and their corresponding probabilities
        event_type_choices = [
            ('Cust Profile Maint', 0.0),
            ('Cust Profile View', 0.05),
            ('Account Maint', 0.05),
            ('Account View', 0.8)  #lots of account views
        ]

        # Generate fake currency amount between two amounts
        min_amount = 100000.50
        max_amount = 999000.25
    else: 
        username = random.choice(usernames)

        # Define the date range for the logs
        start_date = config.start_date
        end_date = config.end_date

        # Define the choices for the event types and their corresponding probabilities
        event_type_choices = [
            ('Cust Profile Maint', 0.1),
            ('Cust Profile View', 0.5),
            ('Account Maint', 0.1),
            ('Account View', 0.3)
        ]

        # Generate fake currency amount between two amounts
        min_amount = 10000.50
        max_amount = 999000.25

    # Generate a random IP address
    ip_address = fake.ipv4()


    # Create a weighted list of event types
    event_types = [c[0] for c in event_type_choices for i in range(int(c[1]*10))]

    # Randomly select an event type from the weighted list
    event_type = random.choice(event_types)

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

        current_balance = round(fake.random.uniform(min_amount, max_amount), 2)
        app_log['Event Details']['Current Balance'] = current_balance

        # Add an array of the last 5 transactions
        app_log['Event Details']['Recent Txns'] = []
        for j in range(5):
            transaction = {
                'Date': str(fake.date_between_dates(date_start=start_date, date_end=end_date)),
                'Type': random.choice(['POS Debit', 'Check Credit', 'ACH Debit', 'Check Deposit']),
                'Amount': round(fake.random.uniform(10.00, 2000.00), 2)
            }
            app_log['Event Details']['Recent Txns'].append(transaction)


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


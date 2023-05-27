import datetime
from faker import Faker
import os

# Instantiate the Faker object
fake = Faker()

# set the compromised account's user name
compromised_user_name = "norman58"
compromised_start_date = datetime.date(2023, 5, 24)
compromised_end_date = datetime.date(2023, 6, 1)

# pct of records for compromised activity
application_log_pct_compromised_activity = 0.05
security_event_log_pct_compromised_activity = 0.05

# Import usernames from the file if the file already exists
# This is needed so that usernames are consistent across executions
filename = "faker/temp/usernames.txt"
if os.path.isfile(filename):
    with open(filename, "r") as file:
        usernames = file.read().splitlines()
    print('Importing usernames from ' + filename)

else:# Define a list of distinct usernames
    usernames = []
    usernames.append(compromised_user_name) # add bad guy
    while len(usernames) < 45:
        username = fake.user_name()
        if username not in usernames:
            usernames.append(username)

    # Save usernames to a file
    filename = 'faker/temp/usernames.txt'
    with open(filename, "w") as file:
        for username in usernames:
            file.write(username + "\n")

    print("Usernames saved to:", filename)

# total record count
application_log_num_logs = 20587
security_event_log_num_logs = 10340

# common variables
start_date = datetime.date(2023, 4, 1)
end_date = datetime.date(2023, 6, 1)
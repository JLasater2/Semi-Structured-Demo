import datetime
from faker import Faker
import os
import random

# Instantiate the Faker object
fake = Faker()

# set the compromised account's user name
compromised_user_name = "norman58"
compromised_start_date = datetime.date(2023, 5, 24)
compromised_end_date = datetime.date(2023, 6, 1)

# pct of records for compromised activity
application_log_pct_compromised_activity = 0.01
security_event_log_pct_compromised_activity = 0.01

filename = "faker/temp/usernames.txt"

usernames = []
weights = []

# if os.path.isfile(filename):
if os.path.isfile(filename):
    # Read usernames and weights from the file
  with open(filename, "r") as file:
    for line in file:
        username, weight = line.strip().split(",")
        usernames.append(username)
        weights.append(float(weight))
    
    print('Imported usernames and weights from ' + filename)

else:
    # Add compromised name and weight 
    usernames.append(compromised_user_name) 
    weights.append(0.3)

    # Add random usernames and weights
    while len(usernames) < 45:
        username = fake.user_name()
        if username not in usernames:
            usernames.append(username)
            weights.append(random.random())

    total_weight = sum(weights)

    # Normalize weights to sum up to 1
    normalized_weights = [w / total_weight for w in weights]

    # Create a list of tuples with usernames and weights
    data = list(zip(usernames, normalized_weights))

    # Write usernames and weights to the file
    with open(filename, 'w') as file:
        for item in data:
            file.write(f"{item[0]},{item[1]}\n")

    print("Usernames and weights saved to:", filename)
    

# total record count
application_log_num_logs = 20587
security_event_log_num_logs = 10340

# common variables
start_date = datetime.date(2023, 4, 1)
end_date = datetime.date(2023, 6, 1)
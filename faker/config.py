import datetime
from faker import Faker

# Instantiate the Faker object
fake = Faker()

# set the compromised account's user name
compromised_user_name = "norman58"
compromised_start_date = datetime.date(2023, 5, 24)
compromised_end_date = datetime.date(2023, 6, 1)

# pct of records for compromised activity
application_log_pct_compromised_activity = 0.2
security_event_log_pct_compromised_activity = 0.2

# Define a list of distinct usernames
usernames = []
usernames.append(compromised_user_name) # add bad guy
while len(usernames) < 45:
    username = fake.user_name()
    if username not in usernames:
        usernames.append(username)

# total record count
application_log_num_logs = 20587
security_event_log_num_logs = 10340

# common variables
start_date = datetime.date(2023, 4, 1)
end_date = datetime.date(2023, 6, 1)
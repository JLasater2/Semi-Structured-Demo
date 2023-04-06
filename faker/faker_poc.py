from faker import Faker
import json

# Create a Faker instance
fake = Faker()

# Define the number of records to generate
num_records = 10

# Define an empty list to store the records
records = []

# Generate the records
for i in range(num_records):
    record = {
        "person": {
            "name": fake.name(),
            "age": fake.random_int(min=18, max=80, step=1),
            "address": {
                "street": fake.street_address(),
                "city": fake.city(),
                "state": fake.state_abbr(),
                "zip": fake.zipcode()
            },
            "phone_numbers": []
        }
    }
    
    # Add a home phone number with a 50% probability
    if fake.boolean(chance_of_getting_true=50):
        record["person"]["phone_numbers"].append({
            "type": "home",
            "number": fake.phone_number()
        })
    
    # Add a work phone number with a 30% probability
    if fake.boolean(chance_of_getting_true=30):
        record["person"]["phone_numbers"].append({
            "type": "work",
            "number": fake.phone_number()
        })
        
    records.append(record)

# Export the records to a JSON file
with open('faker/output/fake_nested_data.json', 'w') as f:
    json.dump(records, f, indent=4)

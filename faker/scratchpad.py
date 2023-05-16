import random
from faker import Faker

def generate_user_names(fake_name_probability, specified_name_probability, num_fake_names=30, specified_name=None):
    fake = Faker()
    user_names = []
    
    for _ in range(num_fake_names):
        if random.random() < fake_name_probability:
            user_names.append(fake.user_name())
    
    if specified_name and random.random() < specified_name_probability:
        user_names.append(specified_name)
    
    return user_names

fake_name_probability = 0.8  # Probability of choosing a fake name (0.0 - 1.0)
specified_name_probability = 0.2  # Probability of choosing the specified name (0.0 - 1.0)
specified_name = "JohnDoe"  # The specified user name

user_names = generate_user_names(fake_name_probability, specified_name_probability, 30, specified_name)

print(user_names)

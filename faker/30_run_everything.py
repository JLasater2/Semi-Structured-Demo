import os
import subprocess

def execute_py_files(directory):
    # Get a list of all files in the directory
    files = os.listdir(directory)
    # Filter out non-Python files
    py_files = [file for file in files if file.startswith(tuple(["01", "05", "10"])) and file.endswith(".py")]
    # Sort the Python files alphabetically
    py_files.sort()

    # Loop through the Python files and execute them
    for file in py_files:
        file_path = os.path.join(directory, file)
        print(f"Executing {file}")
        subprocess.call(['python', file_path])

# Directory containing the Python files
directory = 'faker'

# Execute the Python files in the directory
execute_py_files(directory)
import json
import pyarrow as pa
import pyarrow.parquet as pq
import xml.etree.ElementTree as ET

# Read the JSON file into a list of dictionaries
with open('faker/output/security_event_log.json', 'r') as f:
    data = json.load(f)

# Convert the list of dictionaries to a PyArrow Table
table = pa.Table.from_pydict({k.replace(' ', '_'): [d.get(k, None) for d in data] for k in data[0]})

# Write the PyArrow Table to a Parquet file
with open('faker/output/security_event_log.parquet', 'wb') as f:
    pq.write_table(table, f)

print("Done!")
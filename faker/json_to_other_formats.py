import json
import pyarrow as pa
import pyarrow.parquet as pq
import xml.etree.ElementTree as ET

# Read the JSON file into a list of dictionaries
with open('faker/output/application_log.json', 'r') as f:
    data = json.load(f)

# Convert the list of dictionaries to a PyArrow Table
table = pa.Table.from_pydict({k.replace(' ', '_'): [d.get(k, None) for d in data] for k in data[0]})

# Write the PyArrow Table to a Parquet file
with open('faker/output/application_log.parquet', 'wb') as f:
    pq.write_table(table, f)

# Generate an XML document from the same data
root = ET.Element('application_logs')
for d in data:
    log_elem = ET.SubElement(root, 'log')
    for k, v in d.items():
        field_elem = ET.SubElement(log_elem, k.replace(' ', '_'))
        field_elem.text = str(v)

# Write the XML document to a file
tree = ET.ElementTree(root)
tree.write('faker/output/application_log.xml', encoding='utf-8', xml_declaration=True)

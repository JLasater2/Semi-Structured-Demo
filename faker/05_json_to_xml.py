import json
import xml.etree.ElementTree as ET

def convert_dict_to_xml(element, data):
    for key, value in data.items():
        if isinstance(value, dict):
            sub_element = ET.SubElement(element, key.replace(' ', '_'))
            convert_dict_to_xml(sub_element, value)
        elif isinstance(value, list):
            for item in value:
                sub_element = ET.SubElement(element, key.replace(' ', '_'))
                if isinstance(item, dict):
                    convert_dict_to_xml(sub_element, item)
                else:
                    sub_element.text = str(item)
        else:
            sub_element = ET.SubElement(element, key.replace(' ', '_'))
            sub_element.text = str(value)

# Read JSON data from a file
with open('faker/output/application_log.json', 'r') as f:
    json_data = json.load(f)

# Generate an XML document from the JSON data
root = ET.Element('application_logs')
for item in json_data:
    log_element = ET.SubElement(root, 'log')
    convert_dict_to_xml(log_element, item)

# Write the XML document to a file
tree = ET.ElementTree(root)
tree.write('faker/output/application_log.xml', encoding='utf-8', xml_declaration=True)

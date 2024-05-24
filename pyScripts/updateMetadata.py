import json
import os

# Directory containing the JSON files
directory = "/Users/semi/dev/PxP404/FullMetadata"

# Prefix for the image property
image_prefix = "ipfs://bafybeigyncrefefs5kpdjrgnmitiwwunu5x7bfwxmycvvnqpmtdcavdxr4/"

# Iterate over each file in the directory
for filename in os.listdir(directory):
    if filename.endswith('.json'):
        file_path = os.path.join(directory, filename)
        # Extract the ID from the filename
        file_id = filename.split('.')[0]
        
        # Open and load the JSON file
        with open(file_path, 'r') as file:
            data = json.load(file)
        
        # Update the 'name' and 'image' properties
        data['name'] = file_id
        data['image'] = image_prefix + data['image']
        
        # Write the changes back to the file
        with open(file_path, 'w') as file:
            json.dump(data, file, indent=4)

print("Updated all JSON files in the directory.")

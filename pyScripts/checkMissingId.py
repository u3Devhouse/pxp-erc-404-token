import os

# Path to the directory containing the files
art_path = "/Users/semi/dev/PxP404/Meta"

# List all files in the directory
files = [f for f in os.listdir(art_path) if f.endswith('.json')]

# Create a set of all expected IDs
expected_ids = set(range(1, 30001))

# Create a set from the IDs we have in the files
found_ids = set(int(f.split('.')[0]) for f in files)

# Find missing IDs by comparing the sets
missing_ids = expected_ids - found_ids
duplicate_ids = set()

# Check for duplicates by finding any ID count greater than 1
id_counts = {}
for file_id in found_ids:
    if file_id in id_counts:
        duplicate_ids.add(file_id)
    id_counts[file_id] = id_counts.get(file_id, 0) + 1

# Output results
if missing_ids:
    print("Missing IDs:", sorted(missing_ids))
else:
    print("No IDs are missing.")

if duplicate_ids:
    print("Duplicate IDs:", sorted(duplicate_ids))
else:
    print("No duplicate IDs.")

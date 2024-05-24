import os
import random
import shutil

def shuffle_json_files(source_directory, target_directory):
    # List all .json files in the source directory
    json_files = [f for f in os.listdir(source_directory) if f.endswith('.json') and f.split('.')[0].isdigit()]
    
    # Generate a list of new random non-duplicate filenames in the same range
    total_files = len(json_files)
    new_filenames = random.sample(range(1, 30001), total_files)
    
    # Copy files with new names to the target directory
    for old_file, new_id in zip(json_files, new_filenames):
        old_file_path = os.path.join(source_directory, old_file)
        new_file_name = f"{new_id}.json"
        new_file_path = os.path.join(target_directory, new_file_name)
        shutil.copy(old_file_path, new_file_path)
    
    print(f"Shuffled {total_files} files from {source_directory} to {target_directory} with new random names.")

# Example usage
source_dir = "/Users/semi/dev/PxP404/Meta"
target_dir = "/Users/semi/dev/PxP404/FullMetadata"
shuffle_json_files(source_dir, target_dir)

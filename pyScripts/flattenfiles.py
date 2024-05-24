import os
import shutil

def lift_files_to_directory(source_directory, target_directory):
    # Walk through all subdirectories in the source directory
    for root, dirs, files in os.walk(source_directory):
        for file in files:
            # Construct the full file path
            file_path = os.path.join(root, file)
            # Construct the target file path
            target_file_path = os.path.join(target_directory, file)
            # Move the file to the target directory
            shutil.move(file_path, target_file_path)
    print(f"All files from {source_directory} have been moved to {target_directory}")

# Example usage
source_dir = "/Users/semi/dev/PxP404/Meta"
target_dir = "/Users/semi/dev/PxP404/Meta"
lift_files_to_directory(source_dir, target_dir)

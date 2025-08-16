import os

# Set your folder path here
folder_path = 'G:/All Music'

# Loop through all files in the folder
for filename in os.listdir(folder_path):
    if filename.startswith('[OST]'):
        new_name = filename[2:]  # Remove first 3 characters ('abc')
        old_path = os.path.join(folder_path, filename)
        new_path = os.path.join(folder_path, new_name)
        
        # Rename the file
        os.rename(old_path, new_path)
        print(f'Renamed: {filename} -> {new_name}')

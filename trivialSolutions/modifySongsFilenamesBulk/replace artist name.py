import os

# Configuration
folder_path = 'H:/All Music'
prefix_to_match = 'Sia - '      # What to match at the start
replace_with = ' - Sia'         # What to move to the end (you can set this to prefix_to_match to just move it)

# Process files
for filename in os.listdir(folder_path):
    file_path = os.path.join(folder_path, filename)

    # Only process files (not directories)
    if not os.path.isfile(file_path):
        continue

    name, ext = os.path.splitext(filename)

    # Rule: starts with specific prefix
    if name.startswith(prefix_to_match):
        new_name = name[len(prefix_to_match):] + replace_with + ext
        new_path = os.path.join(folder_path, new_name)

        os.rename(file_path, new_path)
        print(f'Renamed: {filename} -> {new_name}')

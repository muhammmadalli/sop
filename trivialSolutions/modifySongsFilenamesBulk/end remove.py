import os

# Set your folder path here
folder_path = 'H:/Motivational'

for filename in os.listdir(folder_path):
    file_path = os.path.join(folder_path, filename)

    # Skip if it's not a file
    if not os.path.isfile(file_path):
        continue

    # Split filename into name and extension
    name, ext = os.path.splitext(filename)

    # If the name ends with ' -  -  - 00', remove it
    if name.endswith(' -   -'):
        new_name = name[:-6] + ext  # Remove ' -   -' from the end
        new_path = os.path.join(folder_path, new_name)

        os.rename(file_path, new_path)
        print(f'Renamed: {filename} -> {new_name}')

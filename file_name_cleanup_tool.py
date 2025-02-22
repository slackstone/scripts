import os
import argparse

def clean_filenames(directory):
    """
    Removes single and double quotes from all filenames in the specified directory.
    
    Args:
        directory (str): Path to the directory containing files to be renamed.

    Returns:
        None
    """
    if not os.path.isdir(directory):
        print(f"Error: '{directory}' is not a valid directory.")
        return

    # Loop through files in the directory
    for filename in sorted(os.listdir(directory)):  # Sorted for consistent processing order
        old_path = os.path.join(directory, filename)

        # Ensure it's a file (not a directory)
        if not os.path.isfile(old_path):
            continue

        # Remove single and double quotes from the filename
        new_filename = filename.replace("'", "").replace('"', "")

        # If the filename has changed, rename it
        if new_filename != filename:
            new_path = os.path.join(directory, new_filename)
            
            try:
                os.rename(old_path, new_path)
                print(f'Renamed: "{filename}" -> "{new_filename}"')
            except Exception as e:
                print(f'Error renaming "{filename}": {e}')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Remove quotes from filenames in a specified directory.")
    parser.add_argument("directory", help="Path to the directory containing files to be renamed")
    
    args = parser.parse_args()
    clean_filenames(args.directory)

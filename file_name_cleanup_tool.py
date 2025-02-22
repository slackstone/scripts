import os
import argparse

def clean_filenames(directory):
    """
    Removes single and double quotes from filenames in the specified directory.
    
    Args:
        directory (str): Path to the directory containing files to be renamed.

    Returns:
        None
    """
    if not os.path.isdir(directory):
        print(f"Error: '{directory}' is not a valid directory.")
        return

    for filename in os.listdir(directory):
        # Remove single and double quotes from the filename
        new_filename = filename.replace("'", "").replace('"', "")
        
        if new_filename != filename:
            old_path = os.path.join(directory, filename)
            new_path = os.path.join(directory, new_filename)
            
            # Rename the file, handling potential errors
            try:
                os.rename(old_path, new_path)
                print(f'Renamed: {filename} -> {new_filename}')
            except Exception as e:
                print(f'Error renaming {filename}: {e}')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Remove quotes from filenames in a specified directory.")
    parser.add_argument("directory", help="Path to the directory containing files to be renamed")
    
    args = parser.parse_args()
    clean_filenames(args.directory)

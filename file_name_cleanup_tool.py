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

    print(f"\nScanning directory: {directory}\n")

    files_found = False  # Flag to check if we detect files at all
    files_renamed = False  # Flag to check if renaming is actually happening

    # Loop through files in the directory
    for filename in sorted(os.listdir(directory)):  # Sorted for consistency
        old_path = os.path.join(directory, filename)

        # Ensure it's a file (not a directory)
        if not os.path.isfile(old_path):
            continue

        files_found = True  # At least one file is detected

        # Print the file being checked
        print(f"Checking: {filename}")

        # Remove single and double quotes from the filename
        new_filename = filename.replace("'", "").replace('"', "")

        if new_filename != filename:
            print(f'  → Needs rename: "{filename}" → "{new_filename}"')
            new_path = os.path.join(directory, new_filename)

            try:
                os.rename(old_path, new_path)
                print(f'  ✅ Renamed successfully!\n')
                files_renamed = True
            except Exception as e:
                print(f'  ❌ Error renaming "{filename}": {e}\n')

    if not files_found:
        print("⚠️ No files detected in the directory.")
    elif not files_renamed:
        print("✔️ No filenames contained quotes. Nothing needed renaming.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Remove quotes from filenames in a specified directory.")
    parser.add_argument("directory", help="Path to the directory containing files to be renamed")
    
    args = parser.parse_args()
    clean_filenames(args.directory)

import os
import argparse
from PIL import Image
import PyPDF2


def print_exif_data(directory):
    # List all files in the given directory
    files = os.listdir(directory)
    for file_name in files:
        # Construct full file path
        file_path = os.path.join(directory, file_name)
        if file_path.lower().endswith((".png", ".jpg", ".jpeg", ".tif", ".tiff")):
            try:
                # Open the image file
                with Image.open(file_path) as img:
                    # Get EXIF data
                    exif_data = img._getexif()
                    # Print EXIF data if it exists
                    if exif_data:
                        print(f"EXIF Data for {file_name}:")
                        for tag_id, value in exif_data.items():
                            # Get the tag name, not just numerical ID
                            tag = Image.ExifTags.TAGS.get(tag_id, tag_id)
                            print(f"{tag}: {value}")
                    else:
                        print(f"No EXIF data available for {file_name}")
            except IOError:
                print(f"File {file_name} is not an image or cannot be opened.")
            except Exception as e:
                print(f"An error occurred with file {file_name}: {e}")
        elif file_path.lower().endswith(".pdf"):
            try:
                # Open the PDF file using the updated PdfReader class
                with open(file_path, "rb") as f:
                    pdf = PyPDF2.PdfReader(f)
                    metadata = pdf.document_info
                    # Print PDF metadata if it exists
                    if metadata:
                        print(f"Metadata for {file_name}:")
                        for key, value in metadata.items():
                            print(f"{key[1:]}: {value}")
                    else:
                        print(f"No metadata available for {file_name}")
            except Exception as e:
                print(f"An error occurred with file {file_name}: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Print EXIF data from all images and metadata from PDFs in a directory."
    )
    parser.add_argument(
        "directory", type=str, help="Directory containing image and PDF files."
    )
    args = parser.parse_args()
    print_exif_data(args.directory)


if __name__ == "__main__":
    main()

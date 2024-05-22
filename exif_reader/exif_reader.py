import os
import argparse
from PIL import Image
import PyPDF2


def handle_exif_data(file_path, action):
    try:
        with Image.open(file_path) as img:
            if action == "remove":
                img.save(
                    file_path, "JPEG", quality=95, exif=b""
                )  # Saving with empty EXIF data
                print(f"Removed EXIF data from {os.path.basename(file_path)}")
            else:
                exif_data = img._getexif()
                if exif_data:
                    print(f"EXIF Data for {os.path.basename(file_path)}:")
                    for tag_id, value in exif_data.items():
                        tag = Image.ExifTags.TAGS.get(tag_id, tag_id)
                        print(f"{tag}: {value}")
                else:
                    print(f"No EXIF data available for {os.path.basename(file_path)}")
    except IOError:
        print(
            f"File {os.path.basename(file_path)} is not an image or cannot be opened."
        )
    except Exception as e:
        print(f"An error occurred with {os.path.basename(file_path)}: {e}")


def handle_pdf_metadata(file_path, action):
    try:
        with open(file_path, "rb") as f:
            pdf_reader = PyPDF2.PdfReader(f)
            pdf_writer = PyPDF2.PdfWriter()
            for page in range(len(pdf_reader.pages)):
                pdf_writer.add_page(pdf_reader.pages[page])
            if action == "remove":
                with open(file_path, "wb") as output_pdf:
                    pdf_writer.write(output_pdf)
                print(f"Removed metadata from {os.path.basename(file_path)}")
            else:
                metadata = pdf_reader.metadata
                if metadata:
                    print(f"Metadata for {os.path.basename(file_path)}:")
                    for key, value in metadata.items():
                        print(f"{key[1:]}: {value}")
                else:
                    print(f"No metadata available for {os.path.basename(file_path)}")
    except Exception as e:
        print(f"An error occurred with {os.path.basename(file_path)}: {e}")


def print_or_remove_data(directory, action):
    files = os.listdir(directory)
    for file_name in files:
        file_path = os.path.join(directory, file_name)
        if file_path.lower().endswith((".png", ".jpg", ".jpeg", ".tif", ".tiff")):
            handle_exif_data(file_path, action)
        elif file_path.lower().endswith(".pdf"):
            handle_pdf_metadata(file_path, action)


def main():
    parser = argparse.ArgumentParser(
        description="Handle EXIF data from images and metadata from PDFs in a directory."
    )
    parser.add_argument(
        "directory", type=str, help="Directory containing image and PDF files."
    )
    parser.add_argument(
        "--remove", action="store_true", help="Remove metadata instead of displaying it"
    )
    args = parser.parse_args()
    action = "remove" if args.remove else "display"
    print_or_remove_data(args.directory, action)


if __name__ == "__main__":
    main()

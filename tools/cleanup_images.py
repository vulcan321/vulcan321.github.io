
import os
import re
import logging

def cleanup_unused_images(root_dir):
    """Removes images from the images directory that are not referenced in any Markdown files."""
    images_dir = os.path.join(root_dir, 'images')
    if not os.path.exists(images_dir):
        logging.info("Images directory does not exist. Nothing to clean up.")
        return

    # 1. Find all referenced images in Markdown files
    referenced_images = set()
    for subdir, _, files in os.walk(root_dir):
        if 'tools' in subdir:
            continue
        for file in files:
            if file.endswith('.md'):
                md_file_path = os.path.join(subdir, file)
                try:
                    with open(md_file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    # Find all image links in the content
                    links = re.findall(r'!\[.*?\]\((.*?)\)', content)
                    for link in links:
                        # Normalize the link path and resolve it relative to the md file
                        clean_link = link.split(' ')[0] # Handle titles in links
                        if not clean_link.startswith('http'):
                            # Resolve the absolute path of the referenced image
                            abs_path = os.path.abspath(os.path.join(os.path.dirname(md_file_path), clean_link))
                            referenced_images.add(abs_path)
                except Exception as e:
                    logging.error(f"Could not process file {md_file_path}: {e}")

    logging.info(f"Found {len(referenced_images)} referenced images in all Markdown files.")

    # 2. Get all actual image files from the images directory
    actual_images = set()
    for img_file in os.listdir(images_dir):
        actual_images.add(os.path.join(images_dir, img_file))

    logging.info(f"Found {len(actual_images)} total images in the '{os.path.basename(images_dir)}' directory.")

    # 3. Determine which images are unused and delete them
    unused_images = actual_images - referenced_images
    if not unused_images:
        logging.info("No unused images found. Cleanup not necessary.")
        return

    logging.info(f"Found {len(unused_images)} unused images to delete.")

    for image_path in unused_images:
        try:
            os.remove(image_path)
            logging.info(f"Deleted unused image: {image_path}")
        except OSError as e:
            logging.error(f"Error deleting file {image_path}: {e}")

if __name__ == "__main__":
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    log_file_path = os.path.join(project_root, 'tools', 'cleanup.log')

    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file_path, mode='w'),
            logging.StreamHandler()
        ]
    )

    cleanup_unused_images(project_root)
    print("Cleanup script finished.")

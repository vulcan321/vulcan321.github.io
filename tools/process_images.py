
import os
import re
import uuid
import requests
import logging
from urllib.parse import urlparse

PROCESSED_FILES_LOG = ''

def get_file_extension_from_url(url):
    """Extracts the file extension from a URL."""
    try:
        path = urlparse(url).path
        ext = os.path.splitext(path)[1]
        return ext
    except Exception:
        return None

def download_image(url, image_path):
    """Downloads an image from a URL and saves it to a given path."""
    try:
        response = requests.get(url, stream=True)
        response.raise_for_status()
        with open(image_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        return True
    except requests.exceptions.RequestException as e:
        logging.error(f"Error downloading {url}: {e}")
        return False

def load_processed_files():
    """Loads the set of already processed file paths."""
    if not os.path.exists(PROCESSED_FILES_LOG):
        return set()
    try:
        with open(PROCESSED_FILES_LOG, 'r', encoding='utf-8') as f:
            return set(line.strip() for line in f)
    except Exception as e:
        logging.error(f"Could not load processed files log: {e}")
        return set()

def log_processed_file(md_file_path):
    """Logs a file path as successfully processed."""
    try:
        with open(PROCESSED_FILES_LOG, 'a', encoding='utf-8') as f:
            f.write(md_file_path + '\n')
    except Exception as e:
        logging.error(f"Could not write to processed files log: {e}")

def process_markdown_files(root_dir):
    """
    Processes all Markdown files in a directory to download and relink images.
    """
    images_dir = os.path.join(root_dir, 'images')
    if not os.path.exists(images_dir):
        os.makedirs(images_dir)

    processed_files = load_processed_files()
    logging.info(f"Loaded {len(processed_files)} already processed files.")

    for subdir, _, files in os.walk(root_dir):
        if 'tools' in subdir or 'images' in subdir:
            continue
        for file in files:
            if file.endswith('.md'):
                md_file_path = os.path.join(subdir, file)
                if md_file_path in processed_files:
                    continue
                process_single_markdown(md_file_path, images_dir)

def process_single_markdown(md_file_path, images_dir):
    """Processes a single markdown file."""
    print(f"Processing {md_file_path}...")
    try:
        with open(md_file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        logging.error(f"Could not read {md_file_path}: {e}")
        return
    
    original_content = content
    image_links = re.findall(r'!\[(.*?)\]\((.*?)\)', content)
    
    remote_image_links = [
        (alt, url_with_title) 
        for alt, url_with_title in image_links 
        if url_with_title.split(' ')[0].startswith(('http://', 'https://'))
    ]

    if not remote_image_links:
        logging.info(f"No remote images in {md_file_path}. Marking as processed.")
        log_processed_file(md_file_path)
        return

    all_downloads_succeeded = True
    for alt_text, url_with_title in remote_image_links:
        url = url_with_title.split(' ')[0]
        ext = get_file_extension_from_url(url)
        if not ext:
            try:
                response = requests.head(url)
                content_type = response.headers.get('content-type')
                if content_type and '/' in content_type:
                    ext = '.' + content_type.split('/')[1].split(';')[0]
                else:
                    ext = '.jpg'
            except requests.exceptions.RequestException:
                ext = '.jpg'

        new_filename = f"{uuid.uuid4()}{ext}"
        image_path = os.path.join(images_dir, new_filename)

        if download_image(url, image_path):
            relative_path = os.path.relpath(image_path, os.path.dirname(md_file_path)).replace('\\', '/')
            new_link = f"![{alt_text}]({relative_path})"
            original_link_pattern = f"![{alt_text}]({url_with_title})"
            content = content.replace(original_link_pattern, new_link)
            logging.info(f"Replaced {url} with {relative_path} in {md_file_path}")
        else:
            all_downloads_succeeded = False
            logging.warning(f"Failed to download image from {url} in {md_file_path}. Kept original URL.")

    if content != original_content:
        try:
            with open(md_file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            if all_downloads_succeeded:
                log_processed_file(md_file_path)
        except Exception as e:
            logging.error(f"Could not write to {md_file_path}: {e}")

if __name__ == "__main__":
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    PROCESSED_FILES_LOG = os.path.join(project_root, 'tools', 'processed_files.log')
    log_file_path = os.path.join(project_root, 'tools', 'process_images.log')
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file_path, mode='a'),
            logging.StreamHandler()
        ]
    )

    process_markdown_files(project_root)
    print("Done.")

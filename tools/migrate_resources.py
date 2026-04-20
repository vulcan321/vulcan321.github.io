
import os
import re
import uuid
import shutil
import logging

def migrate_images_and_update_markdown(root_dir):
    """Migrates images from the old resource folder to the new images folder and updates Markdown links."""
    source_dir_base = os.path.join(root_dir, 'resource', 'photo')
    dest_dir = os.path.join(root_dir, 'images')

    if not os.path.exists(source_dir_base):
        logging.warning(f"Source directory {source_dir_base} does not exist. Nothing to migrate.")
        return

    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)

    for subdir, _, files in os.walk(root_dir):
        if 'tools' in subdir or 'images' in subdir or 'resource' in subdir:
            continue

        for file in files:
            if file.endswith('.md'):
                md_file_path = os.path.join(subdir, file)
                process_single_markdown_for_migration(md_file_path, source_dir_base, dest_dir)

    # After processing all files, remove the old directory if it's empty
    try:
        if os.path.exists(source_dir_base) and not os.listdir(source_dir_base):
            shutil.rmtree(os.path.join(root_dir, 'resource'))
            logging.info("Successfully removed the old 'resource' directory.")
    except OSError as e:
        logging.error(f"Error removing directory {source_dir_base}: {e}")

def process_single_markdown_for_migration(md_file_path, source_dir_base, dest_dir):
    """Processes a single Markdown file for image migration."""
    logging.info(f"Processing {md_file_path} for local image migration...")
    try:
        with open(md_file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        logging.error(f"Could not read {md_file_path}: {e}")
        return

    original_content = content
    image_links = re.findall(r'!\[(.*?)\]\((.*?)\)', content)

    for alt_text, old_link in image_links:
        # Check if the link points to the old resource directory
        if 'resource/photo' in old_link:
            image_name = os.path.basename(old_link)
            old_image_path = os.path.abspath(os.path.join(os.path.dirname(md_file_path), old_link))
            
            if os.path.exists(old_image_path):
                ext = os.path.splitext(image_name)[1]
                new_filename = f"{uuid.uuid4()}{ext}"
                new_image_path = os.path.join(dest_dir, new_filename)
                
                try:
                    shutil.move(old_image_path, new_image_path)
                    logging.info(f"Moved {old_image_path} to {new_image_path}")

                    # Update the link in the markdown file
                    relative_path = os.path.relpath(new_image_path, os.path.dirname(md_file_path)).replace('\\', '/')
                    new_link_markdown = f"![{alt_text}]({relative_path})"
                    original_link_markdown = f"![{alt_text}]({old_link})"
                    content = content.replace(original_link_markdown, new_link_markdown)
                    logging.info(f"  Updated link in {md_file_path} to {relative_path}")
                
                except Exception as e:
                    logging.error(f"Could not move {old_image_path}: {e}")
            else:
                logging.warning(f"Image not found at {old_image_path}, referenced in {md_file_path}")

    if content != original_content:
        try:
            with open(md_file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            logging.info(f"Successfully updated {md_file_path}")
        except Exception as e:
            logging.error(f"Could not write to {md_file_path}: {e}")

if __name__ == "__main__":
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    log_file_path = os.path.join(project_root, 'tools', 'migration.log')

    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file_path, mode='w'),
            logging.StreamHandler()
        ]
    )

    migrate_images_and_update_markdown(project_root)
    print("Migration script finished.")

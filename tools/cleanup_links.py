
import os
import re
import logging
from urllib.parse import unquote, urlparse, parse_qs

# --- Link Cleaning Rules ---
# A list of hostnames to remove. Links with these hostnames will be converted to plain text.
HOSTS_TO_REMOVE = [
    "baike.baidu.com",
    "so.csdn.net",
]

def clean_zhihu_link(url):
    """
    If the URL is a zhihu redirect link, extract and decode the target URL.
    e.g., https://link.zhihu.com/?target=http%3A//main.cc -> http://main.cc
    """
    try:
        parsed_url = urlparse(url)
        if parsed_url.hostname and "link.zhihu.com" in parsed_url.hostname:
            query_params = parse_qs(parsed_url.query)
            if 'target' in query_params:
                target_url = query_params['target'][0]
                return unquote(target_url)
    except Exception:
        # In case of a malformed URL that cannot be parsed
        pass
    return url # Return original url if not a zhihu link or if parsing fails

def process_markdown_file(md_file_path):
    """Cleans links in a single markdown file based on the defined rules."""
    logging.info(f"Processing file: {md_file_path}")
    try:
        with open(md_file_path, 'r', encoding='utf-8') as f:
            original_content = f.read()
    except Exception as e:
        logging.error(f"Could not read {md_file_path}: {e}")
        return

    content = original_content
    file_changed = False

    # Regex to find all markdown links: [text](url)
    link_pattern = re.compile(r"(\[([^\]]+)\]\(([^)]+)\))")

    # Use a temporary variable for replacements to handle multiple changes to the same line
    temp_content = content

    for match in link_pattern.finditer(original_content):
        original_markdown_link = match.group(1)
        link_text = match.group(2)
        url_part = match.group(3)

        # The URL part might contain a title, e.g., "http://example.com \"My Title\""
        url = url_part.split(' ')[0]
        
        # --- Apply Rule 1: Clean Zhihu links ---
        cleaned_url = clean_zhihu_link(url)
        current_link_markdown = original_markdown_link

        if cleaned_url != url:
            new_url_part = url_part.replace(url, cleaned_url)
            new_markdown_link = f"[{link_text}]({new_url_part})"
            temp_content = temp_content.replace(original_markdown_link, new_markdown_link)
            logging.info(f"  - Cleaned Zhihu link: '{original_markdown_link}' -> '{new_markdown_link}'")
            file_changed = True
            current_link_markdown = new_markdown_link # Use the updated link for the next rule
            url = cleaned_url # The URL has been updated

        # --- Apply Rule 2: Remove unwanted hosts ---
        try:
            parsed_url = urlparse(url)
            if parsed_url.hostname in HOSTS_TO_REMOVE:
                # Replace the whole markdown link with just its text
                temp_content = temp_content.replace(current_link_markdown, link_text)
                logging.info(f"  - Removed unwanted link: '{current_link_markdown}' -> '{link_text}'")
                file_changed = True
        except Exception as e:
            logging.warning(f"Could not parse URL '{url}' in file {md_file_path}: {e}")

    if file_changed:
        try:
            with open(md_file_path, 'w', encoding='utf-8') as f:
                f.write(temp_content)
            logging.info(f"File updated: {md_file_path}")
        except Exception as e:
            logging.error(f"Could not write to {md_file_path}: {e}")
    else:
        logging.info("No links to clean in this file.")

def main():
    """Main function to walk through the directory and process all markdown files."""
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    log_file_path = os.path.join(project_root, 'tools', 'link_cleanup.log')

    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file_path, mode='w'),
            logging.StreamHandler()
        ]
    )

    logging.info("Starting link cleanup process...")
    for subdir, _, files in os.walk(project_root):
        if 'tools' in subdir:
            continue
        for file in files:
            if file.endswith('.md'):
                process_markdown_file(os.path.join(subdir, file))

    print("Link cleanup script finished.")

if __name__ == "__main__":
    main()

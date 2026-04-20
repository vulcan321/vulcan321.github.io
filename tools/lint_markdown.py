
import os
import re
import logging

# --- Linting Rules ---
# Each rule is a tuple: (name, search_regex, replacement_function)
# The replacement_function takes a match object and returns the replacement string.

RULES = [
    (
        "Remove space between ! and [ for images",
        re.compile(r"!\s+\[(.*?)\]"),
        lambda m: f"![{m.group(1)}]"
    ),
    (
        "Remove space between ] and ( for links/images",
        re.compile(r"\]\s+\("),
        lambda m: "]("
    ),
    (
        "Add space after heading hashmarks",
        re.compile(r"(#{1,6})(\S)"),
        lambda m: f"{m.group(1)} {m.group(2)}"
    ),
    (
        "Normalize horizontal rules to ---",
        re.compile(r"^(\*{3,}|-{3,}|_{3,})$"),
        lambda m: "---"
    ),
    (
        "Normalize bold markers from __ to **",
        re.compile(r"__([^_]+?)__"),
        lambda m: f"**{m.group(1)}**"
    ),
    (
        "Normalize italic markers from _ to *",
        # Negative lookbehind/ahead to avoid matching bold markers
        re.compile(r"(?<!_)_([^_]+?)_(?!_)"),
        lambda m: f"*{m.group(1)}*"
    ),
]

def lint_markdown_file(md_file_path):
    """Lints a single markdown file and applies fixes."""
    logging.info(f"Processing file: {md_file_path}")
    try:
        with open(md_file_path, 'r', encoding='utf-8') as f:
            original_content = f.read()
    except Exception as e:
        logging.error(f"Could not read {md_file_path}: {e}")
        return

    content = original_content
    file_changed = False

    # Split content by lines to handle line-based rules carefully
    lines = content.split('\n')
    processed_lines = []
    in_front_matter = False
    front_matter_end_found = False

    if lines and lines[0] == '---':
        in_front_matter = True

    for i, line in enumerate(lines):
        # Skip front matter for rules that might conflict (like horizontal rule)
        if in_front_matter:
            if i > 0 and line == '---':
                in_front_matter = False
                front_matter_end_found = True
            processed_lines.append(line)
            continue

        temp_line = line
        for rule_name, regex, replacement_func in RULES:
            # Special handling for horizontal rule to avoid front matter
            if rule_name == "Normalize horizontal rules to ---" and front_matter_end_found and i < 2:
                 continue

            temp_line = regex.sub(replacement_func, temp_line)
        
        if temp_line != line:
            logging.info(f"  - Fix applied: '{line.strip()}' -> '{temp_line.strip()}'")
            file_changed = True

        processed_lines.append(temp_line)

    if file_changed:
        new_content = "\n".join(processed_lines)
        try:
            with open(md_file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            logging.info(f"File updated: {md_file_path}")
        except Exception as e:
            logging.error(f"Could not write to {md_file_path}: {e}")
    else:
        logging.info("No issues found.")

def main():
    """Main function to walk through the directory and process all markdown files."""
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    log_file_path = os.path.join(project_root, 'tools', 'lint.log')

    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file_path, mode='w'),
            logging.StreamHandler()
        ]
    )

    for subdir, _, files in os.walk(project_root):
        if 'tools' in subdir:
            continue
        for file in files:
            if file.endswith('.md'):
                lint_markdown_file(os.path.join(subdir, file))

    print("Linting script finished.")

if __name__ == "__main__":
    main()

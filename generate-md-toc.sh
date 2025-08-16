#!/bin/bash

README="README.md"
TOC_TMP="repo_structure.md"

# Generate Markdown TOC with links
generate_structure() {
  echo "## 📁 Repository Structure" > "$TOC_TMP"
  echo "" >> "$TOC_TMP"

  find . -type d ! -path './.*' | while read -r dir; do
    indent=$(echo "$dir" | grep -o "/" | wc -l)
    prefix=$(printf '  %.0s' $(seq 1 $indent))
    dir_name=$(basename "$dir")
    echo "${prefix}- 📁 $dir_name" >> "$TOC_TMP"

    find "$dir" -maxdepth 1 -type f ! -name ".*" | while read -r file; do
      file_indent=$(($indent + 1))
      file_prefix=$(printf '  %.0s' $(seq 1 $file_indent))
      file_name=$(basename "$file")
      file_path=$(echo "$file" | sed 's|^\./||')  # remove leading ./
      echo "${file_prefix}- 📄 [$file_name]($file_path)" >> "$TOC_TMP"
    done
  done
}

# Insert TOC into README.md
insert_toc() {
  awk -v toc="$(<"$TOC_TMP")" '
    BEGIN { print_mode=1 }
    /<!-- toc -->/ { print; print toc; print_mode=0; next }
    /<!-- tocstop -->/ { print_mode=1 }
    print_mode==1 { print }
    /<!-- tocstop -->/ { print }
  ' "$README" > "${README}.new"

  mv "${README}.new" "$README"
  rm "$TOC_TMP"
}

generate_structure
insert_toc

echo "✅ Clickable TOC inserted into $README"
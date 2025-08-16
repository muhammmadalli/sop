#!/bin/bash

# Output file
README="README.md"
TOC_TMP="repo_structure.md"

# Generate tree structure
generate_structure() {
  echo "## 📁 Repository Structure" > "$TOC_TMP"
  echo "" >> "$TOC_TMP"
  find . -type d ! -path './.*' | while read -r dir; do
    indent=$(echo "$dir" | grep -o "/" | wc -l)
    prefix=$(printf '  %.0s' $(seq 1 $indent))
    echo "${prefix}- 📁 $(basename "$dir")" >> "$TOC_TMP"
    find "$dir" -maxdepth 1 -type f ! -name ".*" | while read -r file; do
      file_indent=$(($indent + 1))
      file_prefix=$(printf '  %.0s' $(seq 1 $file_indent))
      echo "${file_prefix}- 📄 $(basename "$file")" >> "$TOC_TMP"
    done
  done
}

# Insert into README.md between <!-- toc --> and <!-- tocstop -->
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

echo "✅ TOC inserted into $README"
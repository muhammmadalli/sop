#!/bin/bash
set -euo pipefail

README="README.md"
TOC_TMP="repo_structure.md"

# Generate Markdown TOC with links
generate_structure() {
  echo "## 📁 Repository Structure" > "$TOC_TMP"
  echo "" >> "$TOC_TMP"

  find . -type d ! -path './.*' -print0 | while IFS= read -r -d '' dir; do
    indent=$(echo "$dir" | grep -o "/" | wc -l)
    prefix=$(printf '  %.0s' $(seq 1 $indent))
    dir_name=$(basename "$dir")
    echo "${prefix}- 📁 $dir_name" >> "$TOC_TMP"

    find "$dir" -maxdepth 1 -type f ! -name ".*" -print0 | while IFS= read -r -d '' file; do
      file_indent=$((indent + 1))
      file_prefix=$(printf '  %.0s' $(seq 1 $file_indent))
      file_name=$(basename "$file")
      file_path=$(echo "$file" | sed 's|^\./||')  # remove leading ./
      # Encode spaces as %20 for Markdown links
      file_link=$(echo "$file_path" | sed 's/ /%20/g')
      echo "${file_prefix}- 📄 [$file_name]($file_link)" >> "$TOC_TMP"
    done
  done
}

# Insert TOC into README.md
insert_toc() {
  awk -v toc_file="$TOC_TMP" '
    function insert_toc() {
      while ((getline line < toc_file) > 0) {
        print line
      }
      close(toc_file)
    }

    BEGIN { in_toc=0 }

    /<!-- toc -->/ {
      print
      insert_toc()
      in_toc=1
      next
    }

    /<!-- tocstop -->/ {
      in_toc=0
      print
      next
    }

    in_toc == 0 {
      print
    }
  ' "$README" > "${README}.new"

  mv "${README}.new" "$README"
  rm "$TOC_TMP"
}

generate_structure
insert_toc

echo "✅ Clickable TOC inserted into $README"

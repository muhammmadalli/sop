<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Table of Contents in md Files in Github Repo](#table-of-contents-in-md-files-in-github-repo)
  - [MD-Table of Contents Github MD file](#md-table-of-contents-github-md-file)
  - [Downlaod and Install Docker](#downlaod-and-install-docker)
  - [Node.js inside the node Container](#nodejs-inside-the-node-container)
  - [Recursive TOC Generator](#recursive-toc-generator)
- [For clickable links - in main Readme.md](#for-clickable-links---in-main-readmemd)
  - [Bash For clickable links - in main Readme.md](#bash-for-clickable-links---in-main-readmemd)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Table of Contents in md Files in Github Repo

## MD-Table of Contents Github MD file
https://github.com/jonschlinkert/markdown-toc

## Downlaod and Install Docker
https://docs.docker.com/desktop/setup/install/windows-install/

## Node.js inside the node Container
https://nodejs.org/en/download

```sh
# Docker has specific installation instructions for each operating system.
# Please refer to the official documentation at https://docker.com/get-started/
# Pull the Node.js Docker image:
docker pull node:22-alpine
# Create a Node.js container and start a Shell session:
docker run -it --rm -v "D:\programLearn\sop:/app/data" --entrypoint sh node:22-alpine
```

```sh
# Docker
# Verify the Node.js version:
node -v # Should print "v22.18.0".
# Verify npm version:
npm -v # Should print "10.9.3".
ls /app/data/
# Dev Projects      LTE Knowledge Bytes  networking           windows
# IPX             Linux SOP            trivialSolutions
# LICENSE            README.md            vmWare
cd /app/data/
npm install -g npm@11.5.2
npm fund
```
## Recursive TOC Generator
- Scans all Markdown files in your repo, including subfolders.
- Inserts TOCs at the top of each file.
- CLI usage:

```sh
# Docker
npm install -g doctoc
npm fund
doctoc .
```

# For clickable links - in main Readme.md

```sh
# Docker
# for making a .txt file with complete folder structure
tree /F > structure.txt

# for clickable links of all file
npm install -g markdown-toc
npm fund

markdown-toc -i README.md
```
## Bash For clickable links - in main Readme.md

```sh
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
cat "$TOC_TMP"  # Add this line
insert_toc

echo "✅ Clickable TOC inserted into $README"
```

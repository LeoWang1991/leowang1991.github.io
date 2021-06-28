#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
hugo --gc --minify # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

git init
git remote add origin git@github.com:LeoWang1991/leowang1991.github.io.git

echo 'wangjx.site' > CNAME

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push -f origin master

# rm -rf .git

cd ..
rm -rf public

cd content
git add .
git commit -m "update content - $(date)"
# git init
# git remote add origin git@github.com:LeoWang1991/hugoContent.git
git push origin master
# rm -rf .git
cd ..


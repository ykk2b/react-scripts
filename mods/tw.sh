#!/bin/bash

FILE_PATH=$1

if [ -z $FILE_PATH ]; then
  echo "please provide the path to the entry css file"
  exit 1
fi

if [ ! -f $FILE_PATH ]; then
  echo "css entry file not found"
  echo "creating a new css entry file"
  touch $FILE_PATH
  exit 1
fi

tailwind_config='/** @type {import("tailwindcss").Config} */
  export default {
  content: ["./src/**/*.{html,js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}'

echo "$tailwind_config" > tailwind.config.js

FILE_CONTENT=$(cat $FILE_PATH)

tailwind_header='@tailwind base;
@tailwind components;
@tailwind utilities;'

> $FILE_PATH
echo "$tailwind_header $FILE_CONTENT" > $FILE_PATH

if command -v pnpm >/dev/null 2>&1; then
    package_manager="pnpm"
    install_command="pnpm install"
elif command -v yarn >/dev/null 2>&1; then
    package_manager="yarn"
    install_command="yarn add"
elif command -v npm >/dev/null 2>&1; then
    package_manager="npm"
    install_command="npm install"
else
    package_manager="none"
    install_command="echo 'No JavaScript package manager found.'"
    exit 1
fi

$install_command tailwindcss postcss autoprefixer
#!/bin/bash

NAME=$1

if [ -z "$NAME" ]; then
  echo "please provide a name for the project"
  exit 1
fi

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

echo "detected package manager: $package_manager"
echo "starting project initialization..."

if [ -d "$NAME" ]; then
    echo "failed to initialize project: dir '$NAME' already exists."
    exit 1
fi
mkdir "$NAME"
cd "$NAME"

package_json='{
  "name": "'$NAME'",
  "version": "1.0.0",
  "description": "",
  "scripts": {
    "start": "parcel serve index.html",
    "build": "parcel build index.html"
  },
  "keywords": [],
  "author": "",
  "license": "MIT",
  "dependencies": {}
}'

echo "$package_json" > package.json

dependencies=(
  "react"
  "react-dom"
  "react-router-dom"
)

dev_dependencies=(
  "@types/react"
  "@types/react-dom"
  "@types/react-router-dom"
  "parcel"
  "postcss"
  "process"
  "tailwindcss"
  "typescript"
)

echo "installing dependencies..."

$install_command ${dependencies[@]}
$install_command -D ${dev_dependencies[@]}

echo "dependencies installed."

tailwind_config='
 /** @type {import("tailwindcss").Config} */
  export default {
  content: ["./src/**/*.tsx", "./index.tsx", "./index.html"],
  theme: {
    extend: {},
  },
  plugins: [],
}'

echo "$tailwind_config" > tailwind.config.js

tailwind_header='@tailwind base;
@tailwind components;
@tailwind utilities;'

mkdir src
mkdir src/styles
echo "$tailwind_header" > src/styles/index.css

postcss_config='{
  "plugins": {
    "tailwindcss": {}
  }
}'
echo "$postcss_config" > .postcssrc

echo "initialized tailwindcss"

index_html='
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="title" content="'$NAME'" />
        <meta name="description" content="'$NAME' description" />
        <meta
            name="keywords"
            content=""
        />
        <meta name="robots" content="index, follow" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="language" content="English" />
        <meta name="author" content="" />
        <title>'$NAME'</title>
    </head>
    <body>
        <div id="root"></div>
    </body>
    <script src="index.tsx" type="module"></script>
</html>
'
echo "$index_html" > index.html

index_tsx='import React from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import "./src/styles/index.css";
import Home from "./src/pages/index";

createRoot(document.getElementById("root")!).render(
<React.StrictMode>
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Home />} />
    </Routes>
  </BrowserRouter>
</React.StrictMode>
);
'

echo "$index_tsx" > index.tsx

home_tsx='import React from "react";

export default function Home() {
  return <div>Hello, World!</div>;
}
'

mkdir src/pages
echo "$home_tsx" > src/pages/index.tsx

git_ignore='
.parcel-cache
node_modules'

echo "$git_ignore" > .gitignore

echo "project initialized."

# Project Scaffolding Cheatsheet

Quick commands to spin up a **framework-based project** for every language this
Neovim config supports. Each scaffold creates the right *root marker*
(`package.json`, `pom.xml`, `composer.json`, `Cargo.toml`, `go.mod`, `.csproj`,
`pubspec.yaml`, `CMakeLists.txt`, a venv, ...) so the matching LSP attaches
automatically when you open the project in `nvim`.

> After creating a project, open it from its root (`cd project && nvim .`) so the
> language server can find the root marker. Check attachment with
> `:lua =vim.lsp.get_clients({ bufnr = 0 })`.

---

## Table of contents

- [Python — FastAPI / Django / Flask](#python)
- [Java — Spring Boot](#java--spring-boot)
- [C# — .NET](#c--net)
- [PHP — Laravel](#php--laravel)
- [JavaScript / TypeScript — React / Next / Express / Nest](#javascript--typescript)
- [Rust — Cargo / Axum](#rust)
- [Go — modules / Gin](#go)
- [Dart — Flutter](#dart--flutter)
- [C / C++ — CMake](#c--c-cmake)
- [Extras (SQL, Docker)](#extras)

---

## Python

LSP: `pyright` + `ruff` · Formatter: `black`

**Always create a venv first** — pyright resolves imports against it, so this is
what makes third-party completion work.

```bash
mkdir myapp && cd myapp
python -m venv .venv
source .venv/bin/activate
```

**FastAPI**

```bash
pip install "fastapi[standard]"
cat > main.py <<'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"hello": "world"}
EOF
fastapi dev main.py        # http://127.0.0.1:8000  (docs at /docs)
```

**Django**

```bash
pip install django
django-admin startproject mysite .
python manage.py runserver # http://127.0.0.1:8000
```

**Flask**

```bash
pip install flask
cat > app.py <<'EOF'
from flask import Flask

app = Flask(__name__)

@app.get("/")
def index():
    return "Hello, Flask!"
EOF
flask run                  # http://127.0.0.1:5000
```

---

## Java — Spring Boot

LSP: `jdtls` (+ `spring-boot.nvim`) · Formatter: `google-java-format`

No system Maven needed — the generated project bundles the `mvnw` wrapper.

```bash
curl -s https://start.spring.io/starter.zip \
  -d type=maven-project -d language=java -d javaVersion=21 \
  -d dependencies=web,data-jpa,postgresql \
  -d name=demo -d packageName=com.example.demo \
  -o demo.zip
unzip demo.zip -d demo && cd demo
./mvnw spring-boot:run     # http://localhost:8080
```

- Swap `-d dependencies=...` for what you need (e.g. `web`, `security`, `data-jpa`,
  `postgresql`, `lombok`, `validation`).
- Spring key completion works in `src/main/resources/application.properties`.

---

## C# — .NET

LSP: `roslyn` · Formatter: `csharpier`

```bash
dotnet new console  -o MyApp      # console app
dotnet new webapi   -o MyApi      # REST API (minimal)
dotnet new mvc      -o MyWeb      # MVC web app
dotnet new blazor   -o MyBlazor   # Blazor web app
```

```bash
cd MyApi
dotnet run                        # serves the API
```

> Roslyn attaches on the folder's `.csproj`/`.sln`. For multi-project solutions:
> `dotnet new sln && dotnet sln add MyApi/MyApi.csproj`.

---

## PHP — Laravel

LSP: `intelephense` · Formatters: `pint` (PHP), `blade-formatter` (Blade)

Requires system `php` + `composer`.

```bash
composer create-project laravel/laravel example-app
cd example-app
php artisan serve                 # http://127.0.0.1:8000
```

- Laravel ships its own `./vendor/bin/pint`, which `conform` uses automatically.
- Blade views live in `resources/views/*.blade.php`.
- Plain PHP (no framework): just `mkdir app && cd app && composer init`.

---

## JavaScript / TypeScript

LSP: `ts_ls`, `eslint`, `tailwindcss` · Formatter: `prettier`

**React (Vite)**

```bash
npm create vite@latest my-app -- --template react-ts
cd my-app && npm install
npm run dev                       # http://localhost:5173
```

**Next.js**

```bash
npx create-next-app@latest my-app # follow the prompts
cd my-app && npm run dev          # http://localhost:3000
```

**Express (Node API)**

```bash
mkdir api && cd api && npm init -y
npm install express
npm pkg set type=module
cat > index.js <<'EOF'
import express from "express";
const app = express();
app.get("/", (req, res) => res.send("Hello, Express!"));
app.listen(3000, () => console.log("http://localhost:3000"));
EOF
node index.js
```

**NestJS**

```bash
npm i -g @nestjs/cli
nest new project-name
cd project-name && npm run start:dev
```

---

## Rust

LSP: `rust_analyzer` · Formatter: `rustfmt`

```bash
cargo new my_app                  # binary crate
cargo new my_lib --lib            # library crate
cd my_app && cargo run
```

**Axum web server**

```bash
cargo new my_api && cd my_api
cargo add axum
cargo add tokio --features full
```

```rust
// src/main.rs
use axum::{routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(|| async { "Hello, Axum!" }));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

```bash
cargo run                         # http://localhost:3000
```

---

## Go

LSP: `gopls` · Formatter: `gofmt`

```bash
mkdir myapp && cd myapp
go mod init example.com/myapp
cat > main.go <<'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, Go!")
}
EOF
go run .
```

**Gin web framework**

```bash
go get github.com/gin-gonic/gin
```

```go
// main.go
package main

import "github.com/gin-gonic/gin"

func main() {
    r := gin.Default()
    r.GET("/", func(c *gin.Context) { c.String(200, "Hello, Gin!") })
    r.Run() // http://localhost:8080
}
```

---

## Dart — Flutter

LSP: `dartls` (via `flutter-tools.nvim`)

```bash
flutter create my_app
cd my_app
flutter run                       # pick a device/emulator
```

---

## C / C++ — CMake

LSP: `clangd` · Formatter: `clang-format`

clangd works best with a `compile_commands.json`. CMake can generate one.

```bash
mkdir myapp && cd myapp
cat > main.cpp <<'EOF'
#include <iostream>

int main() {
    std::cout << "Hello, C++!\n";
    return 0;
}
EOF
cat > CMakeLists.txt <<'EOF'
cmake_minimum_required(VERSION 3.16)
project(myapp CXX)
set(CMAKE_CXX_STANDARD 17)
add_executable(myapp main.cpp)
EOF

# -DCMAKE_EXPORT_COMPILE_COMMANDS=ON makes clangd fully understand the project
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json .   # so clangd finds it at the root
cmake --build build
./build/myapp
```

> Single-file quick test without CMake: drop a `compile_flags.txt` next to the file
> containing `-std=c++17` so clangd stops flagging valid C++17.

---

## Extras

**SQL / Postgres** (LSP: `sqls`, `postgres_lsp`)

`sqls` gives schema-aware completion once connected to a DB. Add
`~/.config/sqls/config.yml`:

```yaml
connections:
  - alias: local_pg
    driver: postgresql
    dataSourceName: host=127.0.0.1 port=5432 user=postgres password=postgres dbname=mydb sslmode=disable
```

**Docker** (LSP: `dockerls`, `yamlls`)

```bash
cat > Dockerfile <<'EOF'
FROM alpine:latest
CMD ["echo", "Hello, Docker!"]
EOF
docker build -t myimage .
docker run --rm myimage
```

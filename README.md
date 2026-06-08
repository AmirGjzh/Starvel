# Laravel Portable Development Environment

A portable Laravel development environment for Windows.
This repository contains the launcher, helper scripts, and wrappers needed to run Laravel tools without installing them system-wide.

> The runtime binaries are not included. Users must download PHP, Node.js, Composer, Mailpit, and MySQL themselves.

## 🚀 Why this repo exists

- Keep all development tools inside `Laravel/`
- Avoid system-wide installations and PATH changes
- Support multiple PHP and Node versions side-by-side
- Store caches and global Composer files inside the environment
- Preserve portability for cloning on another machine

## 📦 What is included

- `starvel.bat` — main launcher
- `scripts/Start-Laravel.ps1` — environment initialization
- `scripts/MySQL.ps1`, `scripts/Mailpit.ps1` — service helpers
- `bin/*.bat` — wrappers for PHP, Composer, Node, NPM, NPX, MySQL, Mailpit

## ❌ What is intentionally excluded

This repo does not include:

- PHP ZIP packages
- Node.js ZIP archives
- `composer.phar`
- `mailpit.exe`
- MySQL ZIP archive and binaries
- Laravel installer package files

Those files are large, version-specific, and must be downloaded by each user.

## ⚡ Quick start

1. Clone the repository.

2. Download and prepare the required tools.

3. Run:

    ```powershell
    starvel
    ```

4. Choose `Configure` to select PHP and Node versions.

5. Choose `Start coding` to validate the environment.

## 🛠️ Setup guide

### 1. Add PHP

1. Download a Windows PHP ZIP package from https://www.php.net.
2. Extract it to `tools\php\{version}`:

    - `tools\php\8.4`
    - `tools\php\8.5`

3. Copy `php.ini-development` to `php.ini` inside the new version folder.
4. Update `php.ini` so it contains at least:

    ```ini
    extension_dir = "ext"
    display_errors = On
    error_reporting = E_ALL
    memory_limit = 256M
    upload_max_filesize = 64M
    post_max_size = 64M
    max_execution_time = 60

    zend_extension=opcache
    opcache.enable=1
    opcache.enable_cli=1
    opcache.memory_consumption=128
    opcache.max_accelerated_files=20000
    opcache.validate_timestamps=1
    opcache.revalidate_freq=2

    extension=gd
    extension=dom
    extension=pdo
    extension=zip
    extension=xml
    extension=curl
    extension=exif
    extension=intl
    extension=ctype
    extension=bcmath
    extension=sodium
    extension=openssl
    extension=sockets
    extension=sqlite3
    extension=fileinfo
    extension=mbstring
    extension=pdo_mysql
    extension=tokenizer
    extension=pdo_sqlite
    ```

5. Add additional versions by creating another folder, e.g. `tools\php\8.6`.

### How to update PHP

- To update PHP, download the new ZIP package and extract it to a new folder under `tools\php`, for example `tools\php\8.5`.
- To remove an old version, delete its folder from `tools\php`.
- The launcher automatically detects available versions and can switch to the latest one on `Configure`.

### 2. Add Node.js

1. Download a Node.js ZIP archive from https://nodejs.org.
2. Extract it to `tools\node\{major}`:

    - `tools\node\24`
    - `tools\node\25`

3. Add more versions by creating new folders, e.g. `tools\node\26`.

### How to update Node.js

- To update Node.js, download the new ZIP archive and extract it into a new folder under `tools\node`, for example `tools\node\26`.
- To remove an old version, delete its folder from `tools\node`.
- The launcher will detect available versions and allow selecting the active one.

### 3. Add Composer

1. Download `composer.phar` from https://getcomposer.org.
2. Place it in `tools\composer\composer.phar`.

After launching the environment, install the Laravel installer:

```powershell
composer global require laravel/installer
```

### How to update Composer & global packages

- Update Composer itself with:

    ```powershell
    composer self-update
    ```

- Update globally installed Composer packages with:

    ```powershell
    composer global update
    ```

### 4. Add MySQL

1. Download the MySQL ZIP archive from https://dev.mysql.com.
2. Extract it to `tools\database\mysql`.

3. Initialize MySQL:

    ```powershell
    tools\database\mysql\bin\mysqld --initialize-insecure --console
    tools\database\mysql\bin\mysqld --console
    tools\database\mysql\bin\mysql_secure_installation
    ```

4. Create `tools\database\mysql\my.ini` with:

    ```ini
    [client]
    port=3306

    [mysqld]
    port=3306
    general-log = 1
    bind-address = 127.0.0.1
    ```

If another MySQL service already uses `3306`, change the port in `my.ini`.

### MySQL usage

Use the `mysql` wrapper to manage the local MySQL process:

```powershell
mysql start
mysql stop
mysql status
```

### 5. Add Mailpit

1. Download `mailpit.exe` from https://github.com/axllent/mailpit.
2. Place it in `tools\mailpit\mailpit.exe`.

### How to update Mailpit

- Replace `tools\mailpit\mailpit.exe` with the newer executable.
- The launcher uses the executable from that fixed path.

### Mailpit usage

Use the `mailpit` wrapper to manage the local Mailpit process:

```powershell
mailpit start
mailpit stop
mailpit status
```

## ✅ Using the environment

Run `starvel` and choose:

- `Configure` to select the active PHP and Node versions
- `Start coding` to load the environment and confirm tool availability

Once loaded, the following wrapper commands are available:

- `php`
- `composer`
- `laravel`
- `node`
- `npm`
- `npx`
- `mysql`
- `mailpit`

Example:

```powershell
composer --version
php --version
node --version
mailpit start
mysql start
```

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome.

If you find an issue or have an idea for improvement, feel free to open an issue or submit a pull request.

## 📜 License

This project is licensed under the MIT License.

# 🐘 Laravel Portable Dev Environment

A self-contained Laravel setup for Windows — everything lives inside one folder, nothing gets installed system-wide.

> Heads up: the actual runtime binaries (PHP, Node, Composer, MySQL, Mailpit) aren't included in this repo. You'll need to grab those yourself — instructions below.

---

## ✨ Features

- Every tool lives inside `Laravel/` — no system-wide installs, no messing with your PATH
- Run multiple PHP and Node versions side by side
- Caches and global Composer packages stay inside the environment
- Clone it on another machine and it just works the same way

## 📁 What's Inside

**Included**
- `starvel.bat` — the main launcher
- `scripts/Start-Laravel.ps1` — sets up the environment
- `scripts/MySQL.ps1`, `scripts/Mailpit.ps1` — service helpers
- `bin/*.bat` — wrappers for PHP, Composer, Node, NPM, NPX, MySQL, Mailpit

**Not included** (download these yourself — see setup guide below)
- PHP ZIP packages
- Node.js ZIP archives
- `composer.phar`
- `mailpit.exe`
- MySQL ZIP archive and binaries
- Laravel installer package files

These are big, version-specific files, so it made more sense to have each person grab their own instead of bloating the repo.

## 🚀 Getting Started

1. Clone the repo.
2. Download and set up the tools below (PHP, Node, Composer, MySQL, Mailpit).
3. Run `starvel`.
4. Pick **Configure** to choose your PHP and Node versions.
5. Pick **Start coding** to load everything and confirm it's working.

### Setting up the tools

**PHP**

1. Grab a Windows PHP ZIP from [php.net](https://www.php.net).
2. Extract it to `tools\php\{version}`, e.g. `tools\php\8.4` or `tools\php\8.5`.
3. Copy `php.ini-development` to `php.ini` inside that folder.
4. Make sure `php.ini` includes at least:

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

5. Want another version? Just add another folder, e.g. `tools\php\8.6`.

*To update:* download the new ZIP and extract it into a new version folder. To remove an old version, just delete its folder — the launcher picks up whatever's available under `tools\php` automatically.

**Node.js**

1. Grab a Node.js ZIP from [nodejs.org](https://nodejs.org).
2. Extract it to `tools\node\{major}`, e.g. `tools\node\24` or `tools\node\25`.
3. Add more versions the same way, e.g. `tools\node\26`.

*To update:* same idea — new ZIP, new folder under `tools\node`, delete the old one when you don't need it anymore.

**Composer**

1. Download `composer.phar` from [getcomposer.org](https://getcomposer.org).
2. Put it in `tools\composer\composer.phar`.
3. Once the environment is running, install the Laravel installer:

```bash
composer global require laravel/installer
```

*To update Composer itself:*

```bash
composer self-update
```

*To update your global packages:*

```bash
composer global update
```

**MySQL**

1. Download the MySQL ZIP from [dev.mysql.com](https://dev.mysql.com).
2. Extract it to `tools\database\mysql`.
3. Initialize it:

```bash
tools\database\mysql\bin\mysqld --initialize-insecure --console
tools\database\mysql\bin\mysqld --console
tools\database\mysql\bin\mysql_secure_installation
```

4. Create `tools\database\mysql\my.ini`:

```ini
[client]
port=3306

[mysqld]
port=3306
general-log = 1
bind-address = 127.0.0.1
```

If port 3306 is already taken by another MySQL install, just change it here.

*Managing it:*

```bash
mysql start
mysql stop
mysql status
```

**Mailpit**

1. Download `mailpit.exe` from [github.com/axllent/mailpit](https://github.com/axllent/mailpit).
2. Put it in `tools\mailpit\mailpit.exe`.

*To update:* just swap in the newer `mailpit.exe` — the launcher always uses whatever's at that path.

*Managing it:*

```bash
mailpit start
mailpit stop
mailpit status
```

## ▶️ Usage

Run `starvel` and pick:
- **Configure** — choose your active PHP and Node versions
- **Start coding** — load the environment and confirm everything's available

Once it's loaded, these wrapper commands are ready to use:

`php`, `composer`, `laravel`, `node`, `npm`, `npx`, `mysql`, `mailpit`

```bash
composer --version
php --version
node --version
mailpit start
mysql start
```

## 👤 Author

Made with ❤️ by [AmirMohammad Ganjizade](https://github.com/AmirGjzh)

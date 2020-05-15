# Yeebo Phoenix

Recreate the most recent version of Yeebo on your current machine

## Getting Started

To get started, simply clone this repository to your local machine. It will be the working folder for your Yeebo development.

### Prerequisites

You will need the following software packages

 - Docker
 - DDEV
 - jq
 - Make
 - curl
 - ssh/scp

Your computer should also be setup so that `ssh ec2-user@yeebo.org` logs you into the Yeebo server without prompting for a password.

### Installing OpenSocial / Drupal

The `composer.lock` and `composer.json` in this repo should be identical to those on the server (and they will be synchronised as part of this process). Running

```
make
```

on a fresh checkout will give you a fresh Drupal installation running on your local machine, probably at the address https://yeebo-phoenix.ddev.site . If you have problems with the HTTPS setup, make sure you have followed the DDEV installation instructions fully (https://ddev.readthedocs.io/en/stable/#installation - see references to `mkcert -install`).

Running `make` may start `ddev`. If you run into errors from `ddev`, try a `ddev stop && ddev start` after you have run `make`.

### Restoring the latest Yeebo backup

To make the installed site identical to the server installation, run

```
./sync-from-latest-backup.sh
```

This will copy the user files (from `files` and `private` on the server), the vendored libraries `vendor`, and the latest `composer.json` and `composer.lock` to your machine, as well as restoring the database snapshot to your local mysql.

You may need to run `ddev stop && ddev start` again to apply the latest changes. It also makes sense to run `ddev exec drush cr` to reset the caches.

## Cleaning up

You can stop `ddev` by running `ddev stop`. If you want to blow away the site completely, run `ddev delete && make clean` to restore the directory to its initial condition.

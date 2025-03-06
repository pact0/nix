---
title: Nix Introduction
author: pact0
pubDatetime: 2022-03-25T16:55:12.000+00:00
slug: nix-introduction
featured: false
draft: false
tags:
  - nix
  - guide
description: "Get rid of all your dependency problems using nix as a package manager."
---

## Table of contents

## What is nix?

- [Nix](#nix) - functional programming language
- [Nix](#nix-package-manager) - purely functional package manager
- [NixOS](#nixos) - purely functional package manager
- [Home Manager](#home-manager) - user environment manager

### Nix

To start things simple nix is a purely functional lazily evaluated and dynamically typed programming language. Its syntax is quite similar to `json`. It is mainly designed to create `derivations`.

```nix
{
  string = "hello";
  integer = 1;
  float = 3.141;
  bool = true;
  null = null;
  list = [ 1 "two" false ];
  attribute-set = {
    a = "hello";
    b = 2;
    c = 2.718;
    d = false;
  }; # comments are supported
}
```

[Read More...](./index.md)

### Nix Package Manager

Nix is a purely functional package manager that ensures reproducible and reliable builds by using declarative package definitions and isolated environments.
It allows multiple versions of packages to coexist without conflicts and supports atomic upgrades and rollbacks.

### NixOS

## Simple dev environment

## Benefits

- Declarative
- Immutable
- Reproducible
- Unbreakable

No need to remember specific commands which you had to manually run to enable a service or install a package; once you set up your environment in nix you are always guaranteed the same result.

Automatically stores backups of all versions of systems which were successfully built after the switch command which can be picked from in the grub boot menu. You will never get locked out of your broken machine, since you can choose previous system configuration on boot.

## Ubuntu vs NixOS

```shell
sudo apt install gcc
sudo apt install service

sudo systemctl start some-service.service
sudo systemctl enable some-service.service

sudo apt uninstall package2
```

vs the declarative way

```nix
{
  services.some-service.enable = true;
  environment.systemPackages = with pkgs; [
    package1
  ]
}
```

## Combination with [direnv](https://direnv.net/) for perfect dev env

[Direnv](https://direnv.net/) is a shell extension that loads and unloads environment variables based on the current directory, enabling per-project isolated environments.
It works by detecting `.envrc` files, executing them in a sub-shell, and exporting the resulting variables to the current shell.

## Installing NixOS remotely

## Installing on machines with terraform

## Disko setup

## Creating docker containers with nix

[link](https://github.com/nlewo/nix2container)

## Useful links

- [NixOS](https://nixos.org/)
- [Flakes](https://nixos.wiki/wiki/Flakes)
- [Available Packages](https://search.nixos.org/packages)
- [direnv](https://direnv.net/)
- [nix2container](https://github.com/nlewo/nix2container)
- [home-manager](https://github.com/nix-community/home-manager)
- [nixhub](https://www.nixhub.io/packages/)

```markdown
- my-blog/
  - index.md
  - about.md
  - posts/
    - first-post.md
    - second-post.md
    - images/
      - image1.jpg
      - image2.png
  - assets/
    - css/
    - js/
```

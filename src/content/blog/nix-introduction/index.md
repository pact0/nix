---
title: Nix Introduction
author: pact0
pubDatetime: 2025-03-14T12:55:12.000+00:00
slug: nix-introduction
featured: false
draft: false
tags:
  - nix
  - guide
description: "Get rid of all your dependency problems using nix as a package manager."
---

## Table of contents

## How did I get there?

I was too tired of my Arch Linux machine breaking whenever I had to updae my system. I was also too scared to ever redeploy any of my self hosted services because I was not certain that no other setup than spinning up the docker container was required. Nix solved all of these issues for me and introduced new quality of life features as well.

## History of nix

- 2003: First Nix commit by `Eelco Dolstra`, the inventor
- 2004: First papers on Nix
- 2006: The Nix [PhD thesis](https://edolstra.github.io/pubs/phd-thesis.pdf)
- 2006: `NixOS` by Armijn Hemel
- 2021: Nix0S 21.05
  - 1745 Contributors, 292,223 Commits
- 2022 (December): Nix0S 22.11
  - 4758 Contributors, 428,836 Commits
- 2025 (Now):
  - 5000+ Contributors, 765,994 Commits

## What is nix?

* A 20~MB Program written in C++
* Infrastructure as Code
* Reproducibility

- [Nix](#nix) - functional programming language
- [Nix](#nix-package-manager) - purely functional package manager
- [NixOS](#nixos) - purely functional operating system

## Nix

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

[Read More...](https://nix.dev/tutorials/nix-language.html)

## Nix Package Manager

### Nixpkgs
The building block of the package manager is `nixpkgs` - a repo on github, a collection of recipes for packages, automated to oblivion.

 This is a comparison of common package repositories for other package managers. We can see here that nix is the leader here by far. Nix has multiple versions of the `nixpkgs` - stable releases which move slower and unstable releases which move really fast.
![Image](./map_repo_size_fresh.svg)
[_source_](https://repology.org/repositories/graphs)

### Package manager
Nix is a purely functional package manager that ensures reproducible and reliable builds by using declarative package definitions and isolated environments.
It allows multiple versions of packages to coexist without conflicts and supports atomic upgrades and rollbacks.

### How it works?

Nix stores packages in the Nix store, usually the directory /nix/store, where each package has its own unique subdirectory such as `/nix/store/b6gvzjyb2pg0kjfwrjmg1vfhh54ad73z-firefox-33.1/`
where `b6gvzjyb2pg0kjfwrjmg1vfhh54ad73z` is a unique identifier for the package that captures all its dependencies (it’s a cryptographic hash of the package’s build dependency graph). This enables many powerful features.

## NixOS

Built from the Nix language, package manager and Nixpkgs collection.

The result of running Nix Build on Nix code you have written.

Completely declarative (like ansible or chef want to be).

After installing the mnimial nixos image iso we are given a fully functioning and reproducible system. This is how the minimal default configuration looks like. By default it is `/etc/nixos/configuration.nix`

```nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pacto = {
    isNormalUser = true;
    description = "pacto";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "pacto";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #wget
    #git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

We can see that all the system features are declaratively specified, the language, boot configuration, users and system wide available packages.

## Temporary (ephemeral/transient) environment - nix shell

Nix offers ephemeral shells which allow us to try out new packages or temporarily populate our shell with necessary dependencies.

Let's imagine a scenario where we just installed our new OS and we need to edit some files. We obviously want to use vim which is not installed by default.
```shell
vim
# The program 'vim' is not in your PATH
```

For this task we can quickly run

```shell
nix-shell -p vim
```
which will populate our environment with the vim program. Once we exit that shell by typing `exit` the program will be gone from our env.

### How did this happen?

* Nix first has to check `nixpkgs` repository to see if package with name `vim` is available to build.
* Then the cache for example `https://cache.nixos.org/` is checked to see if the package of that exact version is already build by someone.
* If the package is already built it is simply downloaded and extracted to correct path in `/nix/store`.
* It the package is not availabe in the cache it gets built from source and then put in the `/nix/store`
* Finally the `PATH` variable gets modified and the `vim` binary **AND ALL ITS DEPENDENCIES TO RUN** are added to it.

A simple comparison is a `python venv` but for all packages and more sophisticated.

It is also quite important to understand the structure which gets created in the `/nix/store`. The generated direcory for our `vim` package will have `/bin` catalog with all the executables. `vim` also has some dependencies like `gcc` which will also be stored in a separate catalog with its own hash and symlinked to the dependencies. Important note is that when another program needs that exact version of `gcc` it will not get redownloaded and stored twice, the same dependency package will get used for both programs.

Another important thing is that when we exit the shell these files do not get deleted. So when we want to re enter the shell, the package is already available and it will take very short time to start the ephemeral env again. The downside of this is that it takes up disc space. We can garbage collect the currently unused packages with `nix-collect-garbage`.

Python example - creating derivations of multiple python instances with different packages available.

Isolation without the need for containers.

```shell
nix repl
nix-repl> :l <nixpkgs>
nix-repl> python3
nix-repl> python3.withPackages (p: [p.numpy])
nix-repl> python3.withPackages (p: [p.jupyter])

nix-repl> :b python3.withPackages (p: [p.numpy])
nix-repl> :b python3.withPackages (p: [p.jupyter])
```

We can see here that we created two catalog for two pythons one which has access to numpy and another which has access to the jupyter package. When we run these python executables we can verify that these packages work.

## What happens when you nixos-rebuild

Lets imagine we finally want to add another package to our nixos system.
```nix
environment.systemPackages = with pkgs; [
    # we add git and vim
    git
    vim
];
```

`nixos-rebuild` is the NixOS command used to apply changes made to the system configuration. It in fact is a Bash script that performs a relatively simple sequence of tasks.

The `switch` subcommand will:
* Build the config.system.build.toplevel derivation of the current configuration.
* Add the resulting derivation to the system profile in /nix/var/nix/profiles, i. e. create a new generation in the system profile.
* Add the new generation to the bootloader menu as the new default and activate it.

After rebuilding the previous generations will still be available in the boot menu. In case anything breaks when switching the system, you can always reboot and select the previous generation which will be exactly the same as before running the switch command. This makes sure your system is really unbreakable and protected from your mistakes.

## Flakes

Flakes are a new system for managing nix ecosystem. They provide a standard way to write nix expressions whose dependencies are version-pinned in a lock file.

This is a `flake schema`.

```nix
{
  description = "This is a flake description";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small"; # moves faster, has less packages

    nixpkgs-python.url = "github:NixOS/nixpkgs/6b5019a48f876f3288efc626fa8b70ad0c64eb46"; # nixpkgs locked to certain commit hash which provides an old version of python
  };

  outputs ={ self, ... }@inputs:
    {
      # Executed by `nix flake check`
      checks."<system>"."<name>" = derivation;
      # Executed by `nix build .#<name>`
      packages."<system>"."<name>" = derivation;
      # Executed by `nix build .`
      packages."<system>".default = derivation;
      # Executed by `nix run .#<name>`
      apps."<system>"."<name>" = {
        type = "app";
        program = "<store-path>";
      };
      # Executed by `nix run . -- <args?>`
      apps."<system>".default = { type = "app"; program = "..."; };

      # Formatter (alejandra, nixfmt or nixpkgs-fmt)
      formatter."<system>" = derivation;
      # Used for nixpkgs packages, also accessible via `nix build .#<name>`
      legacyPackages."<system>"."<name>" = derivation;
      # Overlay, consumed by other flakes
      overlays."<name>" = final: prev: { };
      # Default overlay
      overlays.default = final: prev: { };
      # Nixos module, consumed by other flakes
      nixosModules."<name>" = { config, ... }: { options = {}; config = {}; };
      # Default module
      nixosModules.default = { config, ... }: { options = {}; config = {}; };
      # Used with `nixos-rebuild switch --flake .#<hostname>`
      # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
      nixosConfigurations."<hostname>" = {};
      # Used by `nix develop .#<name>`
      devShells."<system>"."<name>" = derivation;
      # Used by `nix develop`
      devShells."<system>".default = derivation;
      # Hydra build jobs
      hydraJobs."<attr>"."<system>" = derivation;
      # Used by `nix flake init -t <flake>#<name>`
      templates."<name>" = {
        path = "<store-path>";
        description = "template description goes here?";
      };
      # Used by `nix flake init -t <flake>`
      templates.default = { path = "<store-path>"; description = ""; };
    }
}
```

You provide `inputs` which are for example github repositories of other `flakes` or `nixpkgs`. Then using those `inputs` you can define multiple `outputs` some of these outputs are:

* `packages` - these are `derivations` which can be invoked for example with `nix run <flake>#package_name` which will build and invoke the package
* `devShells` - these are `derivations` which can be invoked with `nix develop <flake>#shell_name` this will create and put us in a temporary shell environment defined based on the flake
* `nisosConfigurations` - these are `derivations` which can be invoked with `nixos-rebuild switch <flake>#nixodConfiguration` which will create and apply the defined system configuration

Each of these can have a `default` specified which will run without providing a name, but many of each with different names can be specified. So we can have multiple packages, multiple systems and dev shells defined in a single flake which can share the exact versions of packages and the same common configurations. A perfect example is a dev machine and a production machine, they can share the project deps and the dev machine can provide extra things like IDEs and shell tools.

> *Notice the \<flake> can be either a local file or even a remote file, so we can grab a dev shell from a github repo without even downloading the definitions.*

## How to define outputs in flakes

### Packages

We can define multiple outputs like this.
```nix
# /packages/default.nix
{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) callPackage; # shorthand to alias function from pkgs instead of doing pkgs.callPackage
in {
  hello = pkgs.hello-cpp; # output being a default package from nixpkgs
  patchedHello = callPackage ./patchedHelloPackage {inherit pkgs;}; # hello-cpp with a custom git patch applies
  localProject = callPackage ./localProject {inherit pkgs;}; # locally build cpp project
  shellScript = callPackage ./shellScript {inherit pkgs;}; # shell script using packages
}
```

#### hello
> `nix run .#hello` will run `hello-cpp` package from nixpkgs and will output `Hello, C++`

#### patchedHello
```nix
# default.nix
{pkgs}:
pkgs.hello-cpp.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or []) ++ [./hello.patch];
})

# hello.patch
diff --git a/main.cpp b/main.cpp
index 1234567..89abcde 100644
--- a/main.cpp
+++ b/main.cpp
@@ -3,6 +3,6 @@
 int main(int argc, char *argv[]) {
-    std::cout << "Hello, C++\n";
+    std::cout << "Hello Rust 🦀! 😈\n";
     return 0;
 }
```
> `nix run .#patchedHello` will run `hello-cpp` with applied diff to its source code and will print `Hello Rust 🦀! 😈`

#### localProject
```nix
# default.nix
{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "local-cpp-project";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [pkgs.gcc];

  buildPhase = ''
    mkdir -p $out/bin
    g++ -o $out/bin/local-cpp-project main.cpp
  '';

  installPhase = ''
    ls -lh $out/bin
  '';
}

# main.cpp
#include <iostream>

int main() {
  std::cout << "Hello from localProject!" << std::endl;
  return 0;
}
```
> `nix run .#localProject` will run locally built cpp project and will output `Hello from localProject!`

#### shellScript
```nix
# default.nix
{pkgs, ...}:
pkgs.writeShellScriptBin "thisIsAScript" ''
  echo ${builtins.readFile ./text.txt}

  ${pkgs.cowsay}/bin/cowsay "Hello, this is cowsay speaking!"
''

# text.txt
This is a sample!
```
> `nix run .#shellScript` will run a shell script which will read local file contents, print it and invoke a package from nixpkgs which will output

```shell
This is a sample!
 _________________________________
< Hello, this is cowsay speaking! >
 ---------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

- `Nix` guarantees that all inputs for a build will be the same thanks to the `flake.lock` file.
- The build process will be performed offline, in a sandbox, meaning the output will be the same every time.

There obviously are some exceptions to this.
Some tools are not deterministic to build themselves looking at `java` which puts timestamps to all files which it creates for whatever ungodly reason.

### What do I do when a package is not available in nixpkgs

You can either submit a request to nixpkgs or build it yourself! Like the `localProject` example.

## devShells

Dev shells are something like previously mentioned `nix-shell -p` but nicer and defined in a flake.

This example devShell loads a bunch of packages which are usually really hard to set up with just a few lines of code.
```nix
{
  pkgs,
  inputs,
  system,
  ...
}: {
  default = pkgs.mkShellNoCC {
    name = "Example Dev Shell";
    meta.description = ''
      Metadata for the shell
    '';

    # Set up pre-commit hooks when user enters the shell.
    shellHook = ''
      echo hi
      LD_LIBRARY_PATH=${pkgs.gcc.cc.lib}/lib/
    '';

    # This is an example of setting an environment variable.
    MY_ENV_VARIABLE = "test";

    packages = with pkgs;
      [
        jdk
        opencv
        # ruby
        # cargo

        (python3.withPackages (python-pkgs: [
          python-pkgs.pandas
          python-pkgs.requests
        ]))

        (graphviz.override
          {
            # disable xorg support
            withXorg = false;
          })
      ]
      ++ [
        inputs.old-python.legacyPackages.${system}.python27
      ];
  };
}
This is a sample!
```

## Combine nix shells with [direnv](https://direnv.net/) for perfect dev env

`direnv` is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory.

It can be perfectly paired with nix devShells to automatically fetch all required dependencies per project.

All you need to do is:
* install direnv
* create the flake which specifies devShell
* create a `.envrc` file in the directory like this
```shell
use flake .

watch_file flake.nix
# watch_dir ./devShells
```
* specify files/directories which need to be watched for change, so when you update your devShell it will automatically be sourced

> additionally you can create shell.nix to sync old nix shells with flake shells (but this is nix trivia)
```nix
# in flake.nix
  inputs = {
    # unify nix-shell and flakes nix develop
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
```

```nix
# Make `nix-shell` consistent with `nix develop`
(builtins.getFlake ("git+file://" + toString ./.)).devShells.${builtins.currentSystem}.default
```

## Use flake.nix not Docker

### Why bother?

**Docker is *repeatable* not *reproducible*.**

`Docker` defines instructions but trusts the internet unconditionally, without performing any hashing. Dockerfiles do not provide you with reproducible builds.

Dockerfiles are quite easy -- you just chain together shell commands -- so understandably there is some hesitation to introduce a tool like Nix into the mix. The practical reason is that if you use Nix, you'll get always-working environments on local machines, CI, Docker, and more for free1; you have little to no duplicated effort.

A typical, non-Nix approach is to have a separate effort for local development, CI, and prod

* For local development, you may have a giant README, may use Docker compose, may use Vagrant, etc.
* Then, when you need to run or test your code in CI, you're probably writing YAML definitions to setup the environment again. A lot of times, the CI environment is different enough that you have slightly different shell requirements.
* Finally, for production, you have a Dockerfile with its own set of shell commands to run to build your final image.

These problems all go away with Nix. Nix is your single source of truth of what you need to build and run your software. You update this single source of truth and it generally just works everywhere. You don't need to maintain multiple descriptions of how to build and run your software anymore.

In isolation, I submit to you that using Nix with Docker is mostly just harder than using Docker by itself. But by realizing the compounding benefits of using Nix to then be able to enhance your CI and development environments with the same configuration, using Nix with Docker becomes easier than using Docker by itself and also has numerous other practical benefits.

### The workflow

* Write Nix code to describe how to build and run your application.
* Use a Dockerfile and the official Nix image to build your application using Nix using roughly one shell command.
* Use a multi-stage build FROM scratch to copy your built application into the smallest possible image. This final image doesn't have Nix installed at all -- we just used Nix to build.

Let's show how to do this based on a python flask project and use an actual Dockerfile (this can also be done without using docker at all, just using nix but Dockerfile will be more familiar for now)

Hello world type app in flask.
```python
# our flask app /src/app.py
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
```

Snippet from our nix flake, creating build dev shell and exposing the default package which we build using `poetry2nix`
```nix
# fragment of out flake
# Development environment
devShell = mkShell {
  name = "flask-example";
  nativeBuildInputs = [ python3 poetry ];
};

# Runtime package
packages.app = poetry2nix.mkPoetryApplication {
  projectDir = ./.;
};

# The default package when a specific package name isn't specified.
defaultPackage = packages.app;
```
> We can test this build process locally with `nix build` like we did before.

Now the Dockerfile
```Dockerfile
# Nix builder
FROM nixos/nix:latest AS builder

# Copy our source and setup our working dir.
COPY . /tmp/build
WORKDIR /tmp/build

# Build our Nix environment
RUN nix \
    --extra-experimental-features "nix-command flakes" \
    --option filter-syscalls false \
    build

# Copy the Nix store closure into a directory. The Nix store closure is the
# entire set of Nix store values that we need for our build.
RUN mkdir /tmp/nix-store-closure
RUN cp -R $(nix-store -qR result/) /tmp/nix-store-closure
# nix store -qR result outputs the full list of Nix directories that our application needs. Specifically, it is the closure of dependencies that only our application needs. I know this can be confusing, so to put it one final way: it is the smallest possible set of dependencies (files and folders) that our application needs to run and literally nothing else.

# Final image is based on scratch. We copy a bunch of Nix dependencies
# but they're fully self-contained so we don't need Nix anymore.
FROM scratch

WORKDIR /app

# Copy /nix/store
COPY --from=builder /tmp/nix-store-closure /nix/store
COPY --from=builder /tmp/build/result /app
CMD ["/app/bin/app"]
```

This is a [multi-stage build](https://docs.docker.com/build/building/multi-stage/). We first start with our builder container which is based on nixos/nix. This is the Nix official base image that just has nix installed.

To run the build
```shell
docker build -t flask-example:dev .
```
To start the container
```shell
docker run --rm flask-example:dev
```

This way you get all the extra benefits of Nix: your Docker image has the smallest possible set of files to run your application and nothing more, the contents of your Docker image are reproducible.

### The downsides?

Not that many, main one being `you need to learn nix` which quite often becomes a skill issue.

Another downside is that the layers produced in the Docker image are not optimal. The single RUN nix build command produces a giant layer with all the dependencies in it. From a build-time perspective, this is really fast because almost all of your dependencies will be downloaded from a binary cache. But, it is not optimal for caching and basically every redeploy will require your runtime environment to redownload the largest layer of your image.

Nix is able to make more optimal Docker image layers by using the native Nix `dockerTools` to build an image instead of a Dockerfile.

## dockerTools

This is a minimal example how to build and use nix `dockerTools`
```nix
{pkgs, ...}:
pkgs.dockerTools.buildLayeredImage {
  name = "go-app";
  tag = "latest";
  contents = [ pkgs.go ];
  config = {
    Cmd = [ "/bin/sh" "-c" "go --version" ];
  };
}
```

## NixOS usage

NixOS use case is pretty simple - when we need our services, users, kernels, discs and whole system configuration to be declarative and reproducible.

It provides a really simple interface to:

* install programs for all users
```nix
environment.systemPackages = with pkgs; [
  wget # let's assume wget was already present
  vim
];
```

* install programs per user
```nix
users.users.pacto.packages = with pkgs; [ vim ];
```

* install services
```nix
services.openssh.enable = true;
```

* add a user
```nix
users.users.alice =
{ isNormalUser = true;
  home = "/home/alice";
  description = "Alice Foobar";
  extraGroups = [ "wheel" "networkmanager" ];
  openssh.authorizedKeys.keys =
    [ "ssh-dss AAAAB3Nza... alice@foobar" ];
};
```

* configure a service
```nix
services.grafana = {
  enable = true;
  settings = {
    server = {
      http_addr = "0.0.0.0";
      domain = "grafanaa.pacto.live";
      http_port = 3000;
    };
  };
};

networking.firewall.allowedTCPPorts = [ 3000 ];
```

## Benefits

- Declarative
- Immutable
- Reproducible
- Unbreakable

- Anyone can compile my code on any machine, the pinnacle of `Works on my machine`.

No need to remember specific commands which you had to manually run to enable a service or install a package; once you set up your environment in nix you are always guaranteed the same result.

Automatically stores backups of all versions of systems which were successfully built after the switch command which can be picked from in the grub boot menu. You will never get locked out of your broken machine, since you can choose previous system configuration on boot.

## Ubuntu vs NixOS

[Whole comparison on nix wiki](https://nixos.wiki/wiki/Ubuntu_vs._NixOS)

<!-- <div style="display: flex; gap: 10px; justify-content: space-between; padding: 0 10px; gap: 10px;"> -->
<!---->
<!-- ```python -->
<!-- # Python code -->
<!-- def hello(): -->
<!--     print("Hello, World!") -->
<!-- ``` -->
<!---->
<!-- ```python -->
<!-- # Python code -->
<!-- def hello(): -->
<!--     print("Hello, World!") -->
<!-- ``` -->
<!---->
<!-- </div> -->

## Nix on Ubuntu

We can easily install `nix` on any OS with this command `sh <(curl -L https://nixos.org/nix/install) --daemon`. After the installation is complete we will have access to all `nix` package manager features.

[source](https://nixos.org/download/)

## Disko

Disko is a utility and NixOS module for declarative disk partitioning.

Example config
```nix
# disko-config.nix
{ disks ? [ "/dev/vda" ], ... }: {
  disko.devices = {
    disk = {
      vdb = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "500MiB";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "root";
              start = "500MiB";
              end = "100%";
              part-type = "primary";
              content = {
                type = "filesystem";
                format = "bcachefs";
                mountpoint = "/";
              };
            }
          ];
        };
      };
    };
  };
}
```

This will allow us to have a declarative disk layout on all of our machines. If we wanted to deploy multiple machines with same configs and same disks disko will make it really easy for us.

## Installing NixOS remotely

### Installing on non nixOS

We can use a tool called [nixos-anywhere](https://github.com/nix-community/nixos-anywhere)

This tool will allow us to overtake existing system, install nixos and apply our flake configuration along with disko disk layouts.

### Applying remotely to nixOS

We can also take our local `flake.nix` and apply its configuration to a remote machine over `ssh`.

`NIX_SSHOPTS="-p {{SSH_PORT}}" nixos-rebuild switch --flake <flake>#nixosConfiguration --target-host {{REMOTE_ADDR}}`

## Installing on machines with terraform

[terraform-nix](https://github.com/nix-community/terraform-nixos)

## Nix binary cache

[cachix](https://www.cachix.org/)
[attic](https://github.com/zhaofengli/attic)

## Inspect remote flake variables

If you need to quickly check whether some option is enabled in your flake, there is no need to download the whole repo, open a text editor and grep for the line.
There also are cases where some options might be optional and based on other variables in your config. To check the fully evaluated value of a variable we can use nix repl.

```shell
nix repl

nix-repl> :lf github:pact0/nixos
nix-repl> nixosConfigurations.nixos.config.hardware.graphics.enable

```

## Cross compiliation

`nix build nixpkgs#pkgsCross.riscv64.hello -L`

This will build the file from source. The result will be a dynamically linked riscv64 executable.

`file result/bin/hello`

`uname -a`

`./result/bin/hello`

> [Debian alternatie...](https://wiki.debian.org/QemuUserEmulation)

## Useful links

- [NixOS](https://nixos.org/)
- [Flakes](https://nixos.wiki/wiki/Flakes)
- [Available Packages](https://search.nixos.org/packages)
- [direnv](https://direnv.net/)
- [nix2container](https://github.com/nlewo/nix2container)
- [home-manager](https://github.com/nix-community/home-manager)
- [nixhub](https://www.nixhub.io/packages/)
- [nh](https://github.com/viperML/nh)
- [flake starter](https://github.com/Misterio77/nix-starter-configs)

## Learn more

- [nix.dev](https://nix.dev/)
- [zero-to-nix](https://zero-to-nix.com/)
- [nix-pills](https://nixos.org/guides/nix-pills/)

## Useful commands

- `nix search github:NixOS/nixpkgs/nixos-unstable foo` - find package
- `nix bundle --bundler github:nix-how/nix-demos#runtimeReport nixpkgs#firefox` - get runtime deps for firefox

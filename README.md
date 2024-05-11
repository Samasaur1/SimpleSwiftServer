# Server

A Swift executable equivalent to Python's SimpleHTTPServer — with extra features!

## Installing
Make sure Xcode 10.2 or higher is installed first (not necessary with Nix).

### [Nix](https://nixos.org)

This repository is a flake, so:

```sh
nix profile install github:Samasaur1/SimpleSwiftServer
```

or add this to `environment.systemPackages`/`home.packages`, assuming your flake inputs are available as `inputs`:

```nix
inputs.SimpleSwiftServer.packages.${pkgs.system}.default
```

### [Mint](https://github.com/yonaskolb/mint)

#### Install
```sh
$ mint install Samasaur1/SimpleSwiftServer
```

##### Update
```sh
$ mint install Samasaur1/SimpleSwiftServer
```

### Swift Package Manager

**Use CLI**

```sh
$ git clone https://github.com/Samasaur1/SimpleSwiftServer.git
$ cd SimpleSwiftServer
$ swift run server
```

### [Homebrew](https://brew.sh) \[Not Recommended\]

```sh
$ brew install Samasaur1/core/simpleswiftserver
```

I don't use Homebrew anymore, and it's kind of a pain to maintain a formula, so I probably won't update this package past v4.3.1. I *might* update it with critical bug fixes, but I make no promises.

## Usage

SimpleSwiftServer has two modes: a file downloader (to easily share files) and a directory browser. It also allows you to specify your port.

The default port is 1234, the default mode is a directory browser, and the default path is the current directory.

***
Opens a directory browser from the current directory on port 1234
```sh
$ server
```

Opens a directory browser from the current directory on port 4321
```sh
$ server 4321
```

Opens a directory browser from the `Desktop` subdirectory on port 1234
```sh
$ server --browse Desktop
```

Opens a file downloader for the file `Package.swift` in the Desktop subdirectory on port 1234
```sh
$ server --file Desktop/Package.swift
```

Opens a directory browser from the root directory on port 46264. **Note: this is a terrible idea, as any confidential files (tokens, keys) are publically accessible.** Share the smallest amount of your system that you need.
```sh
$ server 46264 --browse /
```

# aru's XMonad config

```txt
                                /██                       /██      /████████
                               | ██                      | ██     |_____ ██/
  /██████  /██████ /██   /██   | ███████  /██████  /██████ ██   /██    /██/
 |____  ██/██__  █| ██  | ██/███ ██__  ██|____  ██/██____| ██  /██/   /██/
  /██████| ██  \__| ██  | ██/__/ ██  \ ██ /██████| ██    | ██████/   /██/
 /██__  █| ██     | ██  | ██   | ██  | ██/██__  █| ██    | ██_  ██  /██/
|  ██████| ██     |  ██████/   | ██  | █|  ██████|  ██████ ██ \  ██/████████
 \_______|__/      \______/    |__/  |__/\_______/\______|__/  \__|________/
```

Here is my XMonad config, and I also will guide you through the process of
installation.

## Table of Contents

- [Installation](#installation)
  - [Installing ghcup, cabal and more](#installing-ghcup-cabal-and-more)
  - [Installing xmonad and xmonad-contrib](#installing-xmonad-and-xmonad-contrib)
- [Configuration](#configuration)
  - [cabal file](#cabal-file)
  - [build file](#build-file)
  - [hie.yaml](#hieyaml)
  - [XMonad config](#xmonad-config)
- [XMonad initialization](#xmonad-initialization)
  - [Testing](#testing)
  - [Configuring the login manager](#configuring-the-login-manager)

## Installation

Here I will show you how to install xmonad and xmobar, but first you will need
a haskell compiler, ghc, and cabal. The best way to install those is with
[ghcup](https://gitlab.haskell.org/haskell/ghcup-hs).

### Installing ghcup, cabal and more

You can download it via a `curl | sh` command like this:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Or, if available, with your package manager, for Arch users it is available in
the AUR:

```shell
yay -S ghcup-hs-bin
# aaa
```

Now that you have ghcup, lets list everything available:

```shell
ghcup list

# Output example:
#    Tool  Version Tags                      Notes
# ✗  ghc   7.10.3  base-4.8.2.0
# ...
# ✗  ghc   8.10.4  recommended,base-4.14.1.0 hls-powered
# ✗  ghc   9.0.1   latest,base-4.15.0.0
# ✗  cabal 2.4.1.0
# ...
# ✗  cabal 3.4.0.0 latest,recommended
# ✗  hls   1.0.0   latest,recommended
# ✗  ghcup 0.1.14  latest,recommended
```

Here you see you can install ghc, cabal and hls. I recommend you install the
recommended ghc version, which is hls-powered and so you can install hls
(haskell language server, for completion, debugging, etc) and so on with cabal
and hls, choose the recommended version.

Now that you have cabal, ghc and maybe hls, you need to add the binarys located
in `.cabal` and `.local` to your `$PATH`, so head to your `~/.xprofile` file and
add the following:

```shell
# .xprofile file
export PATH="$PATH:$HOME/.cabal/bin:$HOME/.local/bin"
```

### Installing xmonad and xmonad-contrib

With cabal installed we can just do `cabal install <package>` to install
packages, but for `xmonad-contrib` you will need to specify the `--lib` flag
for it to work properly, because it doesn't install an executable like `xmonad`
but a library.

```shell
cabal install xmonad
cabal install --lib xmonad-contrib
```

## Configuration

We have everything we need, lets start confuring it to make it work.

### cabal file

We will be using cabal to manage our project, so we will need a cabal file for
it, you can use [my cabal file](./aru-xmonad.cabal) changing any parameter or
info you need.

In a cabal file, appart from the the projects metadata like author, version,
etc, we have to specify, in this case, an executable, which will have as main
file our xmonad configuration file. We can also add flags for its compilation,
and the dependencies needed to build, which are `base`, `xmonad` and
`xmonad-contrib`.

**NOTE**: I advice you to name the cabal file, project name (inside the cabal file)
and executable name **with the same name**, as you can see in my cabal file,
because you will have problems if you dont do it this way.

### build file

Because we are using cabal to build our executable, we will need a build file
which xmonad will use when recompiling to point tell cabal to build the
executable. Just copy [this executable](./build).

### hie.yaml

If you are using an IDE like VSCode or any code editor with lsp, and you have
installed HLS, you should make a hie.yaml file in every cabal project you
create, so HLS will know what it needs to compile to debug your file, show
errors, docs, etc.

You can make the hie.yaml file manually, but in my opinion its better to use
the tool `gen-hie`, which you can install with `cabal install implicit-hie`
and then, within the project root, run `gen-hie > hie.yaml`, and now you are
able to use HLS with its maximum power.

### xmonad config

Now you need to create a xmonad.hs file (or how you called it in the cabal
file, inside the executable, with the `main-is` parameter) and inside of it put
your configuration.

## XMonad initialization

### Testing

Before the next step, you have to run `cabal build` to build the project. Now
you can compile xmonad, and see if it works, to do it just run
`xmonad --recompile` (maybe you cant use `xmonad` because the executable is not
on PATH, so you can just logout and login), and see if it compiles, if it
doesn't it will tell you what is broken.

When xmonad is compiled, you can use xephyr to test it, or you can just go to
the next step.

### Configuring the login manager

Now that you have a working xmonad config, you want to start it with your login
manager of preference, so we need to setup a `.desktop` file in
`/usr/share/xsessions`, we will call it `xmonad.desktop`:

```desktop
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Xmonad
Comment=Lightweight X11 tiled window manager written in Haskell
Exec=xmonad
Icon=xmonad
Terminal=false
StartupNotify=false
Categories=wm,tiling
```

Now with this saved, you can log out and log in again, and in your login manager
you should see a new entry called XMonad, and it should let you start using it,
unless you have done anything bad, if so try compiling xmonad and see if it
gives any error.

As I told you at the end of [here](#Installing-ghcup-cabal-and-more), you will
need to have the executables in your path.

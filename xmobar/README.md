# aru's XMobar config

```text
                                /██                       /██      /████████
                               | ██                      | ██     |_____ ██/
  /██████  /██████ /██   /██   | ███████  /██████  /██████ ██   /██    /██/
 |____  ██/██__  █| ██  | ██/███ ██__  ██|____  ██/██____| ██  /██/   /██/
  /██████| ██  \__| ██  | ██/__/ ██  \ ██ /██████| ██    | ██████/   /██/
 /██__  █| ██     | ██  | ██   | ██  | ██/██__  █| ██    | ██_  ██  /██/
|  ██████| ██     |  ██████/   | ██  | █|  ██████|  ██████ ██ \  ██/████████
 \_______|__/      \______/    |__/  |__/\_______/\______|__/  \__|________/

```

Here is my XMobar config, and I also will guide you through the process of
installation.

## Table of Contents

- [Installation](#installation)
  - [Installing xmobar](#installing-xmobar)
- [Configuration](#configuration)
  - [xmobarrc](#xmobarrc)
  - [start xmobar from xmonad](#start-xmobar-from-xmonad)

## Installation

Here I will show you how to install xmobar, I will be doing it with cabal so if
you didn't follow my instructions to install XMonad, take look
[here](../xmonad#installing-ghcup-cabal-and-more) to know how to install cabal.

### Installing xmobar

This is really easy, you just need to do a `cabal install`, but in xmobar we can
add support for many things, like xft fonts and some widgets, so we will be
adding the flag `--flags="all_extensions"`, so it will look like this:

```shell
cabal install xmobar --flags="all_extensions"
```

And thats it, really easy.

## Configuration

### xmobarrc

You will need a xmobarrc file (you can call it however you want) where you will
have your xmoabr configuration, if you have many monitors and want different
setups, make as many as needed. you can take a look at my current laptop +
external monitor setup.

### start xmobar from xmonad

Now that you configured xmobar, you will need to start from xmonad, so as you
can see in my [xmonad config](../xmonad/xmonad.hs) you will need to invoque it
with a `spawnPiepe "xmobar -x N path/to/xmobarrc"`, the `-x N` part is for
telling xmobar in which monitor to spawn.

You can then pass a logHook to xmobar for it to display some info, like
workspaces, current layout, window title, etc.

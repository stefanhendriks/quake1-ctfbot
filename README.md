# quake1-ctfbot
Copy of [ctf bot and CTF game code (Threewave) and bot code](https://www.moddb.com/mods/threewave-capture)

# Getting started
First go to the ctfbot12 folder, and unpack the `ctfbot12.zip` file in your `Quake` homedir. I suggest you name this `ctfbot`.

Then you can run CTF with the bot by passing the `-game ctfbot` argument to Quake.

Ie:
```
quake.exe -game ctfbot
```

This should already get it up and running.

Do note, if you want to have your changes in any bot code working, you need to do a bit more. See below what to do
to make those changes work.

# Compiling
This is QuakeC, a compiler (QCC) is also in this repo, it is very old (as it was taken from the original ZIP file).

You can either run `qcc.exe` or use `wine` or something else if you are not on Windows. I run on OS X using wine and it compiles fine.

# Editing

If you use IntelliJ IDEA (like me) often, you might want to load this project with that and use
[this quakec plugin for IDEA](https://github.com/TimePath/idea-quakec/releases)

You need to install it from disk, works like a charm.

# Running your own progs.dat code

You can either do the following steps below *or* you use the `ctfbot-without-pak.zip` file instead of `ctfbot12` zip file.

If you want to do it manually, make sure

- you have unpacked the `pak1.pak` and `pak0.pak` files in the `ctfbot` folder
  - you can use [Pak Explorer](http://www.quaketerminus.com/tools.shtml) for this.
- after unpacking, remove the `pak1.pak` and `pak0.pak` files.

From this point onward you basically have unpacked files, no .pak files lingering around.

Remove the old `progs.dat` (or make a backup)

copy your own `progs.dat` in your `ctfbot` folder.

Run your quake with `ctfbot`.

Ie:

```
glquake.exe -game ctfbot -listen 32
```


# quake1-ctfbot
Copy of [ctf bot and CTF game code (Threewave) and bot code](https://www.moddb.com/mods/threewave-capture)

# Compiling
This is QuakeC, a compiler (QCC) is also in this repo, it is very old (as it was taken from the original ZIP file).

You can either run `qcc.exe` or use `wine` or something else if you are not on Windows. I run on OS X using wine and it compiles fine.

# Editing

If you use IntelliJ IDEA (like me) often, you might want to load this project with that and use
[this quakec plugin for IDEA](https://github.com/TimePath/idea-quakec/releases)

You need to install it from disk, works like a charm.

# Running your own progs.dat code

Make sure

- you have unpacked the `pak1.pak` and `pak0.pak` files in the `ctfbot` folder
- after unpacking, remove the `pak1.pak` and `pak0.pak` files.

From this point onward you basically have unpacked files, no .pak files lingering around.

Remove the old `progs.dat` (or make a backup)

copy your own `progs.dat` in your `ctfbot` folder.

Run your quake with `ctfbot`.

Ie:

```
glquake.exe -game ctfbot -listen 32
```


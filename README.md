# amictl: the remote test station for the Amiga

`amictld` runs on the Amiga (AmigaOS 3, Roadshow; written for an A1200 with a
PiStorm and Emu68). `amictl.py` runs on the PC and, over the LAN, uploads
files, runs commands and packages, fetches results, takes screenshots, and
drives the Amiga's keyboard and mouse. One server on the Amiga serves every
project: port 6800 for commands, 6801 for input.

It is shared by the projects that test on the Amiga (ogles2, ogles2pi3,
ogles3), each of which includes it as a git submodule at `tools/amictl`:

```
git submodule add https://github.com/ladislawv/amictl.git tools/amictl
```

Paths in the code assume that place: `amictl.py` takes the project's root as
two directories up (packages from `tests/a1200/out/`, results into
`tests/a1200/results/`). A project's own tools that talk to the Amiga (its
shader compile bridge, for example) stay in that project and import
`tools/amictl/amictl.py`.

## Files

| File | What |
|---|---|
| `amictl.py` | the PC's client (`python3 tools/amictl/amictl.py help` lists the commands) |
| `deqp_watch.py` | runs a dEQP package and watches it: the case running, the library's log, free memory; a hang or reset reported with the case it happened in (needs amictld 1.4 and the project's dEQP progress patch) |
| `amikvm.ps1` | the PC's mouse and keyboard drive the Amiga (Windows; amictld 1.3's input channel) |
| `test_host.py` | the protocol tested against the server built for the PC (no Amiga needed) |
| `server/` | `amictld`: the protocol (`amictl_proto.h`, version 1.4), the server, its OS layers for AmigaOS (`os_amiga.c`) and POSIX (`os_posix.c`) |
| `station.local.example` | the PC's settings: the Amiga's address, the token, the PCs allowed |

## Setup

1. Copy `station.local.example` to `station.local` (next to `amictl.py`) and
   fill it in; a new token: `python3 tools/amictl/amictl.py gentoken /dev/stdout`.
   `station.local` holds the token: it is in `.gitignore`, never commit it or
   paste it anywhere.
2. Build the server (the project's Makefile: `server/amictld.c` and
   `server/os_amiga.c` with m68k-amigaos-gcc) and install it on the Amiga with
   its token and allow list (the project's `amictld` package).
3. `python3 tools/amictl/amictl.py hello`.

The server accepts only the addresses in its allow list, and only after a
`HELLO` that carries the token; it logs every command. It is meant for a LAN
only: never forward its ports.

Before `reboot`, `restart` or `quit`, or a change to the Amiga's system files,
ask the Amiga's owner.

MIT licence (`LICENSE`).

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

There, `runpkg` and `deqp_watch.py` put results into the project's
`tests/a1200/results/`. A project's own tools that talk to the Amiga (its
shader compile bridge, for example) stay in that project and import
`tools/amictl/amictl.py`.

It also works on its own, from a checkout such as `C:\- CPPmictl`
(`PROMPT.md`: what to tell a Claude session in another project): results then
go to `./results/`. `AMICTL_RESULTS` names another results directory,
`AMICTL_STATION` another settings file; `AMICTL_HOST`, `AMICTL_PORT` and
`AMICTL_TOKEN` override them.

## Files

| File | What |
|---|---|
| `amictl.py` | the PC's client (`python3 tools/amictl/amictl.py help` lists the commands) |
| `deqp_watch.py` | runs a dEQP package and watches it: the case running, the library's log, free memory; a hang or reset reported with the case it happened in (needs amictld 1.4 and the project's dEQP progress patch) |
| `amikvm.ps1` | the PC's mouse and keyboard drive the Amiga (Windows; amictld 1.3's input channel) |
| `test_host.py` | the protocol tested against the server built for the PC (no Amiga needed) |
| `server/` | `amictld`: the protocol (`amictl_proto.h`, version 1.4), the server, its OS layers for AmigaOS (`os_amiga.c`) and POSIX (`os_posix.c`) |
| `station.local.example` | the PC's settings: the Amiga's address, the token, the PCs allowed |
| `build.sh`, `amiga/` | the server and its install directory (`out/amictld/`, `.lha`) built on their own; `bash build.sh test`: the host test |
| `PROMPT.md` | for a Claude session in another project: how to test on the Amiga through this |

## Setup

1. Copy `station.local.example` to `station.local` (next to `amictl.py`) and
   fill it in; a new token: `python3 tools/amictl/amictl.py gentoken /dev/stdout`.
   `station.local` holds the token: it is in `.gitignore`, never commit it or
   paste it anywhere.
2. Build the server and its install directory with `bash build.sh` (or the
   project's Makefile and `amictld` package: the same sources and flags), copy
   `out/amictld/` to the Amiga and follow its `ReadMe.txt` (a line in
   `S:User-Startup`, then `Execute Start-amictld`). A newer server later:
   upload it over the old binary and `amictl restart` with its path.
3. `python3 tools/amictl/amictl.py hello`.

The server accepts only the addresses in its allow list, and only after a
`HELLO` that carries the token; it logs every command. It is meant for a LAN
only: never forward its ports.

Before `reboot`, `restart` or `quit`, or a change to the Amiga's system files,
ask the Amiga's owner.

MIT licence (`LICENSE`).

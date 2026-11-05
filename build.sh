#!/bin/bash
# Builds the Amiga server and its install directory out/amictld/ (+ .lha if
# lha is found): amictld, amictld.token and amictld.allow from station.local,
# Start-amictld, ReadMe.txt. Run in WSL/Linux with bebbo's m68k-amigaos-gcc.
# (A project including amictl as tools/amictl may build the server with its
# own Makefile instead: the same sources and flags.)
#   bash build.sh            TC=<toolchain prefix dir> to override
#   bash build.sh test       builds the server for the PC and runs test_host.py
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
TC=${TC:-$HOME/amiga-gcc-install}
OUT=$HERE/out
mkdir -p "$OUT"
if [ "${1:-}" = test ]; then
    gcc -std=c99 -O2 -Wall -Wextra -o "$OUT/amictld_host" "$HERE/server/amictld.c" "$HERE/server/os_posix.c"
    exec python3 "$HERE/test_host.py" "$OUT/amictld_host"
fi
[ -f "$HERE/station.local" ] || { echo "station.local missing (see station.local.example)"; exit 1; }
PKG=$OUT/amictld
rm -rf "$PKG"; mkdir -p "$PKG"
"$TC/bin/m68k-amigaos-gcc" -std=gnu99 -O2 -Wall -Wno-pointer-sign -mcpu=68020 -mcrt=nix20 \
    -fbbb=abcfhilmnprsz0 -o "$PKG/amictld" "$HERE/server/amictld.c" "$HERE/server/os_amiga.c"
python3 - "$HERE/station.local" "$PKG" <<'PY'
import json, sys
cfg = json.load(open(sys.argv[1]))
open(sys.argv[2] + "/amictld.token", "w").write(cfg["token"] + "\n")
open(sys.argv[2] + "/amictld.allow", "w").write("\n".join(cfg["allow"]) + "\n")
PY
for f in ReadMe.txt Start-amictld; do sed 's/\r$//' "$HERE/amiga/$f" > "$PKG/$f"; done
LHA=${LHA:-$HOME/tools/bin/lha}
[ -x "$LHA" ] && (cd "$OUT" && rm -f amictld.lha && "$LHA" -ao5q amictld.lha amictld)
ls -l "$PKG" "$OUT"

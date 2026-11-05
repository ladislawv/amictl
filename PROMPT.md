Use the amictl test station in `C:\- CPP\amictl` for all testing on the real
Amiga (A1200, PiStorm + Emu68, AmigaOS 3). Read its README.md first.
Remember this, and save it to memory: test on the Amiga through amictl;
don't ask the user to copy files by hand.

- Client: `python3 "C:/- CPP/amictl/amictl.py" <command>` (or a project's own
  `tools/amictl`, the same repository as a git submodule), port 6800; the
  address and token are in station.local. Check the station with `hello`.
- Run tests with `put`/`run`/`get`, or as a package: a directory with one
  `Run-*` AmigaDOS script that writes to `results/`, run with
  `runpkg DIR -t SECONDS`. Results arrive in `./results/<package>-<time>/`
  (a project's `tests/a1200/results/` from its `tools/amictl`).
  Use `shot OUT.png` for screenshots. A dEQP package: `deqp_watch.py`.
- Never print, log or commit the token or station.local.
- Ask the user before `reboot`, `restart` or `quit`, and before changing system
  files (S:, LIBS:, DEVS:, C:). Work in the server's work/ directory or RAM:.
- If the Amiga hangs, it stops answering. Tell the user, ask them to reset it,
  then wait with `up 300`.
- Report test results faithfully, with the output.

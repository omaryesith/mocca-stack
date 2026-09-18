# docker Profile

This conventions-only Profile covers the approved
`containerization:docker` capability. It contributes no engineering
configuration, product source, Dockerfile, Compose file, `.dockerignore`,
Makefile, script, or application scaffold.

Docker must be provided externally when an approved operation requires it.
Mocca neither installs nor configures Docker, and applying this Profile does
not execute Docker or create containers. Docker artifacts are created during
`IMPLEMENTATION` from the approved requirements, technology decisions,
architecture, ADRs, and specifications.

After application, its active rules live at:

```text
.mocca/profiles/docker/conventions/docker-engineering.md
```

Confirm application with `docker` in `MOCCA.md` under **Applied profiles** and
by checking that file. Profile application itself is verified through the
workspace's `./scripts/verify`; project Docker verification is defined later
by the approved implementation.

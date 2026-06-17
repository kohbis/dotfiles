---
name: running-apple-container
description: "Runs code in isolated Linux containers via Apple Container CLI on macOS. Use for executing untrusted code, testing with specific runtimes, or clean-room builds. Trigger when user says 'run in container', 'apple container', 'container run', 'isolate', or needs hardware-level isolation beyond built-in sandbox mode."
disable-model-invocation: true
---

# Running Apple Container

Execute and verify code inside Apple Container Linux VMs on macOS. Each container runs in its own lightweight VM via Virtualization.framework — hardware-level isolation, not just permission restrictions.

Verify the CLI is available before proceeding:

```bash
container --version
```

If the command is not found, stop and tell the user to install it from https://github.com/apple/container.

## When to use this vs. built-in sandbox mode

The built-in sandbox mode restricts the agent harness's tool permissions — it is fast, zero-setup, and sufficient for preventing accidental writes. Apple Container provides a full Linux VM boundary and is the right choice when the code itself is the threat, not the agent's tools.

| Scenario | Use | Why |
|----------|-----|-----|
| Prevent accidental file writes during normal Claude work | **Sandbox mode** | Zero-setup harness-level restriction |
| Run LLM-generated code that could be malicious | **Apple Container** | Hardware-level VM isolation; host untouched |
| Install untrusted dependencies (`npm install`, `pip install`) | **Apple Container** | Package install scripts run arbitrary code |
| Test with a specific runtime version (Node 22, Python 3.13) | **Apple Container** | Pin exact image; no host version manager needed |
| Clean-room build verification | **Apple Container** | Fresh filesystem every run; no implicit host state |
| Run Linux-specific tools on macOS | **Apple Container** | Native Linux VM via Virtualization.framework |
| Quick script that only reads/writes within the project | **Sandbox mode** or plain | Container startup overhead not worth it |

## Image selection

Pick the smallest image that satisfies the runtime requirement:

| Runtime | Image | Notes |
|---------|-------|-------|
| Shell / general | `alpine:latest` | ~7 MB, musl libc, `apk add` for extras |
| Shell (glibc) | `ubuntu:latest` | ~30 MB, when musl compatibility is a concern |
| Node.js | `node:alpine` | Use `node:slim` if glibc is needed |
| Python | `python:slim` | Slim variant saves ~800 MB vs full |
| Go | `golang:alpine` | Includes `go build` |
| Rust | `rust:slim` | Includes `cargo` |
| Ruby | `ruby:slim` | Includes `gem` |
| Multi-language | Custom Dockerfile | Build with `container build` (see Workflow 3) |

When unsure, start with `alpine:latest` and install what you need via `apk add`. Use version-pinned tags (e.g., `node:22-alpine`) only when the project specifies a required version.

## Workflow 1: Ephemeral run

Run code once and discard the container. The most common pattern — use for verifying generated code, running tests, or checking builds.

```bash
container run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd)":"$(pwd)":ro \
  -w "$(pwd)" \
  <image> \
  <command>
```

- `--rm` — auto-remove when the container exits
- `-u "$(id -u):$(id -g)"` — run as the host user, not root (the container default is root)
- `-v <host>:<container>:ro` — bind-mount read-only
- `-w` — set working directory inside the container

When the command needs to write output files, mount a separate output directory read-write while keeping source read-only:

```bash
mkdir -p tmp/container-output
container run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd)":"$(pwd)":ro \
  -v "$(pwd)/tmp/container-output":/output \
  -w "$(pwd)" \
  <image> \
  sh -c '<command> && cp result /output/'
```

Always capture stdout, stderr, and exit code:

```bash
container run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd)":"$(pwd)":ro \
  -w "$(pwd)" \
  <image> \
  sh -c '<command>' 2>&1
echo "Exit code: $?"
```

## Workflow 2: Persistent dev container

Keep a named container running for iterative work. Use when setup takes a long time or you need multiple exec rounds.

```bash
mkdir -p tmp/container-work
container run -d \
  --name dev-sandbox \
  -v "$(pwd)":"$(pwd)":ro \
  -v "$(pwd)/tmp/container-work":/work \
  -w "$(pwd)" \
  <image> \
  sleep infinity
```

Source is still mounted `:ro`. Use `/work` for writable output. If the task genuinely requires full repo write access (e.g., iterative edits), get explicit user consent before mounting without `:ro`.

```bash
# Execute commands
container exec dev-sandbox sh -c '<command>'

# Install tools (root is needed for package managers)
container exec -u root dev-sandbox apk add --no-cache git curl jq

# Copy files out
container copy dev-sandbox:/work/artifact ./tmp/

# Tear down
container stop dev-sandbox && container rm dev-sandbox
```

## Workflow 3: Build verification

Verify that a project builds from scratch in a clean environment.

```bash
mkdir -p tmp
# Write Dockerfile to tmp/Dockerfile
container build -t project-verify -f tmp/Dockerfile .
container run --rm project-verify <build-and-test-command>
container image rm project-verify
```

Or verify an existing Dockerfile:

```bash
container build -t verify-build .
container run --rm verify-build sh -c '<test-command>'
container image rm verify-build
```

## Workflow 4: Container machine

For long-lived development VMs that survive reboots. The machine auto-mounts the host home directory by default (rw), so always set `--home-mount` explicitly.

```bash
# Create with no home mount (safe default for untrusted code)
container machine create ubuntu:latest --name dev \
  --cpus 4 --memory 8G --home-mount none

# Run commands
container machine run -n dev -- <command>

# Root access when needed
container machine run -n dev --root -- apt-get update

# Tear down
container machine stop dev && container machine delete dev
```

Use `--home-mount ro` only for trusted convenience workflows where you need to read host files. Even read-only home mount exposes `~/.ssh`, `~/.aws`, and other credentials — never use `ro` or `rw` with untrusted code.

## Reporting results

After every container execution, report:

1. **Image** used
2. **Command** executed
3. **Exit code** — 0 = success, non-zero = failure
4. **stdout** — the command's standard output
5. **stderr** — error messages and warnings
6. **Cleanup** — confirm the container was removed

## Hard Rules

- **Read-only mounts by default.** Always mount project source with `:ro` unless the task explicitly requires write access. When write access is needed, mount only the specific output directory as read-write.
- **Always `--rm` for ephemeral runs.** Never leave disposable containers behind. Named persistent containers are the only exception.
- **Run as non-root by default.** `container run` defaults to root (uid=0). Always pass `-u "$(id -u):$(id -g)"` for user code. Use `-u root` only for package installation inside the container.
- **Never expose network without user consent.** Inbound: do not use `-p` (publish ports) unless the user asks. Outbound: containers have network access by default — be aware that untrusted code can exfiltrate mounted source. Avoid mounting sensitive files when running untrusted code with network access.
- **Temporary files go in `tmp/` under cwd.** Build contexts, Dockerfiles, and output directories belong there — never in `/tmp`.
- **Never mount credential directories into untrusted containers.** `~/.ssh`, `~/.aws`, `~/.config/gcloud`, and similar are off-limits — even read-only. For container machines, use `--home-mount none` with untrusted code.
- **Clean up images after build verification.** Run `container image rm <tag>` after ephemeral build-and-test cycles to avoid accumulating multi-GB images.
- **Verify `container` CLI exists first.** If missing, stop and tell the user.
- **Clean up on failure.** If a run fails or is interrupted, check `container ls -a` and remove stale containers before proceeding.

## References

- [examples](references/examples.md) — worked examples per workflow pattern

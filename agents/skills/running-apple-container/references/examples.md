# Examples

Worked examples for each workflow pattern. All commands assume `$(pwd)` is the project root.

## Ephemeral run: Python test suite

```bash
container run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd)":"$(pwd)":ro \
  -w "$(pwd)" \
  python:slim \
  sh -c "pip install -q --user -r requirements.txt && python -m pytest tests/ -v -o cache_dir=/tmp/pytest_cache"
```

## Ephemeral run: Node.js generated script

```bash
container run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd)":"$(pwd)":ro \
  -w "$(pwd)" \
  node:alpine \
  node script.js
```

## Ephemeral run: Go build verification

```bash
container run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd)":"$(pwd)":ro \
  -w "$(pwd)" \
  golang:alpine \
  go build ./...
```

## Ephemeral run: shell script with write output

When the command must produce output files, mount a separate writable directory:

```bash
mkdir -p tmp/container-output
container run --rm \
  -u "$(id -u):$(id -g)" \
  -v "$(pwd)":"$(pwd)":ro \
  -v "$(pwd)/tmp/container-output":/output \
  -w "$(pwd)" \
  alpine:latest \
  sh -c './generate.sh && cp dist/* /output/'
```

## Persistent dev container: multi-step debugging

```bash
# Start with source read-only, writable work dir
mkdir -p tmp/container-work
container run -d --name debug-env \
  -v "$(pwd)":"$(pwd)":ro \
  -v "$(pwd)/tmp/container-work":/work \
  -w "$(pwd)" \
  python:slim \
  sleep infinity

# Install debugging tools (root needed for package manager)
container exec -u root debug-env pip install ipdb

# Run tests
container exec debug-env python -m pytest tests/test_failing.py -v -o cache_dir=/work/pytest_cache

# Inspect state
container exec debug-env cat /work/debug-output.log

# Tear down
container stop debug-env && container rm debug-env
```

## Build verification: custom Dockerfile

```bash
mkdir -p tmp

cat > tmp/Dockerfile << 'DOCKERFILE'
FROM node:alpine
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build
CMD ["npm", "test"]
DOCKERFILE

container build -t project-verify -f tmp/Dockerfile .
container run --rm project-verify
container image rm project-verify
```

## Container machine: long-lived dev VM

```bash
# Create with no home mount (safe default)
container machine create ubuntu:latest --name dev-vm \
  --cpus 4 --memory 8G --home-mount none

# Install tools
container machine run -n dev-vm --root -- \
  sh -c "apt-get update && apt-get install -y build-essential"

# Run tests
container machine run -n dev-vm -- make test

# Tear down
container machine stop dev-vm && container machine delete dev-vm
```

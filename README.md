# caddy-custom

An opinionated set-up to get no telemetry Caddy Docker image with various sets
of plugins.

## How to build Docker image

As an example, you will need to fill the following variables:

- `REPO_REV`
- `PLUGINS`

See the example run below for better idea:

```bash
# For PLUGINS, replace all dots with hyphens as shown below
REPO_REV=v1.0.5
PLUGINS=http-filter
docker build . \
    --build-arg REPO_REV=${REPO_REV} \
    --build-arg PLUGINS=${PLUGINS}
```

## How to generate Travis script from template

You will need `tera`, which you can get by either of the following methods:

### Method 1

Get `cargo` which you can get by install from <https://rustup.rs/>.

Once `cargo` is available, run:

```bash
cargo install tera-cli --version=^0.4.0
```

This works for most major operating systems.

### Method 2

For Linux user, you can download Tera CLI v0.4 at
<https://github.com/guangie88/tera-cli/releases> and place it in `PATH`.

## How to generate updated plugins from template

You will need `python3` to apply the `update-plugins.py` script.

Additionally, you will need to install pip packages via:

```bash
python3 -m pip install beautifulsoup4 pyyaml requests
```

To generate a new `plugins.yml`, run:

```bash
./update-plugins-py > plugins.yml
```

This is generally more for updating `plugins.yml`, since there should always be
`plugins.yml` in the repo.

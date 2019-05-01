# caddy-custom

An opinionated set-up to get no telemetry Caddy Docker image with various sets
of plugins.

## How to generate Travis script from template

You will need `tera`, which you can get by either of the following methods:

### Method 1

Get `cargo` which you can get by install from <https://rustup.rs/>.

Once `cargo` is available, run:

```bash
cargo install tera-cli
```

This works for most major operating systems.

### Method 2

If you are a Linux user, simply download from:
<https://github.com/guangie88/tera-cli/releases>

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

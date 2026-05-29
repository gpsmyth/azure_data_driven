## Linting

### Installing tflint

```bash
brew tap terraform-linters/tap
brew install terraform-linters/tap/tflint
```

```bash
tflint --version

Run tflint --init to download necessary plugins

tflint --recursive
```

### tflint relocation

```bash
brew install tflint
```

originally didn't work as package was relocated from Homebrew-core due to [license restrictions](https://github.com/terraform-linters/tflint/pull/2531)

`homebrew-tflint` no longer exists, but `homebrew-tap` does.

Homebrew only knows about formulae in its own core repository by default. `brew tap` adds a **third-party repository** of additional formulae that Homebrew doesn't officially maintain.

Think of it like this:

| Command | What it does |
| --- | --- |
| `brew install tflint` | Searches Homebrew's own core repo only |
| `brew tap terraform-linters/tap` | Adds terraform-linters' own repo as an extra source |
| `brew install terraform-linters/tap/tflint` | Installs `tflint` specifically from that tapped repo |
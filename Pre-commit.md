## Pre-commit hooks

### What is a pre-commit hook?

It's a script that runs **automatically before every** `git commit`. If any check fails, the commit is blocked until you fix the issue. So rather than remembering to run `tflint` and `checkov` manually, they just run automatically every time you try to commit.

```bash
git commit -m "my change"
       ↓
runs tflint  → fails? commit blocked
runs checkov → fails? commit blocked
       ↓
commit succeeds only if all checks pass
```

### Setup using the pre-commit framework

The cleanest way on macOS is via the `pre-commit` framework:

Then in the root of your repo, create a `.pre-commit-config.yaml` file:

```bash
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.96.1
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
        args:
          - --args=--recursive
      - id: terraform_checkov
        args:
          - --args=--directory .
```

The sample lines of
```bash
 args:
          - --args=--recursive
```

uses `--args` so that you are telling pre-commit
> "Pass `--recursive` to TFLint, not to pre‑commit."

Without the `--args=` prefix, pre‑commit thinks `--recursive` is meant for the hook itself — and ignores it.

Then install the hook into your local repo:
```bash
pre-commit install
```

which produces
```bash
pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

From this point on, every git commit will automatically run `terraform fmt`, `terraform validate`, `tflint`, and `checkov` against both your `root` and `modules/network`.

### Important things to know

It only runs on staged files by default. So only files you've `git add`ed are checked, not the whole repo. To run against everything manually:

```bash
pre-commit run --all-files
```

**It's local only.** The hook lives in `.git/hooks/` which is not committed to the repo, so each collaborator needs to run `pre-commit install` themselves after cloning. The `.pre-commit-config.yaml` file however is committed, so the configuration is shared.
**You can skip it in an emergency with:**
```bash
git commit -m "my message" --no-verify
```
Though obviously use that sparingly.

### Webhook thoughts

- Investigating

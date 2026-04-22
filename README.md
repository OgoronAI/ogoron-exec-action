# Ogoron Exec Action

Install a released Linux Ogoron bundle and execute one or more explicit commands in
the target repository.

This is the low-level escape hatch action. Use it when `setup` or later opinionated
actions are too narrow for the workflow you need.

Current scope:
- `ubuntu-*` runners only
- Linux release assets only
- executes commands under `bash` with `set -euo pipefail`

## Required environment

Provide secrets via workflow `env`, not action inputs.

- `OGORON_REPO_TOKEN`
- `OGORON_LLM_API_KEY` when BYOK access is required

Get your Ogoron repository token in the product UI:

- https://app.ogoron.ai/

## Inputs

| Input | Required | Default | Description |
| --- | --- | --- | --- |
| `commands` | yes |  | Multiline shell commands to execute. |
| `working-directory` | no | `.` | Repository directory where commands should run. |
| `cli-version` | no | `5.2.0` | Ogoron CLI release version to download. Versions older than `5.2.0` are rejected. |
| `download-url` | no |  | Explicit Linux bundle URL override. Useful for prereleases or mirrors. |

## Outputs

| Output | Description |
| --- | --- |
| `ogoron-bin` | Absolute path to the downloaded Ogoron executable. |

## Example

```yaml
name: Ogoron Exec

on:
  workflow_dispatch:

jobs:
  ogoron-exec:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Run Ogoron commands
        uses: OgoronAI/ogoron-exec-action@v1
        env:
          OGORON_REPO_TOKEN: ${{ secrets.OGORON_REPO_TOKEN }}
          OGORON_LLM_API_KEY: ${{ secrets.OGORON_LLM_API_KEY }}
        with:
          commands: |
            ogoron --version
            ogoron init --target-repo-path .
```

## Notes

- The action adds the downloaded runtime directory to `PATH`.
- Both `ogoron` and `ogoron-nuitka` are available during command execution.
- Command failures fail the step, except where your own shell logic handles them.

## Related actions

- [`Ogoron Setup`](https://github.com/OgoronAI/ogoron-setup-action) to bootstrap a repository before regular CI usage
- [`Ogoron Generate`](https://github.com/OgoronAI/ogoron-generate-action) for opinionated test artifact generation
- [`Ogoron Run`](https://github.com/OgoronAI/ogoron-run-action) for opinionated test execution
- [`Ogoron Heal`](https://github.com/OgoronAI/ogoron-heal-action) for opinionated recovery flows

## Recommended flow

Use `exec` when the higher-level actions are too narrow and you need direct control over Ogoron commands inside a workflow. Prefer `setup`, `generate`, `run`, and `heal` first, and fall back to `exec` only for custom orchestration.

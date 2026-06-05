## Creating a Web Hoook

### Use case

- We want to be notified in Slack when a github push event has occurred as shown

```text
git push to GitHub
       ↓
GitHub webhook fires
       ↓
Slack Incoming Webhook URL receives it
       ↓
Message appears in your Slack channel
```

### Steps involved

Step 1 — Create a Slack App and Incoming Webhook

1. Go to [api.slack.com/apps](api.slack.com/apps)
1. Click Create New App → From scratch
1. Name it something like GitHub Notifier, select your gerrys_slack_test workspace
1. On the left sidebar click Incoming Webhooks
1. Toggle Activate Incoming Webhooks to On
1. Click Add New Webhook to Workspace
1. Choose a channel (e.g. I choose #github-commits channel)
1. Click Allow
1. Copy the webhook URL — it looks like:

```text
https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
```

---

Step 2 — Add the webhook to GitHub

1. Go to your repo: github.com/gpsmyth/azure_data_driven
1. Click Settings → Webhooks → Add webhook
1. Fill in:

| Field | Value |
| --- | --- |
| Payload URL | your Slack webhook URL from Step 1 |
| Content type | application/json |
| Secret | leave blank for now |
| Events | Select Just the push event |

4. Click Add webhook

---

Step 3 — Test it

```bash
# Make a small change and push
git add .
git commit -m "Testing Slack webhook"
git push origin main
```
### Trouble-shooting

- When observing the GHAs I note a `400` response from push and a ping event
- It means GitHub is successfully sending the webhook to Slack, but Slack is rejecting it. This is a formatting issue — Slack's Incoming Webhooks expect a specific JSON format with a `text` field, but GitHub sends its own raw JSON payload which Slack doesn't understand.

#### The problem

```bash
GitHub sends:  {"ref": "refs/heads/main", "commits": [...]}  ← GitHub format
Slack expects: {"text": "some message"}                       ← Slack format
```

They're incompatible without a translator in between.

Two Options exist and here I progress with the manual webhook route
- For this, I need a a middleware layer to translate — the two common options are:
  - Option 1 — GitHub Actions (no extra service needed):

```yml
  # .github/workflows/slack-notify.yml
name: Slack Notification
on: [push]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Send Slack notification
        uses: slackapi/slack-github-action@v1.27.0
        with:
          payload: |
            {
              "text": "Push to ${{ github.repository }} by ${{ github.actor }} on branch ${{ github.ref_name }}\nCommit: ${{ github.event.head_commit.message }}"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

Then add your Slack webhook URL as a GitHub secret:

- Go to your repo **Settings → Secrets and variables → Actions**
- Click **New repository secret**
- Name: `SLACK_WEBHOOK_URL`
- Value: your webhook URL from Slack

I choose this option

Option 2 — Delete the current GitHub webhook (to avoid confusion) and use the Slack app instead.

Via Slack:
1. In my gerrys_slack_test workspace, go to [slack.com/apps](slack.com/apps) and search GitHub
1. Install the GitHub app by GitHub
1. Once installed, in your #github-commits channel type:
```text
/github subscribe gpsmyth/azure_data_driven commits:*
```
This handles all the translation automatically and gives nicely formatted messages like:
```text
gpsmyth pushed to main
  • Added costings — view commit
  • Updated pre-commit config — view commit
```

### Final Output

- What a `git push` produces:

![Output of git push](./images/slack_github.png)

# Automated Deployment Pipeline – Setup Guide  
_Vuet App • Flutter / Firebase • GitHub Actions_  

> This guide walks you through **one-time configuration** of the CI/CD pipeline that automatically  
> 1) builds your Flutter web app and 2) deploys it to Firebase Hosting whenever you push to **`main`**.

---

## 1  Prerequisites
| Tool | Minimum Version | Notes |
|------|-----------------|-------|
| Flutter SDK | 3.16.0 (stable) | Installed on local machine for manual testing. |
| Firebase CLI | 12.x | `npm i -g firebase-tools` |
| GitHub CLI (gh) | Latest | Optional for secret creation. |
| Admin access to | • Firebase project `vuettttt`<br>• GitHub repo `Qualiasolutions/vuetapp` | |

---

## 2  Create a Firebase Service Account JSON
1. Open **Firebase Console → Project Settings → Service Accounts**.  
2. Click **“Generate new private key”** ➜ **Download** the JSON file.  
3. Rename it locally to `firebase-service-account.json` (for clarity).  
   - _Screenshot A: “Generate new private key” button_

---

## 3  Add GitHub Secrets
Secrets live in **GitHub Repo → Settings → Secrets → Actions**.

| Secret Key | Value | Required For |
|------------|-------|--------------|
| `FIREBASE_SERVICE_ACCOUNT` | **Entire JSON** content from step 2 | Deploy workflow |
| `SLACK_WEBHOOK` | Slack Incoming-Webhook URL (optional) | Success/Fail notifications |
| `CODECOV_TOKEN` | Repo token from Codecov (optional) | Coverage upload |

### 3.1  Using GitHub UI
1. Click **“New repository secret”**.  
2. Paste the key name e.g. `FIREBASE_SERVICE_ACCOUNT`.  
3. Paste the JSON (everything, including `{…}`) into the value box.  
   - _Screenshot B: “New secret” dialog_

### 3.2  Using GitHub CLI (optional)
```bash
gh secret set FIREBASE_SERVICE_ACCOUNT < firebase-service-account.json
gh secret set SLACK_WEBHOOK - <<<'https://hooks.slack.com/services/T000/B000/XXXX'
```

---

## 4  Understand the Workflows
File | Purpose | Trigger |
|-----|---------|---------|
| `.github/workflows/ci.yml` | **CI** – format, analyze, test, _no deploy_ | every push / PR |
| `.github/workflows/deploy.yml` | **CD** – build & deploy to Firebase | push to **`main`** only |

> **💡 Tip:** PRs never deploy; they just run CI. Merging → `main` kicks off the deploy job.

---

## 5  Test the Pipeline End-to-End

### 5.1  Dry-Run (CI Only)
```bash
# create feature branch
git checkout -b ci-test
touch dummy.txt && git add . && git commit -m "CI dry-run"
git push -u origin ci-test
```
Open the PR ➜ **Checks** tab should show **“Validate Code”** job passing.

### 5.2  Staging Deploy (Optional)
1. Modify `.github/workflows/deploy.yml` temporarily:  
   ```yaml
   channelId: staging
   ```
2. Push a commit to **`main`**.  
3. GitHub Actions page ➜ job **Build and Deploy** should:  
   * run Flutter build (`flutter build web`)  
   * deploy to **`staging`** channel (preview URL displayed in logs)

### 5.3  Production Deploy
Revert `channelId` to `live` (already default).  
Merge / push to **`main`** ➜ automatic production hosting update.

---

## 6  Troubleshooting 📑

| Symptom | Checklist |
|---------|-----------|
| **`firebase : command not found`** | Workflow YAML missing `FirebaseExtended/action-hosting-deploy@v0` step or wrong `node` version. |
| **❌ “Authentication Error”** | `FIREBASE_SERVICE_ACCOUNT` JSON malformed (paste again). |
| **Flutter build fails (missing SDK)** | `subosito/flutter-action` version typo or channel mismatch. |
| **Deploy job skipped** | Pushed to non-`main` branch; ensure branch name & trigger condition. |
| **404 on `/build/web`** | Build artifact folder path changed – confirm `flutter build web` succeeded. |

_Logs > “Artifacts and Paths”_ show exact directory used.

---

## 7  Security Considerations 🔒
1. **Least-Privilege:**  
   The service account should have **Hosting Admin** and **Storage Admin** (for uploads) only.  
2. **Secret Scope:**  
   GitHub Secrets are encrypted; avoid echoing them in workflow logs.  
3. **Pull-Request Safety:**  
   Workflows using `FIREBASE_SERVICE_ACCOUNT` run **only** on pushes to `main` (not PRs) via `if: github.ref == 'refs/heads/main'`.  
4. **Timeouts & Resource Limits:**  
   Jobs cancel after 15 min to prevent crypto-mining abuse.  
5. **Manual Overrides:**  
   If needed, disable deployments by adding a branch protection rule or temporarily commenting the `Deploy to Firebase` step.

---

## 8  Maintenance Tips
* **Rotate** the service-account key every 90 days.  
* Keep Flutter & Firebase CLI versions in YAML files up-to-date.  
* Add additional Slack channels or Teams webhooks by duplicating the notification steps.  
* Use **`firebase target:apply hosting <alias> <site>`** if you run multiple sites from one project.

---

### 🎉  You’re Done!  
Your repo now auto-tests, builds, and deploys on every merge to **`main`** – hands-free shipping!

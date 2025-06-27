# 🚀 Vuet — Deployment Pipeline README

## 1&nbsp;·&nbsp;What the Automation Does
* **CI (Continuous Integration)** – On *every push / PR* the `CI` job  
  runs `flutter analyze`, unit-tests, code-gen, and a **fast web build** to catch errors early.
* **CD (Continuous Deployment)** – On *push to `main`* the `Deploy` job  
  performs a **full-release build** (`flutter build web --release`) and  
  deploys the artifact to **Firebase Hosting – live channel**.

Result: merge → minutes later your production site is automatically updated.

---

## 2&nbsp;·&nbsp;How to Trigger Deployments
| Action | Branch | Result |
|--------|--------|--------|
| Push / merge PR | **any** | CI runs *(no deploy)* |
| Push / merge PR → **`main`** | `main` | CI + CD → Firebase Hosting update |

To deploy a hot-fix without code review:  
```bash
git checkout main
git pull
# commit / amend
git push           # <— triggers Deploy
```

---

## 3&nbsp;·&nbsp;Further Reading
* **Detailed Setup Guide** – [`docs/deployment-setup.md`](docs/deployment-setup.md)  
  Step-by-step for service-account secrets, Slack hooks, etc.
* **End-to-End Spec** – [`docs/category-migration-analysis.md`](docs/category-migration-analysis.md)  
  Overall migration & architecture context.

---

## 4&nbsp;·&nbsp;Status Badges
| Workflow | Status |
|----------|--------|
| CI (all branches) | ![CI](https://github.com/Qualiasolutions/vuetapp/actions/workflows/ci.yml/badge.svg) |
| Deploy (main) | ![Deploy](https://github.com/Qualiasolutions/vuetapp/actions/workflows/deploy.yml/badge.svg) |

Click a badge for full logs.

---

## 5&nbsp;·&nbsp;Emergency Procedures

### 🔄 Rollback
1. Identify the last good commit SHA (`abcd123`).  
2. ```bash
   git checkout main
   git revert --no-edit abcd123..HEAD   # reverts all bad commits
   git push                              # triggers automatic redeploy
   ```
3. Confirm Hosting version in Firebase console.

### ⏸ Temporarily Disable Auto-Deploy
* **GitHub:**  
  *Settings → Branches → Branch protection* → Require PRs → prevent direct pushes to `main`.
* **Workflow file:**  
  Comment the “Deploy to Firebase” step in `.github/workflows/deploy.yml` and push.

---

## 6&nbsp;·&nbsp;Who to Contact
| Topic | Owner | Contact |
|-------|-------|---------|
| CI/CD pipelines | Dev Infra Team | `devops@vuet.ai` |
| Firebase hosting | Front-End Team | `frontend@vuet.ai` |
| Production outages | On-call SRE | `+#sre‐pager` (Slack) |

*When in doubt, open an issue and tag the relevant team.*

---

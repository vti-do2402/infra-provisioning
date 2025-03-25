# 🧪 mock-project

A Terraform-based infrastructure automation project with CI/CD integration using GitHub Actions.

---

## 📁 Repository Structure

```
.
├── .github/           # GitHub Actions workflows & reusable composite actions (setup, plan)
├── backend/           # Terraform configuration for remote backend (S3 + DynamoDB)
├── environments/      # Environment-specific folders (e.g., dev, prod)
├── global/            # Global providers and shared configuration
├── runner/            # Provisions GitHub self-hosted runner and SSH key pairs
```

---

## 🔧 Prerequisites

- ✅ An AWS Account with CLI access configured
- ✅ [Terraform v1.11.2](https://releases.hashicorp.com/terraform/1.11.2)

---

## 🚀 Getting Started

### 1️⃣ After Cloning the Private Repository

```bash
git clone git@github.com:vti-do2402/infra-provisioning.git
cd mock-project
```

### 2️⃣ Create `terraform.tfvars` for Each Terraform Folder

Use the provided `terraform.tfvars.example` to structure your variables for:

- `backend/`
- `runner/`
- `environments/dev/`
- `environments/prod/`

### 3️⃣ Execution Order (Manual)

Run the following in each folder:

#### 🟣 Backend (S3 + DynamoDB for remote state)

```bash
cd backend
terraform init
terraform plan
terraform apply
```

#### 🔵 Runner (for CI/CD + SSH keypair)

```bash
cd ../runner
terraform init
terraform plan
terraform apply
```

#### 🟢 Environment (Dev or Prod) (Optional for local provisioninng)

```bash
cd ../environments/dev  # or prod
terraform init
terraform plan
terraform apply
```

---

## ⚙️ CI/CD Pipelines (GitHub Workflows)

| Workflow    | Trigger                              | Description                                                        |
| ----------- | ------------------------------------ | ------------------------------------------------------------------ |
| **Plan**    | `pull_request (opened or reopened)`  | Validates and generates Terraform plan for both `dev` and `prod`   |
| **Apply**   | `push to main` (i.e., PR merge)      | Applies the approved plan automatically                            |
| **Destroy** | `workflow_dispatch` (manual trigger) | Requires user input to select environment and confirm destroy plan |

---

## 📝 Notes

- All state is stored remotely (S3) with locking via DynamoDB.
- EC2 SSH keypair is stored securely during CI/CD via GitHub Secrets or external storage (not committed).
- No open security group to `0.0.0.0/0` — whitelist `admin_ip` via tfvars.

---

## 🧑‍💻 Maintainer

**Quentin Vu**  
📧 s3981278@rmit.edu.vn

---

## 📄 License

For academic/demonstration purposes only.

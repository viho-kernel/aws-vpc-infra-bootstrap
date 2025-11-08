# AWS VPC Project – Terraform Implementation

## 📌 Project Overview

This project provisions a complete AWS networking environment using **Terraform**, following real-world, industry-level standards. It includes a custom VPC, public subnets, EC2 instances, an Application Load Balancer, internet connectivity, and an S3 bucket to store build artifacts.

This setup is suitable for **DevOps**, **Cloud Engineering**, and **Infrastructure-as-Code (IaC)** learning and showcases your capability to build scalable AWS architectures.

---

## ✅ Architecture Components

### 1. **VPC**

* Custom VPC created using CIDR provided by `var.aws_cidr`.
* Enables complete isolation for project resources.

### 2. **Public Subnets (x2)**

* Two public subnets spread across different Availability Zones.
* Auto-assign public IP enabled for internet-facing resources.

### 3. **Internet Gateway**

* Allows Internet connectivity for public-facing resources.

### 4. **Route Table & Associations**

* A public route table routing all outbound internet traffic through the IGW.
* Each public subnet associated with the route table.

### 5. **Security Group**

* Dynamically created ingress rules using `var.ingress_rules`.
* Fully open egress for outbound traffic.

### 6. **EC2 Instances (x2)**

* Two web/application servers.
* Instances use user-data scripts provided via `var.user_data`.
* Each instance sits inside public subnets behind a load balancer.

### 7. **Application Load Balancer**

* ALB deployed across public subnets.
* HTTP listener forwards traffic to a target group.
* Instances registered as targets.

### 8. **S3 Bucket**

* Artifact bucket for build/deployment storage.
* Public access control disabled as per requirement (not recommended for production).

---

## 📁 Project Structure

```
terraform-project/
├── main.tf            # Core resources (VPC, subnets, IGW, route tables, SG, EC2)
├── variables.tf       # Input variables such as VPC CIDR, subnets, instance types
├── provider.tf        # AWS provider configuration
├── data.tf            # Data sources (AZs, etc.)
├── output.tf          # Outputs such as VPC ID, ALB DNS, instance public IPs
├── locals.tf          # Local variables such as AZ naming
├── user-data/         # User-data scripts for EC2 bootstrap
└── README.md          # Documentation
```

---

## 🚀 How to Deploy

### **1. Install Required Tools**

* Terraform v1.0+
* AWS CLI
* IAM user with EC2, VPC, S3, and ELB permissions

---

### **2. Configure AWS Credentials**

```bash
aws configure
```

---

### **3. Initialize Terraform**

```bash
terraform init
```

---

### **4. Validate the Configuration**

```bash
terraform validate
```

---

### **5. Preview the Infrastructure**

```bash
terraform plan
```

---

### **6. Apply and Deploy**

```bash
terraform apply -auto-approve
```

---

### **7. Destroy (Optional)**

```bash
terraform destroy -auto-approve
```

---

## 📤 Pushing to GitHub

Follow these steps inside your project folder:

```bash
git init
git add .
git commit -m "Initial VPC project commit"
git branch -M main
git remote add origin https://github.com/<your-username>/<repo-name>.git
git push -u origin main
```

---

## 📘 Outputs

After deployment, Terraform will provide:

* VPC ID
* Subnet IDs
* Load Balancer DNS Name (use this to test your app)
* EC2 Public IPs

---

## 🛡️ Best Practices (Included)

✅ Resource tagging for visibility and cost tracking
✅ Modular-ready structure
✅ Dynamic rules for security groups
✅ Multi-AZ design for high availability

---

## 📝 Notes

* S3 bucket public access is disabled **(not recommended for production)**.
* ALB name limited to 32 characters.
* User-data files must exist in `var.user_data` list.

---

## 📄 License

This project is released under the MIT License.

---

## ⭐ Contribute

Feel free to fork the repo, open issues, or submit PRs.

---

## ✨ Author

**Vihari Reddy**
Cloud & DevOps Engineer – passionate about AWS, IaC, and scalable architectures.

---


Happy Cloud and DevOps! ☁️🚀

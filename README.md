# c:\dev\repos\IaC\README.md
# Terraform Project Structure

This repository is structured to manage infrastructure as code using Terraform, with a focus on reusability and environment separation.

## Directory Layout

-   `environments/`: This directory contains the top-level configurations for each environment (e.g., `dev`, `staging`, `prod`).
    -   Each subdirectory in `environments/` represents a single environment.
    -   `main.tf`: The main entrypoint for the environment. It defines the provider and calls the reusable modules.
    -   `variables.tf`: Contains variable declarations for the environment.
    -   `outputs.tf`: Defines the output values for the environment.

-   `modules/`: This directory contains reusable Terraform modules.
    -   Each subdirectory is a self-contained module for a specific piece of infrastructure (e.g., `network`, `vm`, `database`).
    -   Modules are designed to be generic and reusable across different environments.
    -   They have their own `main.tf`, `variables.tf`, and `outputs.tf`.

## How to Use

1.  **Initialize Terraform**:
    Navigate to the specific environment directory you want to work with and run `terraform init`.
    ```sh
    cd environments/dev
    terraform init
    ```

2.  **Plan and Apply**:
    Run `terraform plan` to see the execution plan and `terraform apply` to create the infrastructure.
    ```sh
    terraform plan
    terraform apply
    ```

terraform {
  backend "s3" {
    # Configuration provided via backend.hcl at init time
    # See: terraform init -backend-config=backend.hcl
    key = "placeholder" # Overridden by backend-config
  }
}

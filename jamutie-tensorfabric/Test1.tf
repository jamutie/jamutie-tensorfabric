terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "greeting" {
  type        = string
  description = "Message to write to the output file."
  default     = "Hello from tensorfabric!"
}

variable "fabric_nodes" {
  type        = list(string)
  description = "Sample list of fabric node names."
  default     = ["spine-01", "spine-02", "leaf-01", "leaf-02"]
}

resource "local_file" "test" {
  filename = "${path.module}/test_output.txt"
  content  = <<-EOT
    ${var.greeting}

    Fabric nodes:
    %{for n in var.fabric_nodes ~}
      - ${n}
    %{endfor ~}
  EOT
}

output "node_count" {
  description = "Number of fabric nodes."
  value       = length(var.fabric_nodes)
}

output "output_file_path" {
  description = "Path of the generated test output file."
  value       = local_file.test.filename
}

variable "name" {
  description = "A name to render"
  type        = string
}

# %{if <condition>}<trueval>%{endif}
# If run tf apply -var name="World" with this, you get the output "Hello, World".
# Sticking the trueval or (unnamed) into the place of the output.
output "if_else_directive" {
  value = "Hello, %{ if var.name != "" }${var.name}%{ else }(unnamed)%{ endif }"
}

variable "names" {
  description = "Names to render"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

output "for_directive" {
  value = <<EOF
%{ for name in var.names }
  ${name}
%{ endfor }
EOF
}

# Can use "~" to strip or consume all of the whitespace in the output.
output "for_directive_strip_marker" {
  value = <<EOF
%{~ for name in var.names }
  ${name}
%{~ endfor }
EOF
}

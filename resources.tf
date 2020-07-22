#
# This part of the example shows creating Groups with dynamic membership
# criteria
#

# All WEB VMs
resource "nsxt_policy_group" "uag_horizon" {
  display_name = "Terraform - UAG_Horizon_VMs"
  description  = "Group consisting of Horizon VMs"
  criteria {
    condition {
      member_type = "VirtualMachine"
      operator    = "CONTAINS"
      key         = "Tag"
      value       = "uag"
    }
  }
  tag {
    scope = "horizon"
    tag   = "uag"
  }
}

# Static Group of IP addresses
resource "nsxt_policy_group" "ip_set" {
  display_name = "external_IPs"
  description  = "Group containing all external IPs"
  criteria {
    ipaddress_expression {
      ip_addresses = ["10.0.50.26", "10.5.99.180"]
    }
  }
  tag {
    scope = "horizon"
    tag   = "ipset"
  }
}

#
# An example for Service for App that listens on port 8443
#
resource "nsxt_policy_service" "horizon_service" {
  display_name = "app_service_8443"
  description  = "Service for Horizon that listens on port 8443"
  l4_port_set_entry {
    description       = "TCP Port 8443"
    protocol          = "TCP"
    destination_ports = ["8443"]
  }
}

#
# Here we have examples of create data sources for Services
#
data "nsxt_policy_service" "https" {
  display_name = "HTTPS"
}

data "nsxt_policy_service" "ssh" {
  display_name = "SSH"
}

#
# In this section, we have example to create Firewall sections and rules
# All rules in this section will be applied to VMs that are part of the
# Gropus we created earlier
#
resource "nsxt_policy_security_policy" "firewall_section" {
  display_name = "Horizon Section"
  description  = "Firewall section created by Terraform"
  scope        = [nsxt_policy_group.uag_horizon.path]
  category     = "Application"
  locked       = "false"
  stateful     = "true"

  # Allow communication to any VMs only on the ports defined earlier
  rule {
    display_name       = "Allow HTTPS"
    description        = "In going rule"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    destination_groups = [nsxt_policy_group.uag_horizon.path]
    services           = [data.nsxt_policy_service.https.path]
  }

  rule {
    display_name       = "Allow SSH"
    description        = "In going rule"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    destination_groups = [nsxt_policy_group.uag_horizon.path]
    services           = [data.nsxt_policy_service.ssh.path]
  }

  # UAG horizon to UAG horizon communication
  rule {
    display_name       = "Allow Web to App"
    description        = "Web to App communication"
    action             = "ALLOW"
    logged             = "false"
    ip_version         = "IPV4"
    source_groups      = [nsxt_policy_group.uag_horizon.path]
    destination_groups = [nsxt_policy_group.uag_horizon.path]
    services           = [nsxt_policy_service.horizon_service.path]
  }

  # Allow External IPs to communicate with VMs
  rule {
    display_name       = "Allow Infrastructure"
    description        = "Allow DNS and Management servers"
    action             = "ALLOW"
    logged             = "true"
    ip_version         = "IPV4"
    source_groups      = [nsxt_policy_group.ip_set.path]
    destination_groups = [nsxt_policy_group.uag_horizon.path]
  }

  # Allow VMs to communicate with outside
  rule {
    display_name  = "Allow out"
    description   = "Outgoing rule"
    action        = "ALLOW"
    logged        = "true"
    ip_version    = "IPV4"
    source_groups = [nsxt_policy_group.uag_horizon.path]
  }

  # Reject everything else
  rule {
    display_name = "Deny ANY"
    description  = "Default Deny the traffic"
    action       = "REJECT"
    logged       = "true"
    ip_version   = "IPV4"
  }
}

# @summary Configure devices and mounts
#
# @param lvs sets LVs to manage
class disks (
  Hash[String, Hash] $lvs = {},
) {
  case $facts['os']['family'] {
    'Archlinux': { include disks::systemd }
    'Arch': { include disks::systemd }
    default: { fail("Hostname module does not support ${facts['os']['family']}") }
  }
}

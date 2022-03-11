# @summary Configure devices and mounts
#
class disks (
) {
  case $facts['os']['family'] {
    'Archlinux': { include disks::systemd }
    'Arch': { include disks::systemd }
    default: { fail("Hostname module does not support ${facts['os']['family']}") }
  }
}

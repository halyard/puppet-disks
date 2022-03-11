##
# Definitions for systemd
class disks::systemd () {
  mount { '/':
    ensure  => present,
    device  => $facts['mountpoints']['/']['device'],
    atboot  => true,
    fstype  => $facts['mountpoints']['/']['filesystem'],
    options => 'rw,relatime',
    dump    => '0',
    pass    => '1',
  }

  resources { 'mount':
    purge => true,
  }
}

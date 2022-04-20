##
# Definitions for systemd
class disks::systemd () {
  mounttab { '/':
    ensure  => present,
    device  => $facts['mountpoints']['/']['device'],
    atboot  => true,
    fstype  => $facts['mountpoints']['/']['filesystem'],
    options => ['rw', 'relatime'],
    dump    => '0',
    pass    => '1',
  }

  if $facts['partitions']['/dev/mmcblk0p1'] {
    mounttab { '/':
      ensure  => present,
      device  => '/dev/mmcblk0p1',
      atboot  => true,
      fstype  => 'vfat',
      options => ['defaults'],
      dump    => '0',
      pass    => '0',
    }
  }

  resources { 'mounttab':
    purge => true,
  }
}

# @summary Definitions for systemd
class disks::systemd () {
  mount { '/':
    ensure  => mounted,
    device  => $facts['mountpoints']['/']['device'],
    atboot  => true,
    fstype  => $facts['mountpoints']['/']['filesystem'],
    options => 'rw,relatime',
    dump    => '0',
    pass    => '1',
  }

  if $facts['partitions']['/dev/mmcblk0p1'] {
    mount { '/boot':
      ensure  => mounted,
      device  => '/dev/mmcblk0p1',
      atboot  => true,
      fstype  => 'vfat',
      options => ['defaults'],
      dump    => '0',
      pass    => '0',
    }
  }

  $disks::lvs.each | String $name, Hash $options | {
    disks::lv { $name:
      * => $options,
    }
  }
}

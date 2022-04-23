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
    mounttab { '/boot':
      ensure  => present,
      device  => '/dev/mmcblk0p1',
      atboot  => true,
      fstype  => 'vfat',
      options => ['defaults'],
      dump    => '0',
      pass    => '0',
    }
  }

  $disk::lvs.each | String $name, Hash $options | {
    exec { "/usr/bin/lvcreate -L '${options['size']}' -n '${name}' '${options['vg']}'":
      creates => "/dev/${options['vg']}/${name}",
    }

    -> exec { "/usr/bin/mkfs -t '${options['fstype']}' '/dev/${options['vg']}/${name}'":
      onlyif => "/usr/bin/file -sLb '/dev/${options['vg']}/${name}' | grep '^data$'",
    }

    if $options['mount'] {
      file { $options['mount']:
        ensure => directory,
      }

      -> mounttab { $options['mount']:
        ensure  => present,
        device  => "/dev/${options['vg']}/${name}",
        atboot  => true,
        fstype  => $options['fstype'],
        options => $options['fsoptions'],
        dump    => '0',
        pass    => '2',
      }
    }
  }

  resources { 'mounttab':
    purge => true,
  }
}

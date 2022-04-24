# @summary Create an LV with a filesystem
#
# @param size sets size of LV
# @param vg sets VG to use for LV
# @param fstype sets filesystem type
# @param fsoptions sets /etc/fstab mount options for the LV
# @param mount sets mountpoint for LV (not mounted if undef)
# @param lvname (namevar) sets name for LV
define disks::lv (
  String $size,
  String $vg,
  Optional[String] $fstype = undef,
  Optional[String] $fsoptions = undef,
  Optional[String] $mount = undef,
  String $lvname = $title,
) {
  exec { "/usr/bin/lvcreate -L '${size}' -n '${lvname}' '${vg}'":
    creates => "/dev/${vg}/${lvname}",
  }

  if $fstype {
    exec { "/usr/bin/mkfs -t '${fstype}' '/dev/${vg}/${lvname}'":
      onlyif  => "/usr/bin/file -sLb '/dev/${vg}/${lvname}' | grep '^data$'",
      require => Exec["/usr/bin/lvcreate -L '${size}' -n '${lvname}' '${vg}'"],
    }
  }

  if $mount {
    mount { $mount:
      ensure  => mounted,
      device  => "/dev/${vg}/${lvname}",
      atboot  => true,
      fstype  => $fstype,
      options => $fsoptions,
      dump    => '0',
      pass    => '2',
    }
  }
}

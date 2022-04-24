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

  $lv_path = "/dev/${vg}/${lvname}"

  exec { "Create LV ${lv_path}":
    command => "/usr/bin/lvcreate -y -L '${size}' -n '${lvname}' '${vg}'",
    creates => $lv_path,
  }

  if $fstype {
    exec { "Create FS on LV ${lv_path}":
      command => "/usr/bin/mkfs -t '${fstype}' '${lv_path}'",
      onlyif  => "/usr/bin/file -sLb '${lv_path}' | grep '^data$'",
      require => Exec["Create LV ${lv_path}"],
    }
  }

  if $mount {
    mount { $mount:
      ensure  => mounted,
      device  => $lv_path,
      atboot  => true,
      fstype  => $fstype,
      options => $fsoptions,
      dump    => '0',
      pass    => '2',
    }
  }
}

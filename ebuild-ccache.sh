#
# These functions enable/disable building gentoo packages using ccache and
# a ramdisk.  This is useful for debug ebuilds with large compilation times.
#
# Source this file from your .profile
#
# Assumes that ramdisk is defined in /etc/fstab as:
# tmpfs /mnt/ebuild-ccache tmpfs defaults,nodev,nosuid,noexec,nodiratime,noauto,uid=250,gid=250,size=2G   0 0
# 
# The cache size must be at least 1G
# The cache size is truncated to the lowest integer value in gigs
#
# ccache_disable does not unmount the ramdisk.
#
ccache_enable () 
{ 
  local mountpoint='/mnt/ebuild-ccache'

  if [ "$(stat -c '%m' $mountpoint 2>/dev/null)" != "$mountpoint" ]; then
      mount "$mountpoint"
  fi

  if [ "$(stat -c '%m' $mountpoint 2>/dev/null)" != "$mountpoint" ]; then
    echo 'No ramdisk available for ccache portage builds' >&2
    return 1
  else
    local -i blocks_per_gib=$((1073741824 / $(stat -f -c '%S' $mountpoint)))
    local -i ccache_size=$(($(stat -f -c '%b' $mountpoint) / $blocks_per_gib));

    if [ $ccache_size -lt 1 ]; then
      echo 'The cache size must be at least 1G' >&2
      return 1
    fi

    export FEATURES="ccache";
    export CCACHE_SIZE="${ccache_size}G"
    export CCACHE_DIR="$mountpoint";

    if [ -z "${OLD_PS1:-}" ]; then
      OLD_PS1="$PS1"
      PS1="(ccache) $PS1"
    fi

    if [ -z "${OLD_PATH:-}" ]; then
      OLD_PATH="$PATH"
      PATH="/usr/lib/ccache/bin:$PATH"
    fi
  fi
}
export -f ccache_enable

ccache_disable () 
{ 
  unset FEATURES;
  unset CCACHE_SIZE;
  unset CCACHE_DIR

  if [ -n "${OLD_PS1:-}" ]; then
    PS1=$OLD_PS1
    unset OLD_PS1
  fi

  if [ -n "${OLD_PATH:-}" ]; then
    PATH=$OLD_PATH
    unset OLD_PATH
  fi
}
export -f ccache_disable

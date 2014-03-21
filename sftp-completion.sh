#!/bin/bash # for correct bash/vim highlighting

if [ -n "${BASH_VERSION:-}" ]; then
  # This dynamically determines the hosts
  _sftp_completion()
  {
      local cur names
      cur="${COMP_WORDS[COMP_CWORD]}"
      COMPREPLY=()

      if [ -e ~/.ssh/config ]; then
        names=$(egrep '^[[:space:]]*Host[[:space:]]+' ~/.ssh/config  | sed -re 's/^[[:space:]]*Host[[:space:]]*//g; s/[[:space:]]+/\n/g' | sort | uniq)

        COMPREPLY=( $(compgen -f -W "${names}" -- ${cur}) )
      fi

      return 0
  }

  complete -o filenames -F _sftp_completion sftp

  # this statically determines the hosts
  #complete -W "$(egrep '^[[:space:]]*Host[[:space:]]+' ~/.ssh/config  | sed -re 's/^[[:space:]]*Host[[:space:]]*//g; s/[[:space:]]+/\n/g' | sort | uniq)" sftp
fi
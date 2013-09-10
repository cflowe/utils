#!/bin/bash # for correct bash/vim highlighting

if [ -n "${BASH_VERSION:-}" ]; then
  # This dynamically determines the hosts
  _ssh_completion()
  {
      local cur names
      cur="${COMP_WORDS[COMP_CWORD]}"
      COMPREPLY=()

      if [ ${#COMP_WORDS[@]:-0} -gt 1 ]; then
        names=$(awk '/^[ \t]*Host[ \t]+/ {print $2}' ~/.ssh/config  | sort | uniq)
        COMPREPLY=( $(compgen -W "${names}" -- ${cur}) )
      fi

      return 0
  }

  complete -F _ssh_completion ssh

  # this statically determines the hosts
  #complete -W "$(awk '/^\s*Host\s*/ {print $2}' ~/.ssh/config  | sort | uniq)" ssh
fi

#!/bin/bash
# Report some info about a Mac configuration

SUDO_CMD=check_sudo

function echoerr () {
  {
    echo "$@" 1>&2;
  }
}


function check_mac () {
  local OS=$(uname)
  if [ "${OS}" != 'Darwin' ]; then
      echoerr "Cannot run this except on a Mac; you're on ${OS}."
      exit 1
  fi
}

function check_sudo() {
  sudo -l > /dev/null
  if [ $? -ne 0 ]; then
      echoerr 'Sorry, cannot continue without sudo rights'
      exit 1
  else
    SUDO_CMD=sudo
  fi
}  

function main() {
  check_mac
  check_sudo
  printf "user: %s\n" "${USER}"
  printf "hostname: %s\n" "$(hostname)"
  printf "model: %s\n" "$(/usr/sbin/system_profiler SPHardwareDataType | 
                          perl -lane 'print $F[-1] if /Model Identifier:/'
                        )"
  printf "serialno: %s\n" "$(/usr/sbin/system_profiler SPHardwareDataType |
			  perl -lane 'print $F[-1] if 
                          /Serial Number \(system\):/')"
  printf "filevault: %s\n" "$($SUDO_CMD fdesetup status)"
}

main | pbcopy

echoerr "The following has been copied to the clipboard:"
echoerr "----------------------------------------"
echoerr "$(pbpaste)"
echoerr "----------------------------------------"
echoerr "Please paste it into an email to devops@thesegovia.com."
echoerr "Thanks!"


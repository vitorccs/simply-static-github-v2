#!/bin/bash

# set variables
settings_file="settings.txt"
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
settings_path="${script_dir}/../${settings_file}"

# check if settings file exists
if ! test -f "${settings_path}"; then
    echo "ERROR: Settings file is missing (settings_path)"
    exit 1
fi

# set variables from settings
path_release=$(sed -n 's/^path_release=\(.*\)/\1/p' < "$settings_path")
flag_file=$(sed -n 's/^flag_file=\(.*\)/\1/p' < "$settings_path")
flag_pending=$(sed -n 's/^flag_pending=\(.*\)/\1/p' < "$settings_path")

# enter in the simply-static release folder
cd "${path_release}" || exit
touch "${flag_file}"

# give pending status to flag file
echo "${flag_pending}" > "${flag_file}"

# give write permissions for group
chmod g+w "${path_release}" -R

echo "SUCCESS: deployment flag has been set"
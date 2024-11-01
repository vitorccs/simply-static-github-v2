#!/bin/bash

# set variables
flag_status=""
timestamp=$(date "+%Y%m%d_%H%M")
settings_file="settings.txt"
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
settings_path="${script_dir}/../${settings_file}"

# check if settings file exists
if ! test -f "${settings_path}"; then
    echo "ERROR: Settings file is missing (settings_path)"
    exit 1
fi

# set variables from settings
flag_file=$(sed -n 's/^flag_file=\(.*\)/\1/p' < "$settings_path")
flag_pending=$(sed -n 's/^flag_pending=\(.*\)/\1/p' < "$settings_path")
flag_running=$(sed -n 's/^flag_running=\(.*\)/\1/p' < "$settings_path")
git_repo=$(sed -n 's/^git_repo=\(.*\)/\1/p' < "$settings_path")
git_token=$(sed -n 's/^git_token=\(.*\)/\1/p' < "$settings_path")
git_username=$(sed -n 's/^git_username=\(.*\)/\1/p' < "$settings_path")
path_release=$(sed -n 's/^path_release=\(.*\)/\1/p' < "$settings_path")

git_https="https://${git_token}@github.com/${git_username}/${git_repo}.git"
flag_file_path="${path_release}/${flag_file}"


# enter in the simply-static release folder
cd "${path_release}" || exit

# check if flag file exits and get its content
if test -f "${flag_file_path}"; then
  read -r flag_status < "${flag_file_path}"
fi

# start deployment if flag status is "pending"
if test "${flag_status}" = "${flag_pending}"
then
    # give running status to flag file (prevents duplicated executions)
    echo "${flag_running}" > "${flag_file}"

    # init the Git repository
    git init
    git config --global --add safe.directory "${path_release}"
    git config --global credential.helper store
    git remote remove origin
    git remote add origin "${git_https}"

    # publish all files to GitHub
    git add -A
    git commit -m "publish ${timestamp}"
    git push origin master -f

    # deletes the flag file (ready for a new execution)
    rm "${flag_file_path}"

    echo "SUCCESS: Published successfully"
else
    echo "WARNING: Nothing to do"
fi



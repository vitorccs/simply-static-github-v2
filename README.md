## Simply Static GitHub v2
Enhance GitHub deployment of [WordPress Simply Static plugin](https://wordpress.org/plugins/simply-static/) from hours to a few minutes!

## Description
The deployment method "GitHub Integration" from "Simply Static" is slow and appropriate only for small WordPress sites
(e.g: a site with a few thousand of pages may take more than 1 hour to be published!). 

The main reasons for the long publishing time are:
1) The plugin publishes the whole site (all files) rather than only the affected/changed files.
2) The plugin uses GitHub API which has a Rate Limit and thus, needs to throttle the amount of files published by hour. 

This project is intended to fix this issue by using GitHub CLI to publish the site instead, and thus, taking advantage of 
its native efficient and fast process.
 
## Requisites
+ Must have access to Crontab
+ WordPress installed and working properly (e.g: `/var/www/html/MY_WORDPRESS`)
+ WordPress plugin "Simply Static" installed and "Deployment Method" set as "Local Directory"
+ Git CLI installed in the operating system
+ A GitHub repository to dump the static files - where the static files will be placed 
+ A GitHub Personal Access Token with write permission in the repo above
+ A Folder with write permission for "Simply Static" dump the static files (e.g: `/var/www/html/MY_RELEASE`)

## How to install

### Summary
In short, the whole project consists of 4 files:
* `settings.txt`: change this file per your project needs (e.g: GitHub credentials)
* `includes/functions_include.php`: the include file to be placed in the WordPress (detects when "Simply Static" generates a new release)
* `scripts/set_deploy.sh`: the bash script which will be called by the PHP file above (creates a flag for cron script)
* `scripts/cron_deploy.sh`: the bash script which needs to be in the system crontab (detects the flag from the previous script and starts a GitHub deployment)

### Step 1
Place this project folder inside your WordPress (e.g: `/var/www/html/MY_WORDPRESS/simply-static-github-v2`). 
NOTE: the folder name must be "simply-static-github-v2"

### Step 2
Make a copy of `settings.txt.dist` to `settings.txt` and change the variables:
```bash
cp settings.txt.dist settings.txt
vim settings.txt
```

### Step 3
Add the PHP code below to the end of the `functions.php` file from the current WordPress Theme being used:
(e.g: MY_WORDPRESS/wp-content/themes/MY_CURRENT_THEME/functions.php):

```php
# Required for "Simply Static" WordPress plugin 
require_once(ABSPATH . 'simply-static-github-v2/includes/functions_include.php');
```

### Step 4
Open bash scripts files and change variables per project settings:
```bash
vim scripts/set_deploy.sh
vim scripts/cron_deploy.sh
```

### Step 5
Give execution permissions for bash scripts:
```bash
sudo chmod +x scripts/set_deploy.sh
sudo chmod +x scripts/cron_deploy.sh
```

### Step 6
In the WordPress Admin (/wp-admin), set the "Deploy" settings to "Local Directory" and enable "Clear Local Directory"

### Step 7
Add the bash script `cron_deploy.sh` to crontab
```bash
crontab -e
```
Append the following line
```bash
# checks for publishing tasks every 1 minute
* * * * * /var/www/html/MY_WORDPRESS/simply-static-github-v2/scripts/cron_deploy.sh
```

### Step 8 (optional step)
You can also manually run the publishing by the following command in the terminal:
```bash
./var/www/html/MY_WORDPRESS/simply-static-github-v2/scripts/cron_deploy.sh
```

_All done, enjoy it!_

## Folder permissions
The release folder must be writable for both the Web Server and the Crontab user.
So the recommended permissions is shown below in case your Web Server is Apache. 

Note: the user session needs to be restarted in order to apply the permissions 

#### For Debian/Ubuntu distros
```bash
sudo chown apache:apache /var/www/html/MY_RELEASE -R
usermod -a -G apache MY_USER
sudo chmod g+w /var/www/html/MY_RELEASE -R
```

#### For CentOS/Fedora/AMI distros
```bash
sudo chown www-data:www-data /var/www/html/MY_RELEASE -R
usermod -a -G www-data MY_USER
sudo chmod g+w /var/www/html/MY_RELEASE -R
```

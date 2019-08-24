#!/bin/bash

function load_setting()
{
  source ~/.stickie
}

function fix_sshd_config()
{
  if [ ! -f /etc/ssh/sshd_config.example ]; then
    echo "Backup sshd config file" | shell_log
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.example
  fi

  echo "Modify sshd config" | shell_log
  echo -e "\nPort $HOST_NEW_SSH_PORT" | sudo tee -a /etc/ssh/sshd_config > /dev/null
  echo -e "PermitRootLogin without-password" | sudo tee -a /etc/ssh/sshd_config > /dev/null
  echo -e "PermitEmptyPasswords no" | sudo tee -a /etc/ssh/sshd_config > /dev/null
  echo -e "AllowUsers $DEPLOY_USER_NAME" | sudo tee -a /etc/ssh/sshd_config > /dev/null
}

function reload_sshd()
{
  echo "Reload SSH Deamon" | shell_log
  sudo /etc/init.d/ssh reload 
}

function add_reboot_not_use_sudo_to_apps_user()
{
  printf '%s' '
[DEPLOY_USER_NAME] ALL=NOPASSWD:/sbin/reboot
' | sudo tee /etc/sudoers.d/$DEPLOY_USER_NAME > /dev/null

  sudo sed -r "s:\[DEPLOY_USER_NAME\]:$DEPLOY_USER_NAME:g" -i /etc/sudoers.d/$DEPLOY_USER_NAME
}

function run_script_system_hardening()
{
  add_reboot_not_use_sudo_to_apps_user
  load_setting
  fix_sshd_config
  reload_sshd
}

run_script_system_hardening
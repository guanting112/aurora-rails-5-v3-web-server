#!/bin/bash

function run_update_image_magick()
{
  printf '%s' '
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policymap [
<!ELEMENT policymap (policy)+>
<!ELEMENT policy (#PCDATA)>
<!ATTLIST policy domain (delegate|coder|filter|path|resource) #IMPLIED>
<!ATTLIST policy name CDATA #IMPLIED>
<!ATTLIST policy rights CDATA #IMPLIED>
<!ATTLIST policy pattern CDATA #IMPLIED>
<!ATTLIST policy value CDATA #IMPLIED>
]>
<policymap>
  <policy domain="coder" rights="none" pattern="EPHEMERAL" />
  <policy domain="coder" rights="none" pattern="URL" />
  <policy domain="coder" rights="none" pattern="HTTPS" />
  <policy domain="coder" rights="none" pattern="MVG" />
  <policy domain="coder" rights="none" pattern="MSL" />
  <policy domain="path" rights="none" pattern="@*" />
  <!-- <policy domain="system" name="precision" value="6"/> -->
  <!-- <policy domain="resource" name="temporary-path" value="/tmp"/> -->
  <!-- <policy domain="resource" name="memory" value="2GiB"/> -->
  <!-- <policy domain="resource" name="map" value="4GiB"/> -->
  <!-- <policy domain="resource" name="area" value="1GB"/> -->
  <!-- <policy domain="resource" name="disk" value="16EB"/> -->
  <!-- <policy domain="resource" name="file" value="768"/> -->
  <!-- <policy domain="resource" name="thread" value="4"/> -->
  <!-- <policy domain="resource" name="throttle" value="0"/> -->
  <!-- <policy domain="resource" name="time" value="3600"/> -->
</policymap>
' | sudo tee /etc/ImageMagick-6/policy.xml > /dev/null

}

function run_script_install_rails()
{
  install_image_magick
  run_update_image_magick
  install_rails
}

function install_image_magick()
{
  echo "Install Image Magick and 'magickwand-dev' " | shell_log

  sudo apt install -y imagemagick libmagickwand-dev 
}

function install_rails()
{
  local image_magick_is_installed=0

  [ "`which convert`" == '/usr/bin/convert' ] && image_magick_is_installed=1

  if [ $image_magick_is_installed == 1 ]
  then
    echo "Install gems ( rails 5.2, whenever, backup 5, httprb ) " | shell_log
    gem install rails -v "~>5.2.0" 
    gem install whenever http 
    gem install backup -v "5.0.0.beta.2"
  else
    echo "Rails needs to install imagemagick" | shell_error
  fi
}

run_script_install_rails
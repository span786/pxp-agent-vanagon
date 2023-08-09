# This platform definition is used to build natively on SPARC, unlike
# solaris-10/11-sparc, which are cross compiled. Therefore, this definition does
# not inherit from vanagon defaults.
platform("solaris-11-sparc", override_name: true) do |plat|
  plat.servicedir "/lib/svc/manifest"
  plat.defaultdir "/lib/svc/method"
  plat.servicetype "smf"

  plat.vmpooler_template "solaris-11-sparc"
  plat.add_build_repository "http://solaris-11-reposync.delivery.puppetlabs.net:81", "puppetlabs.com"
  plat.install_build_dependencies_with "pkg install ", " || [[ $? -eq 4 ]]"

  # REMIND: workaround IPS server issues
  plat.provision_with %[
curl --insecure -LO 'https://artifactory.delivery.puppetlabs.net:443/artifactory/generic__buildsources/buildsources/pl-cmake-sparc@3.26.0,5.11-1.sparc.p5p';
pkg set-publisher -p 'pl-cmake-sparc@3.26.0,5.11-1.sparc.p5p';
pkg install pl-cmake-sparc || [[ $? -eq 4 ]];
echo "# Write the noask file to a temporary directory
# please see man -s 4 admin for details about this file:
# http://www.opensolarisforum.org/man/man4/admin.html
#
# The key thing we don\'t want to prompt for are conflicting files.
# The other nocheck settings are mostly defensive to prevent prompts
# We _do_ want to check for available free space and abort if there is
# not enough
mail=
# Overwrite already installed instances
instance=overwrite
# Do not bother checking for partially installed packages
partial=nocheck
# Do not bother checking the runlevel
runlevel=nocheck
# Do not bother checking package dependencies (We take care of this)
idepend=nocheck
rdepend=nocheck
# DO check for available free space and abort if there isn\'t enough
space=quit
# Do not check for setuid files.
setuid=nocheck
# Do not check if files conflict with other packages
conflict=nocheck
# We have no action scripts.  Do not check for them.
action=nocheck
# Install to the default base directory.
basedir=default" > /var/tmp/vanagon-noask;
  echo "mirror=https://artifactory.delivery.puppetlabs.net/artifactory/generic__remote_opencsw_mirror/testing" > /var/tmp/vanagon-pkgutil.conf;
  pkgadd -n -a /var/tmp/vanagon-noask -d http://get.opencsw.org/now all
  /opt/csw/bin/pkgutil -U && /opt/csw/bin/pkgutil -y -i ggettext || exit 1
  ]
end

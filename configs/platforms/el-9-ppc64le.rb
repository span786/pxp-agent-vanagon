platform 'el-9-ppc64le' do |plat|
  plat.servicedir '/usr/lib/systemd/system'
  plat.defaultdir '/etc/sysconfig'
  plat.servicetype 'systemd'

  # Workaround for an issue with RedHat subscription metadata, see ITSYS-2543
  plat.provision_with('subscription-manager repos --disable rhel-9-for-ppc64le-baseos-rpms && subscription-manager repos --enable rhel-9-for-ppc64le-baseos-rpms')

  packages = %w[make cmake gcc-c++ libarchive]
  plat.provision_with("dnf install -y --allowerasing  #{packages.join(' ')}")
  plat.install_build_dependencies_with 'dnf install -y --allowerasing'
  plat.vmpooler_template 'redhat-9-power9'
end

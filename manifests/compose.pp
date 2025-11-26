# == Class: docker::compose
#
# Class to install Docker Compose using the recommended curl command.
#
# === Parameters
#
# [*ensure*]
#   Whether to install or remove Docker Compose
#   Valid values are absent present
#   Defaults to present
#
# [*version*]
#   The version of Docker Compose to install.
#   Defaults to the value set in $docker::params::compose_version
#
class docker::compose(
  Enum['present', 'absent'] $ensure = 'present',
  String                    $version = $docker::params::compose_version
) inherits docker::params {

  if $ensure == 'present' {
    exec { "Install Docker Compose ${version}":
      path    => '/usr/bin/',
      cwd     => '/tmp',
      command => "curl -s -L https://github.com/docker/compose/releases/download/${version}/docker-compose-${::kernel}-x86_64 > /usr/local/bin/docker-compose-${version}",
      creates => "/usr/local/bin/docker-compose-${version}"
    } ->
    file { "/usr/local/bin/docker-compose-${version}":
      owner => 'root',
      mode  => '0755'
    } ->
    file { '/usr/local/bin/docker-compose':
      ensure => 'link',
      target => "/usr/local/bin/docker-compose-${version}",
    }
  } else {
    file { [
      "/usr/local/bin/docker-compose-${version}",
      '/usr/local/bin/docker-compose'
    ]:
      ensure => absent,
    }
  }
}

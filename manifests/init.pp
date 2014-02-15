# Installs Pow using HomeBrew
#
# Usage:
#
#     include pow
class pow {
  
  include pow::config

  $home = "/Users/${::boxen_user}"

  package { 'pow':
    ensure   => 'latest',
    provider => 'homebrew'
  }

  file { ["${pow::config::home}/Library/Application Support/Pow", "${pow::config::home}/Library/Application Support/Pow/Hosts"]:
    ensure  => directory,
  } 

  file { "${pow::config::home}/.pow":
    target  => "${home}/Library/Application Support/Pow/Hosts",
    ensure  => link,
  }

  file { $pow::config::logdir:
    ensure => present,
  }

  file { 'firewall_plist':
    path    => $pow::config::firewall_plist,
    content => template('pow/firewall.plist'),
    owner   => "root",
    group   => "wheel",
  }

  file { 'powd_plist': 
    path    => $pow::config::powd_plist,
    content => template('pow/powd.plist'),
  }

  exec { 'append port to dev resolver':
    command => "echo '\nport 20559' >> /etc/resolver/dev",
    user    => "root",
    unless  => "grep -c 20559 /etc/resolver/dev",
  }

  exec { 'load firewall rule':
    command => "launchctl load ${pow::config::firewall_plist}",
    user    => 'root',
    unless  => "ipfw list | grep 'fwd 127.0.0.1,20559 tcp from any to me dst-port 80 in'",
    require => File['firewall_plist'],
  }

  exec { 'load powd service':
    command => "launchctl load ${pow::config::powd_plist}",
    user    => $::boxen_user,
    unless  => "launchctl list | grep ${pow::config::service_powd_name}",
    require => File['powd_plist'],
  }
}

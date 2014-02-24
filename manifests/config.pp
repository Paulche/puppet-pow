
class pow::config {
  $home       = "/Users/${::boxen_user}"
  $logdir     = "${boxen::config::logdir}/pow"

  $service_firewall_name  = 'dev.pow.firewall' 
  $service_powd_name      = 'dev.pow.powd'

  $firewall_plist   = "/Library/LaunchDaemons/${service_firewall_name}.plist"
  $powd_plist       = "${home}/Library/LaunchAgents/${service_powd_name}.plist"
  
  $pow_path    = "${boxen::config::homebrewdir}/bin/pow"
}

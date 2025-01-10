# This Puppet manifest kills a process named 'killmenow' using pkill
exec { 'kill_process':
  command => 'pkill killmenow',
  path    => '/usr/bin:/bin',
  onlyif  => 'pgrep killmenow',
}


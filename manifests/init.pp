class elasticsearch {

  # Checks if the package was allready defined
  if ! defined(Package['openjdk-6-jre']) {
    package { ["openjdk-6-jre"]:
        ensure => installed,
        require => Class['apt']
    }
  }
  
  # Downloads elasticsearch
  exec { 'wget elasticsearch':
        command => "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb -O elasticsearch.deb",
        unless => "ls | grep elasticsearch.deb"
      }
  
  # Installs elastic search
  exec { 'dpkg -i elasticsearch.deb':
    require => [Package['openjdk-6-jre'], Exec['wget elasticsearch']],
    notify => Service["elasticsearch"]
  }

  service { elasticsearch : ensure => running }

  # Installs elastic search head plugin and checks if it was already installed
  exec { 'install elasticsearch plugins':
  	command => "sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head",
  	require => [Exec['dpkg -i elasticsearch.deb']],
	unless => "sudo /usr/share/elasticsearch/bin/plugin -l | grep head"
  }
}
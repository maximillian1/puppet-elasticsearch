class elasticsearch {

	# If it doesnt work, manually do sudo apt-get -f install
	package { ["openjdk-6-jre"]:
			ensure => installed,
			require => Class['apt']
	}

	exec { 'wget elasticsearch':
				command => "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb -O elasticsearch.deb",
				unless => "ls | grep elasticsearch.deb"
			}

	exec { 'dpkg -i elasticsearch.deb':
		require => [Package['openjdk-6-jre'], Exec['wget elasticsearch']],
		notify => Service["elasticsearch"]
	}

	service { elasticsearch : ensure => running }

	exec { 'sudo /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head':
  	
	}
}

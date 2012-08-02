maintainer       "Noan Kantrowitz"
maintainer_email "noah@coderanger.net"
license          "Apache 2.0"
description      "Install and configure the collectd monitoring daemon"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"
supports         "ubuntu"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

recipe "collectd", "Install a standalone daemon."
recipe "collectd::client", "Install collectd and configure it to send data to a server."
recipe "collectd::server", "Install collectd and configure it to recieve data from clients."
recipe "collectd::collectd_web", "Installs and configures collectd_web."

attribute "collectd/base_dir",
  :display_name => "collectd Base Directory",
  :description => "The base directory for collectd.",
  :required => "optional",
  :default => "/var/lib/collectd",
  :recipes => [ "collectd::default" ]

attribute "collectd/plugin_dir",
  :display_name => "collectd Plugin Directory",
  :description => "The plugin directory for collectd.",
  :required => "optional",
  :default => "/usr/lib/collectd" ,
  :recipes => [ "collectd::default" ]

attribute "collectd/types_db",
  :display_name => "collectd Types Database",
  :description => "The location of the collectd types.db file.",
  :required => "optional",
  :default => "/usr/share/collectd/types.db",
  :recipes => [ "collectd::default" ]

attribute "collectd/interval",
  :display_name => "collectd Polling Interval",
  :description => "The collectd interval setting value.",
  :required => "optional",
  :default => "20",
  :recipes => [ "collectd::default" ]

attribute "collectd/read_threads",
  :display_name => "collectd Read Threads",
  :description => "The collectd read threads setting value.",
  :required => "optional",
  :default => "5",
  :recipes => [ "collectd::default" ]

attribute "collectd/servers",
  :display_name => "collectd Servers",
  :description => "The collectd servers to send to as a client.",
  :required => "optional",
  :default => nil,
  :type => "array",
  :recipes => [ "collectd::client" ]

attribute "collectd/hostname",
  :display_name => "collectd Hostname",
  :description => "The collectd Hostname setting value.",
  :required => "optional",
  :recipes => [ "collectd::default" ]

attribute "collectd/fqdn_lookup",
  :display_name => "collectd FQDNLookup",
  :description => "The collectd FQDNLookup setting value.",
  :required => "optional",
  :recipes => [ "collectd::default" ],
  :choice => [ "true", "false" ],
  :default => "true"

attribute "collectd/collectd_web/path",
  :display_name => "collectd_web path",
  :description => "The collectd_web install path.",
  :required => "optional",
  :default => "/srv/collectd_web",
  :recipes => [ "collectd::collectd_web" ]

attribute "collectd/collectd_web/hostname",
  :display_name => "collectd_web hostname",
  :description => "The collectd_web hostname.",
  :required => "optional",
  :default => "collectd",
  :recipes => [ "collectd::collectd_web" ]
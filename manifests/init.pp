# == Class: keysync
#
# This is a Simple SSH Public and Private Key Sync Module. 
# Define each user individually and then each key individually
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Authors
#
# Red Hat Inc
#
# === Copyright
#
# Copyright 2015 Red Hat Inc
#
class rh-keysync {

#Sync Root's Keys
    file {"/root/.ssh/id_rsa":
    ensure => present,
    mode => 400,
	owner => root,
	group => root,
	source => "puppet:///modules/rh-keysync/root-id_rsa"
}

    file {"/root/.ssh/authorized_keys":
	mode => 400,
    ensure => present,
    owner => root,
    group => root,
    source => "puppet:///modules/rh-keysync/root-id_rsa.pub"
}
}

# InfluxDB

#### Table of Contents

1.  [Overview](#overview)
2.  [Module Description - What the module does and why it is useful](#module-description)
3.  [Installation](#installation)
4.  [Setup - The basics of getting started with influxdb](#setup)
5.  [Usage - Configuration options and additional functionality](#usage)
6.  [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7.  [Limitations - OS compatibility, etc.](#limitations)
8.  [Development - Guide for contributing to the module](#development)
9.  [License](#License)

## Overview

This module manages InfluxDB installation.

[![Build Status](https://travis-ci.org/n1tr0g/golja-influxdb.png)](https://travis-ci.org/n1tr0g/golja-influxdb) [![Puppet Forge](http://img.shields.io/puppetforge/v/golja/influxdb.svg)](https://forge.puppetlabs.com/golja/influxdb)

## Module Description

The InfluxDB module manages both the installation and configuration of InfluxDB.
I am planning to extend it to allow management of InfluxDB resources,
such as databases, users, and privileges.

## Deprecation Warning

Notes for version 4.0.0+:

influxdb 1.0.0 contains [breaking changes](https://github.com/influxdata/influxdb/blob/master/CHANGELOG.md#v100-2016-09-08)
which require changing the `data_logging_enabled` config attribute to `trace_logging_enabled`.
The other configuration changes are managed by the `influxdb.conf.erb` template already.

Notes for versions older than 3.1.1:

This release is a major refactoring of the module which means that the API
changed in backwards incompatible ways. If your project depends on the old API
and you need to use influxdb prior to 0.10.X, please pin your module
dependencies to 0.1.2 (0.8.X) or 2.2.2 (0.9.X) version to ensure your environments
don't break.

*NOTE*: Until influxdb 1.0.0 is releases the API of this module may change,
however I will try my best to avoid it.

## Installation

`puppet module install golja/influxdb`

## Setup

### What InfluxDB affects

*   InfluxDB packages
*   InfluxDB configuration files
*   InfluxDB service

### Beginning with InfluxDB

If you just want a server installed with the default options you can
run include `'::influxdb2::server'`.

## Usage

All interaction for the server is done via `influxdb2::server`.

Install influxdb

```puppet
class {'influxdb2::server':}
```

Join a cluster
```puppet
class {'influxdb2::server':
  meta_bind_address      => "${::fqdn}:8088",
  meta_http_bind_address => "${::fqdn}:8091",
  http_bind_address      => "${::fqdn}:8086",
  influxd_opts           => "-join my.other.node1:8091,my.other.node2:8091"
}
```
For more info on setting up a raft cluster, see the [InfluxDB docs](https://docs.influxdata.com/influxdb/v0.10/guides/clustering/)


Enable Graphite plugin with one database

```puppet
class {'influxdb2::server':
  graphite_options => {
    enabled           => true,
    database          => graphite,
    bind-address      => ':2003',
    protocol          => tcp,
    consistency-level => 'one',
    name-separator    => '.',
    batch-size        => 1000,
    batch-pending     => 5,
    batch-timeout     => '1s',
    udp-read-buffer   => 0,
    name-schema       => 'type.host.measurement.device',
    templates         => [ "*.app env.service.resource.measurement" ],
    tags              => [ "region=us-east", "zone=1c"],
  },
}
```

Enable Collectd plugin

```puppet
class {'influxdb2::server':
  collectd_options => {
    enabled => true,
    bind-address => ':25826',
    database => 'foo',
    typesdb => '/usr/share/collectd/types.db',
    batch-size => 1000,
    batch-pending => 5,
    batch-timeout => '1s',
    read-buffer => 0,
  },
}
```

Enable UDP listener

```puppet
$udp_options = [
    { 'enabled'       => true,
      'bind-address'  => ':8089',
      'database'      => 'udp_db1',
      'batch-size'    => 10000,
      'batch-timeout' => '1s',
      'batch-pending' => 5,
    },
    { 'enabled'       => true,
      'bind-address'  => ':8090',
      'database'      => 'udp_db2',
      'batch-size'    => 10000,
      'batch-timeout' => '1s',
      'batch-pending' => 5,
    },
]

class {'influxdb2::server':
	reporting_disabled    => true,
	http_auth_enabled     => true,
	shard_writer_timeout  => '10s',
	cluster_write_timeout => '10s',
	udp_options           => $udp_options,
}
```

Enable opentsdb

```puppet
class {'influxdb2::server':
  opentsdb_options => {
    enabled => true,
    bind-address => ':4242',
    database => 'foo',
    typesdb => '/usr/share/collectd/types.db',
    batch-size => 1000,
    batch-pending => 5,
    batch-timeout => '1s',
    read-buffer => 0,
  },
}
```

## Reference

### Classes

#### Public classes

*   `influxdb2::server`: Installs and configures InfluxDB.

#### Private classes

*   `influxdb2::server::install`: Installs packages.
*   `influxdb2::server::config`: Configures InfluxDB.
*   `influxdb2::server::service`: Manages service.

### Parameters

#### influxdb2::server

##### `ensure`

Allows you to install or remove InfluxDB. Can be 'present' or 'absent'.

##### `version`

Version of InfluxDB.
Default: 0.9.3
*NOTE*: Unfortunately, the latest link available on the influxdb website
is pointing to an old version.
For more info, check [ISSUE 3533](https://github.com/influxdb/influxdb/issues/3533)

##### `config_file`

Path to the config file.
Default: OS specific

##### `service_provider`

The provider to use to manage the service.
Default: OS specific

##### `service_enabled`

Boolean to decide if the service should be enabled.

##### `package_provider`

What provider should be used to install the package.

##### `meta_bind_address`

This setting can be used to configure InfluxDB to bind to and listen for 
cluster connections on this address, default is `":8088"`

For clustering this must be set to `<fqdn>:<port>` (usually 8088)

##### `meta_http_bind_address`

This setting can be used to configure InfluxDB to bind to and listen for
cluster connections on this address, default is `":8091"`

For clustering this must be set to `<fqdn>:<port>` (usually 8091)

##### `reporting_disabled`

If enabled once every 24 hours InfluxDB will report anonymous data
to m.influxdb.com.
Default: false

##### `retention_autocreate`

Default: true

##### `election_timeout`

Default: 1s

##### `heartbeat_timeout`

Default: 1s

##### `leader_lease_timeout`

Default: 500ms

##### `commit_timeout`

Default: 50ms

##### `data_dir`

Controls where the actual shard data for InfluxDB lives.
Default: OS distro

##### `wal_dir`

Wal dir for the storage engine 0.9.3+
Default: /var/lib/influxdb/wal

##### `meta_dir`

Location of the meta dir
Default: /var/lib/influxdb/meta

##### `wal_enable_logging`

Enable WAL logging.
NEW in 0.9.3+
Default: true

##### `shard_writer_timeout`

The time within which a shard must respond to write.
Default: 5s

##### `cluster_write_timeout`

The time within which a write operation must complete on the cluster.
Default: 5s

##### `retention_enabled`

Controls the enforcement of retention policies for evicting old data.
Default: true

##### `retention_check_interval`

Default: 10m

##### `admin_enabled`

Controls the availability of the built-in, web-based, admin interface.
Default: true

##### `admin_bind_address`

Default: :8083

##### `admin_https_enabled`

If HTTPS is enabled for the admin interface,
HTTPS must also be enabled on the \[http\] service.
Default: false

##### `admin_https_certificate`

Default: undef

##### `http_enabled`

Controls how the HTTP endpoints are configured.
These are the primary mechanism for getting data into and out of InfluxDB.
Default: true

##### `http_bind_address`

Default: :8086

##### `http_auth_enabled`

Default: false

##### `http_log_enabled`

Default: true

##### `http_write_tracing`

Default: false

##### `http_pprof_enabled`

Default: false

##### `http_https_enabled`

Default: false

##### `http_https_certificate`

Default: undef

##### `http_https_private_key`

Default: undef

##### `http_max_row_limit`

Default: 10000

##### `http_realm`

Default: InfluxDB

##### `subscriber_enabled`

Controls the subscriptions, which can be used to fork a copy of all data
received by the InfluxDB host.
Default: true

##### `subscriber_http_timeout`

Default: 30s

##### `graphite_options`

Controls the listener for InfluxDB line protocol data via Graphite.
Default: undef

##### `collectd_options`

Controls the listener for InfluxDB line protocol data via Collectd.
Default: undef

##### `opentsdb_options`

Controls the listener for InfluxDB line protocol data via OpenTSDB.
Default: undef

##### `udp_options`

Controls the listener for InfluxDB line protocol data via UDP.
Default: undef

##### `monitoring_enabled`

Default: true

##### `monitoring_write_interval`

Default: 24h

##### `monitoring_database`

Default: _internal

##### `continuous_queries_enabled`

Controls how continuous queries are run within InfluxDB.
Default: true

##### `continuous_queries_log_enabled`

Default true

##### `continuous_queries_run_interval`

Default: 1s

##### `max_series_per_database`

Controls the number of series allowed per database. Change the setting
to 0 to allow an unlimited number of series per database.
Default: 1000000

##### `hinted_handoff_enabled`

Controls the hinted handoff feature, which allows nodes to temporarily
store queued data when one node of a cluster is down for a short period of time.
Default: true

##### `hinted_handoff_dir`

Default: /var/lib/influxdb/hh

##### `hinted_handoff_max_size`

Default: 1073741824

##### `hinted_handoff_max_age`

Default: 168h

##### `hinted_handoff_retry_rate_limit`

Default: 0

##### `hinted_handoff_retry_interval`

Default: 1s

##### `conf_template`

If needed, you can add a custom template.
Default: influxdb/influxdb.conf.erb

##### `influxdb_user`

Default: OS specific

##### `influxdb_group`

Default: OS specific

##### `influxdb_stderr_log`

Default: /var/log/influxdb/influxd.log

##### `influxdb_stdout_log`

Default: /dev/null

##### `manage_install`

enable/disable installation of the influxdb packages from the yum/apt repo
Default: true

##### `manage_repos`

enable/disable repository installation
Default: true

##### `influxd_opts`

Additional influxd options used for setting up raft clusters.
Default: undef

## Limitations

This module has been tested on:

*   Ubuntu 12.04
*   Ubuntu 14.04
*   CentOS 6/7

## Development

Please see CONTRIBUTING.md

### Todo

*   Add native types for managing users and databases
*   Add more rspec tests
*   Add beaker/rspec tests

## License

See LICENSE file

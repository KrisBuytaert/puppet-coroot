# coroot

This module installs and manages coroot, 

https://github.com/coroot/

both the server and the coroot-node-agent 




Install the server
```
    class {'coroot::server':
      listen_address               => '0.0.0.0:8080',
      bootstrap_clickhouse_address => 'clickhouse.yourdomain:9000' ,
      bootstrap_prometheus_url     => 'http://prometheus.yourdomain:9090/,
      bootstrap_refresh_interval   => 15s,
      manage_package               => true,
      package_name                 => 'coroot',
      disable_usage_statistics     => true,
      clickhouse_database          => 'default',
    }
```


Install the agent 

```
 class {'coroot::node_agent':
    coroot_address   => 'http://your_coroot_url:8080',
    api_key          => 'the_key_the_coroot_ui_tells_u,
  }


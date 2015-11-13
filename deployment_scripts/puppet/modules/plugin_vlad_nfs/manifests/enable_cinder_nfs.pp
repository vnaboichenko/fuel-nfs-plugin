class plugin_vlad_nfs::enable_cinder_nfs() {

   $volume_dir='/volume'
   $shares_config='/etc/cinder/nfs_shares'
   $packages=['nfs-common', 'cinder-volume']
   $network_metadata = hiera_hash('network_metadata')
   $nfs_map = get_node_to_ipaddr_map_by_network_role(get_nodes_hash_by_roles($network_metadata, ['vlad_nfs']), 'storage')
   $nfs_ip = values($nfs_map)
   
   package {$packages:
     ensure => present,
     before => File['/etc/cinder/nfs_shares']
   }

  cinder_config {
    'DEFAULT/volume_driver': value => 'cinder.volume.drivers.nfs.NfsDriver';
    'DEFAULT/nfs_shares_config': value => "$shares_config";
  }
   
   file {"$shares_config":
     ensure => present,
     content => "${nfs_ip}:${volume_dir}"
   }
   
   service {"cinder-volume":
     ensure => running
   }

  Cinder_config <||> -> File["$shares_config"] ~> Service['cinder-volume']

}

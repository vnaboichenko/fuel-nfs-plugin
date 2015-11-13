class plugin_vlad_nfs::install() {

   notify { 'Vlad Nfs manifest':}
   
   $volume_dir='/volume'
   
   package {"nfs-kernel-server":
     ensure => present,
   }
   
   file {"$volume_dir":
     ensure => directory,
     mode => 777
   }
   
   file {"/etc/exports":
     ensure => present,
     content => "$volume_dir *(rw,sync,no_subtree_check)"
   }
   
   service {"nfs-kernel-server":
     ensure => running
   }

  firewall {'111 NFS':
    port   => ['111', '2049'],
    proto  => 'tcp',
    action => 'accept',
  }

Package["nfs-kernel-server"] -> File["$volume_dir"] -> File['/etc/exports'] ~> Service["nfs-kernel-server"]

}

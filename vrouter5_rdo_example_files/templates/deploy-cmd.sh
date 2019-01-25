#!/bin/bash
. ~/stackrc
time openstack overcloud deploy --templates \
-e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/docker.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/enable-swap-partition.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/enable-swap.yaml \
-e ~/contrail-tripleo-heat-templates/environments/contrail/contrail-plugins.yaml \
-e environment.yaml \
-e ~/docker_registry.yaml \
-e role_mappings.yaml \
-r roles_data.yaml \
--libvirt-type kvm \
--ntp-server ntp.is.co.za $*

# -e /usr/share/openstack-tripleo-heat-templates/environments/host-config-and-reboot.yaml \


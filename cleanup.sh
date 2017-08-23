#!/usr/bin/env bash

contrail_ip=0.0.0.0

mask='rally_\|tempest_\|tempest-'
remove_mask='rally_\|tempest_\|tempest-'

echo "Starting. Using mask '$mask'"
echo "Delete servers"
#--all-tenants
nova delete `echo -n \`nova list --all-tenants | grep $mask | awk '{print $2}'\``

echo "Delete flavors"
for i in `nova flavor-list --all | grep $mask | awk '{print $2}'`; do nova flavor-delete $i; done

echo "Delete snapshot"
#[--force]
cinder snapshot-delete --force `echo -n \`cinder snapshot-list --all | grep $mask | awk '{print $2}'\``
#for i in `openstack snapshot list --all | grep $mask | awk '{print $2}'`; do openstack snapshot delete $i; echo deleted $i; done

echo "Delete volumes"
#--cascade
cinder force-delete `echo -n \`cinder list --all-tenants | grep $mask | awk '{print $2}'\``
#for i in `openstack volume list --all | grep $mask | awk '{print $2}'`; do openstack volume delete $i; echo deleted $i; done

echo "Delete images"
#glance image-delete `echo -n \`glance image-list | grep $mask | awk '{print $2}'\``
#glance image-delete `echo -n \`glance image-list | grep 'New Remote\|New Standard\|New Name' | awk '{print $2}'\``
for i in `openstack image list | grep $mask | awk '{print $2}'`; do openstack image delete $i; echo deleted $i; done

echo "Delete sec groups"
openstack security group delete `echo -n \`openstack security group list | grep $mask | awk '{print $2}'\``
#for i in `openstack security group list --all | grep $mask | awk '{print $2}'`; do openstack security group delete $i; echo deleted $i; done

echo "Delete keypairs"
nova keypair-delete `echo -n \`nova keypair-list | grep $mask | awk '{print $2}'\``
#for i in `openstack keypair list | grep $mask | awk '{print $2}'`; do openstack keypair delete $i; echo deleted $i; done

echo "Delete ports"
#neutron port-delete `echo -n \`neutron port-list --all-tenants | grep $mask | awk '{print $2}'\``
for i in `neutron port-list --all-tenants | grep $mask | awk '{print $2}'`; do neutron port-delete $i; done

echo "Delete routers"
#neutron router-delete `echo -n \`neutron router-list --all-tenants | grep $mask | awk '{print $2}'\``
for i in `neutron router-list --all-tenants | grep $mask | awk '{print $2}'`; do neutron router-delete $i; done

echo "Delete subnets"
#neutron subnet-delete `echo -n \`neutron subnet-list --all-tenants | grep $mask | awk '{print $2}'\``
for i in `neutron subnet-list --all-tenants | grep $mask | awk '{print $2}'`; do neutron subnet-delete $i; done

echo "Delete nets"
#neutron net-delete `echo -n \`neutron net-list --all-tenants | grep $mask | awk '{print $2}'\``
for i in `neutron net-list --all-tenants | grep $mask | awk '{print $2}'`; do neutron net-delete $i; done

echo "Delete users"
openstack user delete `echo -n \`openstack user list | grep $mask | awk '{print $2}'\``
#for i in `openstack user list | grep $mask | awk '{print $2}'`; do openstack user delete $i; echo deleted $i; done

echo "Delete roles"
openstack role delete `echo -n \`openstack role list | grep $mask | awk '{print $2}'\``
#for i in `openstack role list | grep $mask | awk '{print $2}'`; do openstack role delete $i; echo deleted $i; done

#echo "Delete projects"
#openstack project delete `echo -n \`openstack project list | grep $mask | awk '{print $2}'\``
#for i in `openstack project list | grep $mask | awk '{print $2}'`; do openstack project delete $i; echo deleted $i; done

echo "Delete containers"
openstack --os-interface internal container delete `echo -n \`openstack --os-interface internal container list --all | grep $mask | awk '{print $2}'\``
#for i in `openstack --os-interface internal container list --all | grep $mask | awk '{print $2}'`; do openstack --os-interface internal container delete $i; echo deleted $i; done

echo "Delete stacks"
for i in `openstack stack list | grep $mask | awk '{print $2}'`; do openstack stack delete -y $i; done

echo "Done with Openstack part"

echo "=Removing pair virtual-machine-interface/instance-ip="
contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure rm -rf `echo -n \`contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l virtual-machine-interface | grep $remove_mask | awk '{print $1}'\``

echo "==Deleting objects from Contrail=="
for j in instance-ip access-control-list logical-router route-table service-instance virtual-machine-interface security-group virtual-machine virtual-network; do contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure rm -f `echo -n \`contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l $j | grep $remove_mask | awk '{print $1}'\``; done

echo "=Removing pair virtual-machine-interface/instance-ip="
contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure rm -rf `echo -n \`contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l virtual-machine-interface | grep $remove_mask | awk '{print $1}'\``

echo "=Removing security-groups="
contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure rm -f `echo -n \`contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l security-group | grep $remove_mask | awk '{print $1}'\``

echo "=Removing virtual-networks="
contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure rm -f `echo -n \`contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l virtual-network | grep $remove_mask | awk '{print $1}'\``

echo "=Removing access-control-list="
contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure rm -f `echo -n \`contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l access-control-list | grep $remove_mask | awk '{print $1}'\``

#echo "=Removing project="
#contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure rm -f `echo -n \`contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l project | grep $remove_mask | awk '{print $1}'\``

#echo "=======Scan for not-removed resources======="
#for j in `contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls`; do for i in `contrail-api-cli --os-auth-plugin v3password --host $contrail_ip --port 8082  --insecure ls -l $j | grep $remove_mask`; do echo $i; done; done

#!/bin/bash

if [ ! -e /etc/security/limits.d/91-nofile.conf ]; then
  echo '* - nofile 4096' > /etc/security/limits.d/91-nofile.conf
fi
mkdir -p /var/log/journal/
systemctl restart systemd-journald

rmmod nfp
modprobe nfp
udevadm settle

NFP_RULES=/etc/udev/rules.d/60-nfp.rules
cat >${NFP_RULES} <<EOF
# Autogenerated rules for naming nfp_pX
EOF
for NETDEV in /sys/class/net/*; do
    NETDEV=`basename ${NETDEV}`
    DRIVER="/sys/class/net/${NETDEV}/device/driver"
    if [ -L ${DRIVER} ]; then
        DRIVER=`readlink ${DRIVER}`
        DRIVER=`basename ${DRIVER}`
        if [ "x${DRIVER}" = "xnfp" ]; then
            NEWNAME=`cat /sys/class/net/${NETDEV}/phys_port_name`
            NEWNAME="nfp_${NEWNAME}"
            MAC=`cat /sys/class/net/${NETDEV}/address`
            echo "ACTION==\"add\", SUBSYSTEM==\"net\", ATTR{address}==\"${MAC}\", NAME=\"${NEWNAME}\"" >>/etc/udev/rules.d/60-nfp.rules
        fi
    fi
done
dracut -f

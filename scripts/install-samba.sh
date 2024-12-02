#/bin/bash
cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 10.0.2.15/24
      routes:
        - to: default
          via: 10.0.2.2
      nameservers:
        search: [klambri.lan]
        addresses: [192.168.61.2, 1.1.1.1]
EOF

cat << EOF > /etc/netplan/50-vagrant.yaml 
network:
  version: 2
  renderer: networkd
  ethernets:
    eth1:
      addresses:
        - 192.168.61.2/24
      nameservers:
        search: [klambri.lan]
        addresses: [192.168.61.2, 1.1.1.1]
EOF

chmod 600 /etc/netplan/01-netcfg.yaml /etc/netplan/50-vagrant.yaml
netplan apply

export DEBIAN_FRONTEND=noninteractive
apt-get update -y && apt-get install samba-ad-dc krb5-user net-tools -y
hostnamectl set-hostname dc1.klambri.lan
echo "192.168.61.2 dc1 klambri.lan dc1.klambri.lan" >> /etc/hosts
rm /etc/samba/smb.conf
samba-tool domain provision \
  --host-ip=192.168.61.2 \
  --host-name=dc1.klambri.lan \
  --realm=KLAMBRI.LAN \
  --domain=KLAMBRI \
  --dns-backend=SAMBA_INTERNAL \
  --use-rfc2307 \
  --adminpass=P@ssw0rd \
  --option="dns forwarder = 1.1.1.1" \
  --option="tls enabled = yes" \
  --option="tls keyfile = tls/tls.key" \
  --option="tls certfile = tls/tls.crt" \
  --option="tls cafile = "

cat << EOF > /var/lib/samba/private/tls/tls.key
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCsFUOsurfYh3DR
Iq52VAQpG/L1X5VAAKn8lwTHnfwOkgx68G625D/cYQb368SYgdxpicctuP1d0G91
PMFNz3t0BvWsUhRjw+JJBUfRsrDFWhdL0Uot3UOAJhkotaKTptKscvr5BrUmARmC
rNy49/w7ZuNpIg+i7gfO1gQ58wQp4BsPIDNdDsqcqxiaNy9bnBM5YKFyBXGfxN/O
cqUEICATkk+r6C4UEv5YuAwKbq4eBLEVZ7znOgmQljxzCPSM9N4gD13Hga4JMUXk
Xe6+tRXuQISKiIn4qOMqjemEUzT0APLYbnOC/aKGdVYole/L66zdFq8aERrF5vmp
mpdoCpL5AgMBAAECggEABEiXuYsg1DCj6erQd7TV8S2HTd0aHqCdmqJqPatUuMqh
KabGRMJ4Bfz60s1RRKAX698ggIZ+NRmBCsSvRaf0aWIad7aH2CdqQLnTTLijXphE
Y/Bi5bMgMOaR4gHqeP0yOZV3op8Mf5SPrWFu8aJHqrVgFBADXmGJO3h3nLcsS3wE
jRHfmeBnaim445VZUSXUc7pE+pOiy3JFBLeysPa3TuRn5x0KzJVLbTnh3lHzcPCP
hWyHTd3bvYn2VNVfCDXWGlGqBdhy8XpyqBK5jRO/iAHOgy90GleECLCXQpXmxfji
7K0ckNJkvnHDzN+fd/LkIBcCHxmAQtIm/XBEuplKkQKBgQDeHqxEOjwRmlQi0MBX
H59A6hQrlETmST287J+3dE5LIjbmAahHMa7B1+yw6HX2FHUAlawrEDjSKCZvDCUe
2VyeQcHQ6GereuR3JrwLFF1w8jqzyYybtJCXfAbGfjalRA9SuD18RJI7iIyPXIyz
oITZgQv7U7nj/yWQd/1sT2BESQKBgQDGVMIODMFMO0L2wk5453swBdz+QZ2SF6aL
xHcLWgyEe7W2/Fk4K5nX85gB/QZjlz4ii4iIsilGGKsjuM+m7P2Df1KdwkB4OFzU
75d5Q3jB/qgwNBKeo+Cvm/3MRtYlCe8DY6SPcybqL2W/LyUYEOdaeRxDmORtWsld
fSG45Z95MQKBgBwR0D9HBLRMxnkn3EamTl/LtQTU1egsNUsctApg/kvsZPeoGfX1
R1pjyRuKJO4WI7sRLxK6GBQm0sSRylcdrOCq+q1F0WQQQbL1CCp2RmCxm82AmO5M
YUFjgQ+wf4NfGHiho9OCbuBrHyg2z+kbTe6Wqkb2i7VOVxbssu/vEAFRAoGBAIZH
1KtWj3lhllEj9aV+dLVrAtlS67CCOsze1ArniRoZ+EpQSMfzHVJNJ1oRSkYbnIIf
Hu4OUkuXYCfrdQx74Jkrl3AgmS3MW24AWfpMaHJQTOd2GjU2l2XOo+OvAkZJl34f
9Mb7HBnqxWTQMrk8mKd04GIUHnS7xyJ5Gl/peDPBAoGBANPKh4qxJF0XnQDt2B2Y
vPYOQqURae7vqdUra+LmKOG+pwBiH/896urbpqM280+vGCaz4ITa9K/K8aYlj4+c
iVSRAHQnN8LBizkSGDTnA0LUDjBPb7kEyuT7xSEmCoKiDPpIDxH41TsufoW/woM0
I2CkPTWBNR8lfC9odJgRgLqM
-----END PRIVATE KEY-----
EOF

cat << EOF > /var/lib/samba/private/tls/tls.crt
-----BEGIN CERTIFICATE-----
MIIEUTCCAzmgAwIBAgIUOPesd0JJs/RgkZV+WCvX8uJT1YkwDQYJKoZIhvcNAQEL
BQAwgasxCzAJBgNVBAYTAlJVMRwwGgYDVQQIDBNDaGVseWFiaW5zayBPYmxhc3Qn
MRQwEgYDVQQHDAtDaGVseWFiaW5zazEQMA4GA1UECgwHS2xhbWJyaTEbMBkGA1UE
CwwSS2xhbWJyaSBEZXZlbG9wZXJzMRQwEgYDVQQDDAtrbGFtYnJpLmxhbjEjMCEG
CSqGSIb3DQEJARYUZXZhczFvbi54ZEBnbWFpbC5jb20wHhcNMjQxMjAyMDQ1NzA0
WhcNMjUxMjAyMDQ1NzA0WjCBqzELMAkGA1UEBhMCUlUxHDAaBgNVBAgME0NoZWx5
YWJpbnNrIE9ibGFzdCcxFDASBgNVBAcMC0NoZWx5YWJpbnNrMRAwDgYDVQQKDAdL
bGFtYnJpMRswGQYDVQQLDBJLbGFtYnJpIERldmVsb3BlcnMxFDASBgNVBAMMC2ts
YW1icmkubGFuMSMwIQYJKoZIhvcNAQkBFhRldmFzMW9uLnhkQGdtYWlsLmNvbTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKwVQ6y6t9iHcNEirnZUBCkb
8vVflUAAqfyXBMed/A6SDHrwbrbkP9xhBvfrxJiB3GmJxy24/V3Qb3U8wU3Pe3QG
9axSFGPD4kkFR9GysMVaF0vRSi3dQ4AmGSi1opOm0qxy+vkGtSYBGYKs3Lj3/Dtm
42kiD6LuB87WBDnzBCngGw8gM10OypyrGJo3L1ucEzlgoXIFcZ/E385ypQQgIBOS
T6voLhQS/li4DApurh4EsRVnvOc6CZCWPHMI9Iz03iAPXceBrgkxReRd7r61Fe5A
hIqIifio4yqN6YRTNPQA8thuc4L9ooZ1ViiV78vrrN0WrxoRGsXm+amal2gKkvkC
AwEAAaNrMGkwHQYDVR0OBBYEFBMbCGt91cb8MrG8jrm8K6vRyWPFMB8GA1UdIwQY
MBaAFBMbCGt91cb8MrG8jrm8K6vRyWPFMA8GA1UdEwEB/wQFMAMBAf8wFgYDVR0R
BA8wDYILa2xhbWJyaS5sYW4wDQYJKoZIhvcNAQELBQADggEBAEJRaBUwl4zZVGy2
qSrNYEsZLI6lB6eSVujpTny3dE49qxmUCF0xV7plM6VPcgQzCmXZf6vO3h/0MQul
fOkG50g8khzoXF7FdaJfoP4KHhdlJcSCjkwxttf5ARxPUDs9FfGbBEy8WXzyGSQN
Z/JKVLezwNMkXuaeW59kC9kSdlMWazHkGQawpi49I5YCI4JOUuJTbckSjw+cTrs2
Wa7ukglK1BRAdNqSbGrWeQaZAKpDq3VvJIPJKE7/y02hAVb7DoFmxz3mxmJ8TZur
BQHLJERBj+flWA9lWkCEzZTLab4FpiPt92RvCblFdSQK3vsRZXVs7YrivUPjFr1z
Kwlbu5Q=
-----END CERTIFICATE-----
EOF

chmod 600 /var/lib/samba/private/tls/tls*

systemctl disable --now systemd-resolved
systemctl enable samba-ad-dc
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
echo "Перезапусти виртуальную машину!!"

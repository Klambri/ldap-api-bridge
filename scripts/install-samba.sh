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
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCctQlvQ4p5tK5P
5OB5CBRmh7v5aVBIO3Q4pPK9AnnF1JoFUy34PHzKwCPepD660PKU9uZtX1xNQkFW
xkWDjWiyl0DgKvmbXkI8Cb6gP2Y5gFwHbMRSSJ9GPwaKVnhK6GmnZ8MqimsOQ81R
1XJBwDGvxT2KgFUuBlOq8oQVlsSjBX898VbiO8ddEIcq1CllOEKSyLfaL6QqO4Ur
LcZbwYt09B++BWYZ5WlAaXNn+sKXfBwzt8SufkR2syHikwhkpE3Lu578KFNMg5wn
Esje0eJ/lHodWmgyBwUA5LgffIW1Ri+uvPtHg9Jdqf3jFFEAnNpmkUKcZ80ktyze
FP+otC0PAgMBAAECggEAAa2JZYIi953YgioDEZivhi5A+tza4wTKQ4rKfCXCWVe7
OewNydHuS5rS5388wrVdqQneyAHN7yx31JO75X3hWuroyCfHvzInCoFeam/v+baj
oJCemPt5FEPdR+59WbaAqMj4qOlJ6//IvqqlKj/0zUpIzectfu+9TOoXd5cu24vf
Gb4kF9fGP+0krgUliYaQz7xEWbW47a+qJrFTS1s3Ls3sBbm4R24WW6v33d8bRos3
jnuxhNyahqtbxj1FMVX85I55EteO+mneQkzOZMh9CXa47alJ2RvXiFxVHDcB5JSC
HzdChVQWgz5S1cuG31hfkuEsBtP1WUnmzk5qYsKBWQKBgQDI9ei8UiiLxNkSfuJS
SVSEj0G3/Kos/uUV0aCdlp5IJoERLUJe3nNuWbYIyQGRJPrcEyJJhxLM3foGcKim
Oq8xVMrcX45iGN6nkgAzEqST61lpXq5vaTfK3AtwcAWW77JvzE4JKDcg2teQXl6F
5/mFpHjxnaU1QPx3JEdKdfoqmQKBgQDHoFt/Y66pWisoNeHagwyHBG4S5H5eQqIU
b6kaCy4bXsoyklCu95uvgleIyXTLk/whXuf84s69awwRO49TzRKvG3ApIwdbzrFG
+IynP2X8wFjMptwnYA4i4nPDqO6B3AVgMLsi3uXBkS/GSk/hJcI+66mPRjaXKnFC
c800qLDF5wKBgQCPFgCTbhAujIde0vdETbAe/n11ijKE/SyR34N0EVU73CaT21zh
fZRE4x1one4+sUzou7rzDXjGY9rtEPQT/77T6iLSzDrt//Uw7RS1SLXkGHO+QcsD
yrAOAaUndquUL7EmRxrdDERMYWWRBpBY2bXhgR0YM/34r//SuQMFsoDgKQKBgQDF
tqgIoqTh7IFkAQHhVvw4WYXfxlj2aM54qSL1vW78AsUGk22/7VNP4CtsOgMogjgs
oP/psoWKi5RXGQNav3iq3+UViTEHl85y+Ubtetg7HhKVFwpjITq/CEQZ3J3lFhJo
87rUzakHLxH/Naip2KjrgqLcWXFGBO5KH8F1T0JNrwKBgAp3QWJMwDF+XBJBdI7N
W12bYN2o3fg7ciLe/VSDPp3/IWjJQasgXrP7qGUyGR3TkHHz/6EfadXbiaRj+u5w
Jb9F6EP0TK23zVP0idFhyvIpdldbFHlgoOo6l8LE355XZ8fGaU0xr6bsiKBE/n2C
eTvvHEYUXQ3PpQ7XOOO0m9nj
-----END PRIVATE KEY-----
EOF

cat << EOF > /var/lib/samba/private/tls/tls.crt
-----BEGIN CERTIFICATE-----
MIIENzCCAx+gAwIBAgIUELThNMRcwrIhBSdq5DKRbpupjaUwDQYJKoZIhvcNAQEL
BQAwgaoxCzAJBgNVBAYTAlJVMRwwGgYDVQQIDBNDaGVseWFiaW5zayBPYmxhc3Qn
MRQwEgYDVQQHDAtDaGVsYXliaW5zazEQMA4GA1UECgwHS2xhbWJyaTEaMBgGA1UE
CwwRS2xhbXJpIERldmVsb3BlcnMxFDASBgNVBAMMC2tsYW1icmkubGFuMSMwIQYJ
KoZIhvcNAQkBFhRldmFzMW9uLnhkQGdtYWlsLmNvbTAeFw0yNDEyMDExMjI4MDla
Fw0yNTEyMDExMjI4MDlaMIGqMQswCQYDVQQGEwJSVTEcMBoGA1UECAwTQ2hlbHlh
Ymluc2sgT2JsYXN0JzEUMBIGA1UEBwwLQ2hlbGF5Ymluc2sxEDAOBgNVBAoMB0ts
YW1icmkxGjAYBgNVBAsMEUtsYW1yaSBEZXZlbG9wZXJzMRQwEgYDVQQDDAtrbGFt
YnJpLmxhbjEjMCEGCSqGSIb3DQEJARYUZXZhczFvbi54ZEBnbWFpbC5jb20wggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCctQlvQ4p5tK5P5OB5CBRmh7v5
aVBIO3Q4pPK9AnnF1JoFUy34PHzKwCPepD660PKU9uZtX1xNQkFWxkWDjWiyl0Dg
KvmbXkI8Cb6gP2Y5gFwHbMRSSJ9GPwaKVnhK6GmnZ8MqimsOQ81R1XJBwDGvxT2K
gFUuBlOq8oQVlsSjBX898VbiO8ddEIcq1CllOEKSyLfaL6QqO4UrLcZbwYt09B++
BWYZ5WlAaXNn+sKXfBwzt8SufkR2syHikwhkpE3Lu578KFNMg5wnEsje0eJ/lHod
WmgyBwUA5LgffIW1Ri+uvPtHg9Jdqf3jFFEAnNpmkUKcZ80ktyzeFP+otC0PAgMB
AAGjUzBRMB0GA1UdDgQWBBQNfHPMjWAsnUEbqaIKw6bPuUpsRjAfBgNVHSMEGDAW
gBQNfHPMjWAsnUEbqaIKw6bPuUpsRjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3
DQEBCwUAA4IBAQAAHRAhD3SkJc5BcM86QBHpaIxkcdoK4QI56YOM+LPOddMzfI+j
l8nLCy8g77aUAh8F7tGpVcAJdR4480ISa8reCGiafwhBgTdOp6MQ5FWRsHxEtf1j
dPg/c87csRkMfcUyjvf/gKBK9+821t34jSsVbfSJ2CFhiCxhQETnZSqXZENWicRY
8Kdb9f9YHBNATud3MYAFabgyJoO/mhePcw91+tEpKOXkW8/CkSolC9duqy+gfOxL
smUmz4k9NAPqtKBTRm/6xYKVIC1JTLmsgRZEv7/cz8CiyXR4fqOMtBCdyzmtFlfV
v+DHmnUAJnZbsi/MrM3n+kqVl22JCMRu4SYr
-----END CERTIFICATE-----
EOF

chmod 600 /var/lib/samba/private/tls/tls*

systemctl disable --now systemd-resolved
systemctl enable --now samba-ad-dc
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
echo "Перезапусти виртуальную машину!!"

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
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmGDaOBe6v3YCm
hpD2ftHYRPTxoff8a1poM09//i55lovdvi00j+oOi3xncLRpwMt+2xeku2ua05wP
wnDQrwFmMaB4yHyvoY6DiXW9lD0QUfp4mel++ZoQ5ueCfHFMeZLVt6ONBAoXJZ38
dhfiub1hFqcrV9B6bUK+z2GukuW8w4t2MYfE5WBYSOkIb42sWM83ZLlubatF1RIb
/KF9NO8MohmKgBGqkhIOPmQfKqTkqxivNfWMT+RJvf1g94SdpKdPX5Z790WsfTB3
24fxarlLD6FHEyoEAXCSkr89bQwKaokBwNWMNScs1v8k/uwhMj03QCKXHGSc3L2J
T547G2mpAgMBAAECggEAD1EBSuSCJ8aR1AlpucllGX/2ZIfuoeDWc/BzXta2O3Em
Ebs1WPkCePfk73cFtBDa0yZqDj9YQ21LIWrpU10oEF/4L9sxIFMSHNAiwuo2HVip
89Ahp5tl2TQp2i8WlZpKb5nhI6JhOdQ2tu6+8iH1tEvN+6G78GY99vGRzPLv65Go
tUQUyzLfupK+q9exOPobc5XJfM7EGQuTgv8PLGeD4sOOA2rToV4YigzAAlNqjDqX
ipe4NoWi3ElaN7hmxWaktqfGORtXUAn1fq/k/U3GS6MO2G16Q3kxNYnzIqHckG8d
IB0aVDIfVqotR0HSx1CkcleQRRPXeWkt/3aNhWdIAQKBgQDOWIj/BqUNc/DeuEGd
MeOo/Omq9qCjHUxbysRXYCI+oFTfJRu9vcIwkHacWUhDiLeUAZJlTZeiKDR33IW8
+E6266wovoetadWOgzmNLbZ1YYHmF7vJhoig3Zts89OAKSlaZjuelquf1D6UasGK
PoUgkdbcMCCveKklBNm659nGAQKBgQDOEBdNR5hUL6kK5wx+ZZpNO8M2g9H9775h
G6HMy1p579Sjzxth9YHhMErhdfnlLQ2khlxNPj0wBouN/HcYqrgPYk21FBnR8CB7
qAe4QGZG8dzA8kmaGehbhqkOBYcyRuOLMiQr3pSVRSxBEdXE9WcJwSKX5WaOsH1p
QmCfyOWzqQKBgQC1MGLjZSdLf9IzD6J18NfSjHp2Z+e4M0LYm1z6yGxph4nfA4uv
ec/pqwCr224r9wIUEalGEPMkLZ+c3GQHAhbEYn8iq+Mhb/xZDntbr5c2zS8uJwr7
M4oHj3AqJJRERmCMg5a4c98yEkH9OxzFUo69gbIkWJJq4k3MNs0lZO8CAQKBgAO6
otFRNF6Bpkt+NumqqQowxK2d4RT5W7aiK2FrZK3EO1LjkplJOhp7Jz/BRM5y7EZH
8C+tqqnN1ISzRux5Wm9c1g8q1/TGpa/XMJyS/cbW5anQOKjDQ0M0wqZwTywHwGJq
e+EXXBT/dXeP/RBdaInyps+c5Sg75WkcPGdn2VBRAoGAEttScwhBJSqt1OkiMmMK
tAg5K5o5MsOMrk/cKjJdZYXqLocLQoRGnIFtUwxLc923uke7H02kIuXEdheHQQt4
k9XxC2zCmk3k5xovB/PgihretT3H10ugVfzPh3v1eoLIuQJR3lOu5YK+TMUkXwYF
YD3206jbhRtTVcMzT4P19FE=
-----END PRIVATE KEY-----
EOF

cat << EOF > /var/lib/samba/private/tls/tls.crt
-----BEGIN CERTIFICATE-----
MIIEOzCCAyOgAwIBAgIUPaYEyo2og0feZj+0pS7VoCVyEGkwDQYJKoZIhvcNAQEL
BQAwgawxCzAJBgNVBAYTAlJVMRwwGgYDVQQIDBNDaGVseWFiaW5zayBPYmxhc3Qn
MRQwEgYDVQQHDAtDaGVseWFiaW5zazEUMBIGA1UECgwLRXZhczFvTiBMdGQxGDAW
BgNVBAsMD0RldmVsb3BlciBHcm91cDEUMBIGA1UEAwwLZXZhczFvbi5sYW4xIzAh
BgkqhkiG9w0BCQEWFGV2YXMxb24ueGRAZ21haWwuY29tMB4XDTI0MTEyNzA4MTgy
N1oXDTI1MTEyNzA4MTgyN1owgawxCzAJBgNVBAYTAlJVMRwwGgYDVQQIDBNDaGVs
eWFiaW5zayBPYmxhc3QnMRQwEgYDVQQHDAtDaGVseWFiaW5zazEUMBIGA1UECgwL
RXZhczFvTiBMdGQxGDAWBgNVBAsMD0RldmVsb3BlciBHcm91cDEUMBIGA1UEAwwL
ZXZhczFvbi5sYW4xIzAhBgkqhkiG9w0BCQEWFGV2YXMxb24ueGRAZ21haWwuY29t
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAphg2jgXur92ApoaQ9n7R
2ET08aH3/GtaaDNPf/4ueZaL3b4tNI/qDot8Z3C0acDLftsXpLtrmtOcD8Jw0K8B
ZjGgeMh8r6GOg4l1vZQ9EFH6eJnpfvmaEObngnxxTHmS1bejjQQKFyWd/HYX4rm9
YRanK1fQem1Cvs9hrpLlvMOLdjGHxOVgWEjpCG+NrFjPN2S5bm2rRdUSG/yhfTTv
DKIZioARqpISDj5kHyqk5KsYrzX1jE/kSb39YPeEnaSnT1+We/dFrH0wd9uH8Wq5
Sw+hRxMqBAFwkpK/PW0MCmqJAcDVjDUnLNb/JP7sITI9N0AilxxknNy9iU+eOxtp
qQIDAQABo1MwUTAdBgNVHQ4EFgQUW+vL0qNdBYTDKgDwZewjLfJODgIwHwYDVR0j
BBgwFoAUW+vL0qNdBYTDKgDwZewjLfJODgIwDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAQEAawwLlAUqh2oELssr4+aqhhujhtlez8al2Xt1x/oNtf7U
Ocyd1waxudDqp+cG7RgZZYhdNdNBzj4wSV06E+h1IZfiKvUgnGbeUCfH+Y/RytUU
xuF1hWR1knGUVWVtPNK14zaxM/3X9e7rF2KKtJi6t+s2uRf7Kh+9nIKfSnrztL4+
Msa8pTqtUzRXGyH3SQm10ZwSHKHRuldLuUW66Dxwvp+21mhGWcC7VQUWFQplGSL0
1yBR/4IIIVghFx27bMXD1iNKGMb+TLjaHlDwOvYQaIfbp//AWJ8F8CcFPeEVoaV8
y35+c4GnO+7ImdOmk9C19UsAMLqetaWTJLbXmCRR3w==
-----END CERTIFICATE-----
EOF

chmod 600 /var/lib/samba/private/tls/tls*

systemctl disable --now systemd-resolved
systemctl enable --now samba-ad-dc
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
echo "Перезапусти виртуальную машину!!"

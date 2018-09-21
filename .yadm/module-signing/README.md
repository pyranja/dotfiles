# kernel module signing

> based on https://stegard.net/2016/10/virtualbox-secure-boot-ubuntu-fail/

Generate signing key:

```
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=YOUR_NAME/"
chmod 600 MOK.priv
```

Import MOK and reboot.

```
sudo mokutil --import MOK.der
```

Sign virtual box kernel modules:
```
sudo ./sign-vbox-modules
sudo modprobe vboxdrv
```

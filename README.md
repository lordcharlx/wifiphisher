# About
WiFi Phisher is a security tool that mounts automated victim-customized phishing attacks against WiFi clients in order to obtain credentials or infect the victims with malwares. It is primarily a social engineering attack that unlike other methods it does not include any brute forcing. It is an easy way for obtaining credentials from captive portals and third party login pages (e.g. in social networks) or WPA/WPA2 pre-shared keys.


# How it works
After achieving a man-in-the-middle position using the Evil Twin , Wifiphisher redirects all HTTP requests to an attacker-controlled phishing page.

From the victim's perspective, the attack makes use in three phases:

1. **Victim is being deauthenticated from her access point**. Wifiphisher continuously jams all of the target access point's wifi devices within range by forging “Deauthenticate” or “Disassociate” packets to disrupt existing associations.
2. **Victim joins a rogue access point**. Wifiphisher sniffs the area and copies the target access point's settings. It then creates a rogue wireless access point that is modeled by the target. It also sets up a NAT/DHCP server and forwards the right ports. Consequently, because of the jamming, clients will eventually start connecting to the rogue access point. After this phase, the victim is MiTMed. Furthermore, Wifiphisher listens to probe request frames and spoofs "known" open networks to cause automatic association.
3. **Victim is being served a realistic specially-customized phishing page**. Wifiphisher employs a minimal web server that responds to HTTP & HTTPS requests. As soon as the victim requests a page from the Internet, wifiphisher will respond with a realistic fake page that asks for credentials or serves malwares. This page will be specifically crafted for the victim. For example, a router config-looking page will contain logos of the victim's vendor. The tool supports community-built templates for different phishing scenarios.

# Requirements
Following are the requirements for getting the most out of Wifiphisher:

* Arch Linux. Although people have made Wifiphisher work on other distros, Arch Linux is the officially supported distribution, thus all new features are primarily tested on this platform.
* One wireless network adapter that supports AP mode. Drivers should support netlink.
* One wireless network adapter that supports Monitor mode and is capable of injection. Again, drivers should support netlink.


# Installation

## Tools required :
```
aircrack-ng 
create_ap
apache
php
php-apache
xterm
```

## Install required tools :
```
pacman -S aircrack-ng create_ap apache php php-apache xterm
```

To install the latest development version type the following commands:

```bash
git clone https://github.com/Akhil-Jalagam/wifi-phisher.git # Download the latest revision
cd wifiphisher # Switch to tool's directory
./wifi-attack.sh  # You should be root
```

## Usage

```shell
./wifi-phisher.sh  [Monitor Interface]   [Access Point Interface]
```
# Disclaimer

* Usage of Wifiphisher for attacking infrastructures without prior mutual consistency can be considered as an illegal activity. It is the final user's responsibility to obey all applicable local, state and federal laws. Authors assume no liability and are not responsible for any misuse or damage caused by this program.

<b>Note</b>: Be aware of sites pretending to be related with the Wifiphisher Project. They may be delivering malware.

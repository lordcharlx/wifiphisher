## About
<a href="https://wifiphisher.org">Wifiphisher</a> is a security tool that mounts automated victim-customized phishing attacks against WiFi clients in order to obtain credentials or infect the victims with malwares. It is primarily a social engineering attack that unlike other methods it does not include any brute forcing. It is an easy way for obtaining credentials from captive portals and third party login pages (e.g. in social networks) or WPA/WPA2 pre-shared keys.

Wifiphisher works on any Linux OS (I recommend Arch) and is licensed under the GPL license.

## How it works
After achieving a man-in-the-middle position using the Evil Twin , Wifiphisher redirects all HTTP requests to an attacker-controlled phishing page.

From the victim's perspective, the attack makes use in three phases:

1. **Victim is being deauthenticated from her access point**. Wifiphisher continuously jams all of the target access point's wifi devices within range by forging “Deauthenticate” or “Disassociate” packets to disrupt existing associations.
2. **Victim joins a rogue access point**. Wifiphisher sniffs the area and copies the target access point's settings. It then creates a rogue wireless access point that is modeled by the target. It also sets up a NAT/DHCP server and forwards the right ports. Consequently, because of the jamming, clients will eventually start connecting to the rogue access point. After this phase, the victim is MiTMed. Furthermore, Wifiphisher listens to probe request frames and spoofs "known" open networks to cause automatic association.
3. **Victim is being served a realistic specially-customized phishing page**. Wifiphisher employs a minimal web server that responds to HTTP & HTTPS requests. As soon as the victim requests a page from the Internet, wifiphisher will respond with a realistic fake page that asks for credentials or serves malwares. This page will be specifically crafted for the victim. For example, a router config-looking page will contain logos of the victim's vendor. The tool supports community-built templates for different phishing scenarios.

<p align="center"><img width="70%" src="https://wifiphisher.github.io/wifiphisher/diagram.jpg" /><br /><i>Performing MiTM attack</i></p>

## Requirements
Following are the requirements for getting the most out of Wifiphisher:

* Arch Linux. Although people have made Wifiphisher work on other distros, Arch Linux is the officially supported distribution, thus all new features are primarily tested on this platform.
* One wireless network adapter that supports AP mode. Drivers should support netlink.
* One wireless network adapter that supports Monitor mode and is capable of injection. Again, drivers should support netlink.

Tools required :
aircrack-ng 

create_ap

apache

php

php-apache 

xterm 

Install required tools :

pacman -S aircrack-ng create_ap apache php php-apache xterm

## Installation

To install the latest development version type the following commands:

```bash
git clone https://github.com/Akhil-Jalagam/wifi-phisher.git # Download the latest revision
cd wifiphisher # Switch to tool's directory
./wifi-attack.sh  # You should be root
```

Alternatively, you can download the latest stable version from the <a href="https://github.com/Akhil-Jalagam/wifi-phisher/releases/">Releases page</a>.

## Usage

Run the tool by typing `./wifi-attack` (from inside the tool's directory).

By running the tool without any options, it will find the right interfaces and interactively ask the user to pick the ESSID of the target network (out of a list with all the ESSIDs in the around area) as well as a phishing scenario to perform. By default, the tool will perform both Evil Twin.

***

```shell
./wifi-attack.sh  [Monitor Interface]   [Access Point Interface]
```

Use wlan0 for spawning the rogue Access Point and wlan4 for DoS attacks. Select the target network manually from the list and perform the "Firmware Upgrade" scenario.

Useful for manually selecting the wireless adapters. The <a href="https://wifiphisher.org/ps/firmware-upgrade/">"Firmware Upgrade"</a> scenario is an easy way for obtaining the PSK from a password-protected network.

***

```shell
wifiphisher --essid CONFERENCE_WIFI -p plugin_update -pK s3cr3tp4ssw0rd
```

Automatically pick the right interfaces. Target the Wi-Fi with ESSID "CONFERENCE_WIFI" and perform the "Plugin Update" scenario. The Evil Twin will be password-protected with PSK "s3cr3tp4ssw0rd".

Useful against networks with disclosed PSKs (e.g. in conferences). The <a href="https://wifiphisher.org/ps/plugin_update/">"Plugin Update"</a> scenario provides an easy way for getting the victims to download malicious executables (e.g. malwares containing a reverse shell payload).

***

```shell
wifiphisher --nojamming --essid "FREE WI-FI" -p oauth-login
```

Do not target any network. Simply spawn an open Wi-Fi network with ESSID "FREE WI-FI" and perform the "OAuth Login" scenario.

Useful against victims in public areas. The <a href="https://wifiphisher.org/ps/oauth-login/">"OAuth Login"</a> scenario provides a simple way for capturing credentials from social networks, like Facebook.

***

```shell
python bin/wifiphisher --lure10-capture --nojamming
```

Proceed with only one card (--nojamming) and capture the BSSIDs that are discovered during AP selection phase.

***

```shell
python bin/wifiphisher --lure10-exploit area_20170414_123200 --essid "WiFiSense-Tagged-WLAN"
```

Make nearby Windows devices believe that are within the area that was previously captured with `--lure-capture` by fooling the Windows Location Service. Broadcast a WLAN that is tagged as WiFi-Sense in that area. This will result in automatic association of nearby Windows devices.


Following are all the options along with their descriptions (also available with `wifiphisher -h`):

| Short form | Long form | Explanation |
| :----------: | :---------: | :-----------: |
|-h | --help| show this help message and exit |
|-jI JAMMINGINTERFACE| --jamminginterface JAMMINGINTERFACE|	Manually choose an interface that supports monitor mode for deauthenticating the victims. Example: -jI wlan1|
|-aI APINTERFACE| --apinterface APINTERFACE|	Manually choose an interface that supports AP mode for spawning an AP. Example: -aI wlan0|
|-nJ| --nojamming|	Skip the deauthentication phase. When this option is used, only one wireless interface is required|
|-e ESSID| --essid ESSID|	Enter the ESSID of the rogue Access Point. This option will skip Access Point selection phase. Example: --essid 'Free WiFi'|
|-p PHISHINGSCENARIO| --phishingscenario PHISHINGSCENARIO	|Choose the phishing scenario to run.This option will skip the scenario selection phase. Example: -p firmware_upgrade|
|-pK PRESHAREDKEY| --presharedkey PRESHAREDKEY|	Add WPA/WPA2 protection on the rogue Access Point. Example: -pK s3cr3tp4ssw0rd|
|-qS| --quitonsuccess|	Stop the script after successfully retrieving one pair of credentials.|
|-lC| --lure10-capture| Capture the BSSIDs of the APs that are discovered during AP selection phase. This option is part of Lure10 attack.
|-lE LURE10_EXPLOIT |--lure10-exploit LURE10_EXPLOIT| Fool the Windows Location Service of nearby Windows users to believe it is within an area that was previously captured with --lure10-capture. Part of the Lure10 attack.|
|-iAM| --mac-ap-interface| Specify the MAC address of the AP interface. Example: -iAM 38:EC:11:00:00:00|
|-iDM| --mac-deauth-interface| Specify the MAC address of the jamming interface. Example: -iDM E8:2A:EA:00:00:00|
|-iNM| --no-mac-randomization| Do not change any MAC address.|
|-hC|--handshake-capture|Capture of the WPA/WPA2 handshakes for verifying passphrase. Example: -hC capture.pcap|
|-dE|--deauth-essid|Deauth all the BSSIDs having same ESSID from AP selection or the ESSID given by -e option.|


## Screenshots

<p align="center"><img src="https://wifiphisher.github.io/wifiphisher/ss5.png" /><br /><i>Targeting an access point</i></p>
<p align="center"><img src="https://wifiphisher.github.io/wifiphisher/ss2.png" /><br /><i>A successful attack</i></p>
<p align="center"><img src="https://wifiphisher.github.io/wifiphisher/ss7.png" /><br /><i>Fake <a href="https://wifiphisher.org/ps/firmware-upgrade/">router configuration page</a></i></p>
<p align="center"><img src="https://wifiphisher.github.io/wifiphisher/ss6.png" /><br /><i>Fake <a href="https://wifiphisher.org/ps/oauth-login/">OAuth Login Page</a></i></p>
<p align="center"><img src="https://wifiphisher.github.io/wifiphisher/ss4.png" /><br /><i>Fake <a href="https://wifiphisher.org/ps/wifi_connect/">web-based network manager</a></i></p>

## License
Wifiphisher is licensed under the GPL license. See [LICENSE](LICENSE) for more information.

## Disclaimer
* Authors do not own the logos under the `wifiphisher/data/` directory. Copyright Disclaimer Under Section 107 of the Copyright Act 1976, allowance is made for "fair use" for purposes such as criticism, comment, news reporting, teaching, scholarship, and research.

* Usage of Wifiphisher for attacking infrastructures without prior mutual consistency can be considered as an illegal activity. It is the final user's responsibility to obey all applicable local, state and federal laws. Authors assume no liability and are not responsible for any misuse or damage caused by this program.

<b>Note</b>: Be aware of sites pretending to be related with the Wifiphisher Project. They may be delivering malware.

For Wifiphisher news, follow us on <a href="https://www.twitter.com/wifiphisher">Twitter</a> or like us on <a href="https://www.facebook.com/Wifiphisher-129914317622032/">Facebook</a>.

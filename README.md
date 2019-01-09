# Community Hass.io Add-ons: Tor

[![GitHub Release][releases-shield]][releases]
![Project Stage][project-stage-shield]
[![License][license-shield]](LICENSE.md)

[![GitLab CI][gitlabci-shield]][gitlabci]
![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]

[![Discord][discord-shield]][discord]
[![Community Forum][forum-shield]][forum]

[![Buy me a coffee][buymeacoffee-shield]][buymeacoffee]

[![Support my work on Patreon][patreon-shield]][patreon]

Protect your privacy and access Home Assistant via Tor.

## About

This Tor add-on allows you to access you Home Assistant instance as an Onion site,
trough [Tor's Hidden Service][tor-hidden-service] feature. With this feature
enabled, you do not need to open your firewall ports or setup HTTPS to enable
secure remote access.

This is useful if you want to have:

- Access your Home Assistant instance remotely without opening a firewall port
  or setting up a VPN.
- Don’t want to or know how to get an SSL/TLS certificate and HTTPS
  configuration setup.
- Want to block attackers from even being able to access/scan your port and
  server at all.
- Want to block anyone from knowing your home IP address and seeing your
  traffic to your Home Assistant.

The add-on also offers the possibility to open a Sock proxy into the
Tor network. Allowing you to access Tor from any of your (SOCKS supporting)
applications through your Hass.io installation.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add our Hass.io add-ons repository][repository] to your Hass.io instance.
1. Install the "Tor" add-on.
1. Start the "Tor" add-on
1. Check the logs of the "Tor" add-on to see if everything went well. The log
  will also display your Tor .onion address.

**NOTE**: Do not add this repository to Hass.io, please use:
`https://github.com/hassio-addons/repository`.

## Docker status

[![Docker Architecture][armhf-arch-shield]][armhf-dockerhub]
[![Docker Version][armhf-version-shield]][armhf-microbadger]
[![Docker Layers][armhf-layers-shield]][armhf-microbadger]
[![Docker Pulls][armhf-pulls-shield]][armhf-dockerhub]
[![Anchore Image Overview][armhf-anchore-shield]][armhf-anchore]

[![Docker Architecture][aarch64-arch-shield]][aarch64-dockerhub]
[![Docker Version][aarch64-version-shield]][aarch64-microbadger]
[![Docker Layers][aarch64-layers-shield]][aarch64-microbadger]
[![Docker Pulls][aarch64-pulls-shield]][aarch64-dockerhub]
[![Anchore Image Overview][aarch64-anchore-shield]][aarch64-anchore]

[![Docker Architecture][amd64-arch-shield]][amd64-dockerhub]
[![Docker Version][amd64-version-shield]][amd64-microbadger]
[![Docker Layers][amd64-layers-shield]][amd64-microbadger]
[![Docker Pulls][amd64-pulls-shield]][amd64-dockerhub]
[![Anchore Image Overview][amd64-anchore-shield]][amd64-anchore]

[![Docker Architecture][i386-arch-shield]][i386-dockerhub]
[![Docker Version][i386-version-shield]][i386-microbadger]
[![Docker Layers][i386-layers-shield]][i386-microbadger]
[![Docker Pulls][i386-pulls-shield]][i386-dockerhub]
[![Anchore Image Overview][i386-anchore-shield]][i386-anchore]

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```json
{
  "log_level": "info",
  "socks": true,
  "hidden_services": true,
  "stealth": true,
  "client_names": [
    "haremote1",
    "haremote2"
  ],
  "ports": [
    8123
  ]
```

**Note**: _This is just an example, don't copy and past it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`:  Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

These log level also affects the log levels of the Tor program.

### Option: `socks`

Setting this option to `true` opens port `9050` to listen for connections from
SOCKS-speaking applications. Enabling this feature allows you to use other
applications on your network to use the Tor network.

**Note**: _The SOCKS protocol is unencrypted and (as we use it) unauthenticated,
so exposing it in this way could leak your information to anybody watching your
network, and allow anybody to use your computer as an open proxy._

### Option: `hidden_services`

The `hidden_services` options allows you to enable
[Tor's Hidden Service][tor-hidden-service] feature in this add-on. You can offer
a web server, SSH server, etc., without revealing your IP address to its users.
In fact, because you don not use any public address, you can run a hidden
service from behind your firewall.

### Option: `stealth`

The “stealth” entry above ensures traffic to and from your Home Assistant
instance over Tor is hidden even from other nodes on the Tor network.

Using a traditional Hidden Service, a hidden server publishes in the Tor network
how to begin communication with it (not its real location). Tor uses a complex
middle nodes link setup for bidirectional route anonymization; the server and
client knows nothing about end point's location. A client asks the network how
to reach a Hidden Service with this info.

This option put the Tor Hidden Service in the authorize client mode. The
hidden server publishes encrypted instructions on how to begin the
communication, a client with the right key can decipher this info.
If you are an authorized client, you only can locate the Hidden Service path
and then try to establish a connection if you have this key.

Enabling `stealth` can prevent a DDOS because if the client does not have the
key, it can not find the path to the server. It does, however, require
configuration of the client as well.

### Option: `client_name`

This option is required as soon as you enable the `stealth` option.

Only clients that are listed here are authorized to access the hidden service.
Valid client names are 1 to 16 characters long and only use characters in
`A-Za-z0-9+-_` (no spaces). If this option is set, the hidden service is not
accessible for clients without authorization anymore.

Clients need to put this authorization data in their configuration file using
HidServAuth.

### Option: `ports`

Configures hosts and ports to publish via a Tor Hidden Service.
You can list multiple hosts and ports to publish.

For example:

```json
  "ports": [
    "homeassistant:8123:80",
    22
  ]
```

The accepted syntaxs of this configuration is:

- hostname:local_port:published_port `"homeassistant:8123:8080"`
- local_ip:local_port:published_port `"192.168.1.60:8123:8080"`
- hostname:local_port `"homeassistant:8123"`
- local_port:published_port `"8123:8080"`
- local_port `"8123"`

If you do not define a published port, the local port will be used.
If you do not define a hostname or IP adress `homeassistant` will be used.

## Tor client access setup

Using this add-on, you can access your Home Assistant instance over Tor from
your laptop or mobile device, using Tor Browser and other software.

However, with the `stealth` option enabled, the client would need extra
configuration to be able to connect.

Add the authentication cookie to your `torrc` client configuration on your
laptop or mobile device. It would look like this:

```bash
HidServAuth abcdef1234567890.onion adEG02FAsdq/GAFeNSeLvc haremote1
```

For Tor Browser on Windows, Mac or Linux, you can find the torrc file here:
`<tor browser install directory>/Browser/TorBrowser/Data/Tor/torrc`

Once you have added the entry, restart the browser, and then browse to the
"dot onion" site address to connect to your Home Assistant instance.

For [Orbot: Tor on Android][orbot], add it in **Orbot** -> **Menu**
-> **Settings** to the "Torrc Custom Config" entry. Restart Orbot, and then
use the [Orfox browser app][orfox], and browse to the "dot onion" site name to
access your Home Assistant instance. You can also use Orbot's VPN mode,
to enable Tor access from any application on your device,
such as Tasker or Owntracks.

To our knowledge, there are currently no iOS apps available supporting the
stealth feature.

You can use the standard FireFox browser to access .onion domains, but you need
to enable this in FireFix settings. In FireFox, type "about:config" in the
address bar and click 'I accept the risk' to open the advanced settings.
Search for "onion" to find the setting "network.dns.blockDotOnion" and toggle
the setting so that it is set to "false". Now you should be able to access
.onion sites.

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality. The format of the log is based on
[Keep a Changelog][keepchangelog].

Releases are based on [Semantic Versioning][semver], and use the format
of ``MAJOR.MINOR.PATCH``. In a nutshell, the version will be incremented
based on the following:

- ``MAJOR``: Incompatible or major changes.
- ``MINOR``: Backwards-compatible new features and enhancements.
- ``PATCH``: Backwards-compatible bugfixes and package updates.

## Support

Got questions?

You have several options to get them answered:

- The [Community Hass.io Add-ons Discord chat server][discord] for add-on
  support and feature requests.
- The [Home Assistant Discord chat server][discord-ha] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] GitHub.

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We have set up a separate document containing our
[contribution guidelines](CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Authors & contributors

The original setup of this repository is by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## We have got some Hass.io add-ons for you

Want some more functionality to your Hass.io Home Assistant instance?

We have created multiple add-ons for Hass.io. For a full list, check out
our [GitHub Repository][repository].

## License

MIT License

Copyright (c) 2017 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[aarch64-anchore-shield]: https://anchore.io/service/badges/image/21aff221e4aecaddc5808d54f7b89442e735985d58fa1d52f97ffca288bfc3a6
[aarch64-anchore]: https://anchore.io/image/dockerhub/hassioaddons%2Ftor-aarch64%3Alatest
[aarch64-arch-shield]: https://img.shields.io/badge/architecture-aarch64-blue.svg
[aarch64-dockerhub]: https://hub.docker.com/r/hassioaddons/tor-aarch64
[aarch64-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/tor-aarch64.svg
[aarch64-microbadger]: https://microbadger.com/images/hassioaddons/tor-aarch64
[aarch64-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/tor-aarch64.svg
[aarch64-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/tor-aarch64.svg
[amd64-anchore-shield]: https://anchore.io/service/badges/image/c03172a85eff910fa4a21419d377a587fcc1ded0b15e19973fa4397be14ae3b0
[amd64-anchore]: https://anchore.io/image/dockerhub/hassioaddons%2Ftor-amd64%3Alatest
[amd64-arch-shield]: https://img.shields.io/badge/architecture-amd64-blue.svg
[amd64-dockerhub]: https://hub.docker.com/r/hassioaddons/tor-amd64
[amd64-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/tor-amd64.svg
[amd64-microbadger]: https://microbadger.com/images/hassioaddons/tor-amd64
[amd64-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/tor-amd64.svg
[amd64-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/tor-amd64.svg
[armhf-anchore-shield]: https://anchore.io/service/badges/image/b0b6630d7f5ba437c3099dea54c2739de2d643235ed5c85aa20a01d9837d06c9
[armhf-anchore]: https://anchore.io/image/dockerhub/hassioaddons%2Ftor-armhf%3Alatest
[armhf-arch-shield]: https://img.shields.io/badge/architecture-armhf-blue.svg
[armhf-dockerhub]: https://hub.docker.com/r/hassioaddons/tor-armhf
[armhf-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/tor-armhf.svg
[armhf-microbadger]: https://microbadger.com/images/hassioaddons/tor-armhf
[armhf-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/tor-armhf.svg
[armhf-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/tor-armhf.svg
[buymeacoffee-shield]: https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg
[buymeacoffee]: https://www.buymeacoffee.com/frenck
[commits-shield]: https://img.shields.io/github/commit-activity/y/hassio-addons/addon-tor.svg
[commits]: https://github.com/hassio-addons/addon-tor/commits/master
[contributors]: https://github.com/hassio-addons/addon-tor/graphs/contributors
[discord-ha]: https://discord.gg/c5DvZ4e
[discord-shield]: https://img.shields.io/discord/478094546522079232.svg
[discord]: https://discord.me/hassioaddons
[forum-shield]: https://img.shields.io/badge/community-forum-brightgreen.svg
[forum]: https://community.home-assistant.io/t/community-hass-io-add-on-tor/33822?u=frenck
[frenck]: https://github.com/frenck
[gitlabci-shield]: https://gitlab.com/hassio-addons/addon-tor/badges/master/pipeline.svg
[gitlabci]: https://gitlab.com/hassio-addons/addon-tor/pipelines
[home-assistant]: https://home-assistant.io
[i386-anchore-shield]: https://anchore.io/service/badges/image/82c4fde4af525422d3e1e706676882b93abf4b8bf7345d70c86e64737cc9fb81
[i386-anchore]: https://anchore.io/image/dockerhub/hassioaddons%2Ftor-i386%3Alatest
[i386-arch-shield]: https://img.shields.io/badge/architecture-i386-blue.svg
[i386-dockerhub]: https://hub.docker.com/r/hassioaddons/tor-i386
[i386-layers-shield]: https://images.microbadger.com/badges/image/hassioaddons/tor-i386.svg
[i386-microbadger]: https://microbadger.com/images/hassioaddons/tor-i386
[i386-pulls-shield]: https://img.shields.io/docker/pulls/hassioaddons/tor-i386.svg
[i386-version-shield]: https://images.microbadger.com/badges/version/hassioaddons/tor-i386.svg
[issue]: https://github.com/hassio-addons/addon-tor/issues
[keepchangelog]: http://keepachangelog.com/en/1.0.0/
[license-shield]: https://img.shields.io/github/license/hassio-addons/addon-tor.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2018.svg
[orbot]: https://guardianproject.info/apps/orbot
[orfox]: https://guardianproject.info/apps/orfox
[patreon-shield]: https://www.frenck.nl/images/patreon.png
[patreon]: https://www.patreon.com/frenck
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-brightgreen.svg
[reddit]: https://reddit.com/r/homeassistant
[releases-shield]: https://img.shields.io/github/release/hassio-addons/addon-tor.svg
[releases]: https://github.com/hassio-addons/addon-tor/releases
[repository]: https://github.com/hassio-addons/repository
[semver]: http://semver.org/spec/v2.0.0.htm
[tor-hidden-service]: https://www.torproject.org/docs/hidden-services.html.en

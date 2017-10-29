#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Listen for connections from SOCKS-speaking applications (or not)
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if hass.config.true 'socks'; then
    echo 'SOCKSPort 9050' >> /etc/tor/torrc
else
    echo 'SOCKSPort 0' >> /etc/tor/torrc
fi

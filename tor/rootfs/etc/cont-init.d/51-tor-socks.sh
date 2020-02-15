#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Tor
# Listen for connections from SOCKS-speaking applications (or not)
# ==============================================================================
if bashio::config.true 'socks'; then
    echo 'SOCKSPort 0.0.0.0:9050' >> /etc/tor/torrc
else
    echo 'SOCKSPort 0' >> /etc/tor/torrc
fi

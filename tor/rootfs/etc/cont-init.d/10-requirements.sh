#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# This files check if all user configuration requirements are met
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# A hidden service without any ports is kinda useless
if hass.config.true 'hidden_services' && ! hass.config.has_value 'ports'; then
    hass.die 'Hidden services where enabled, but without ports!'
fi

# Checks if client names where configured when using stealth mode
if hass.config.true 'hidden_services' \
    && hass.config.true 'stealth' \
    && ! hass.config.has_value 'client_names';
then
    hass.die 'Stealth is enabled, but no client names where set.'
fi

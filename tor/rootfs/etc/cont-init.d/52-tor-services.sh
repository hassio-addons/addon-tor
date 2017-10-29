#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Configures the hidden services
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare virtual_port
declare target_port
declare -a client_names

if hass.config.true 'hidden_services'; then
    echo 'HiddenServiceDir /ssl/tor/hidden_service' >> /etc/tor/torrc

    for port in $(hass.config.get 'ports'); do
        if [[ "${port}" = *':'* ]]; then
            virtual_port="${port%%:*}"
            target_port="${port#*:}"
        else
            virtual_port="${port}"
            target_port="${port}"
        fi

        echo "HiddenServicePort ${target_port} homeassistant:${virtual_port}" \
            >> /etc/tor/torrc
    done

    if hass.config.true 'stealth'; then
        client_names=($(hass.config.get 'client_names'))
        IFS=','
        echo "HiddenServiceAuthorizeClient stealth ${client_names[*]}" \
            >> /etc/tor/torrc
    fi

    echo 'HiddenServiceAllowUnknownPorts 0' >> /etc/tor/torrc
fi

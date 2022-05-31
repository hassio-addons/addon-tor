#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Tor
# Configures the hidden services
# ==============================================================================
declare virtual_port
declare target_port
declare port
declare host
declare clientname

readonly torrc='/etc/tor/torrc'

if bashio::config.true 'hidden_services'; then
    echo 'HiddenServiceDir /ssl/tor/hidden_service' >> "$torrc"
    echo 'HiddenServiceVersion 3' >> "$torrc"
    for port in $(bashio::config 'ports'); do
        count=$(echo "${port}" | sed 's/[^:]//g'| awk '{ print length }')
        if [[ "${count}" == 0 ]]; then
            host='homeassistant'
            virtual_port="${port}"
            target_port="${port}"
        elif [[ "${count}" == 1 ]]; then
            # Check if format is hostname/ip:port or port:port
            first=$(echo "${port}" | cut -f1 -d:)
            if [[ "${first}" =~ ^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]) ]]; then
                host='homeassistant'
                virtual_port=$(echo "${port}" | cut -f1 -d:)
                target_port=$(echo "${port}" | cut -f2 -d:)
            else
                host=$(echo "${port}" | cut -f1 -d:)
                virtual_port=$(echo "${port}" | cut -f2 -d:)
                target_port=$(echo "${port}" | cut -f2 -d:)
            fi
        elif [[ "${count}" == 2 ]]; then
            host=$(echo "${port}" | cut -f1 -d:)
            virtual_port=$(echo "${port}" | cut -f2 -d:)
            target_port=$(echo "${port}" | cut -f3 -d:)
        else
            bashio::log.warning "$port Are not correct format, skipping..."
        fi
        if [[ "${count}" -le 2 ]]; then
            echo "HiddenServicePort ${target_port} ${host}:${virtual_port}" \
                >> "$torrc"
        fi
    done

    if bashio::config.true 'stealth'; then
        while read -r clientname; do
            echo "HiddenServiceAuthorizeClient stealth $clientname" >> "$torrc"
        done <<< "$(bashio::config 'client_names')"
    fi

    echo 'HiddenServiceAllowUnknownPorts 0' >> "$torrc"
fi
if bashio::config.true 'relay'; then
    echo 'ExitPolicy' "$(bashio::config 'exitPolicy')" >> "$torrc"
    echo 'BridgeRelay 0' >> "$torrc"
    echo 'ContactInfo ' $(bashio::config 'contactInfo') >> "$torrc"
    echo 'Nickname ' "$(bashio::config 'relayNickName')"  >> "$torrc"
    echo 'ORPort ' $(bashio::config 'relayOrPort') >> "$torrc"
    echo 'RelayBandwidthRate '$(bashio::config 'relayBandwidthRate') >> "$torrc"
    echo 'RelayBandwidthBurst '$(bashio::config 'relayBandwidthBurst') >> "$torrc"
fi

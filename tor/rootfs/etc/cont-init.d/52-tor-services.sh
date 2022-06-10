#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Tor
# Configures the hidden services
# ==============================================================================
declare clientname
declare host
declare port
declare key
declare private_key
declare public_key
declare target_port
declare virtual_port

readonly hidden_service_dir='/ssl/tor/hidden_service'
readonly authorized_clients_dir="${hidden_service_dir}/authorized_clients"
readonly clients_dir="${hidden_service_dir}/clients"
readonly torrc='/etc/tor/torrc'


if bashio::config.true 'hidden_services'; then
    echo "HiddenServiceDir ${hidden_service_dir}" >> "$torrc"
    
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
        # Following the documentation at:
        # https://community.torproject.org/onion-services/advanced/client-auth/
        while read -r clientname; do
            # Generate key is they do not exist yet
            if ! bashio::fs.file_exists "${authorized_clients_dir}/${clientname}.auth"
            then 
                key=$(openssl genpkey -algorithm x25519)

                private_key=$(
                    sed \
                        -e '/----.*PRIVATE KEY----\|^[[:space:]]*$/d' \
                        <<< "${key}" \
                        | base64 -d \
                        | tail -c 32 \
                        | base32 \
                        | sed 's/=//g'
                )

                # Public
                public_key=$(
                    openssl pkey -pubout \
                    <<< "${key}" \
                    | sed -e '/----.*PUBLIC KEY----\|^[[:space:]]*$/d' \
                    | base64 -d \
                    | tail -c 32 \
                    | base32 \
                    | sed 's/=//g'
                )

                # Create authorized client file
                echo "descriptor:x25519:${public_key}" \
                    > "${clients_dir}/${clientname}.auth"
                echo "descriptor:x25519:${public_key}" \
                    > "${authorized_clients_dir}/${clientname}.auth"

                # Create private key file
                echo "descriptor:x25519:${public_key}" \
                    > "${clients_dir}/${clientname}.auth_private"

                bashio::log.red
                bashio::log.red
                bashio::log.red "Created keys for ${clientname}!"
                bashio::log.red
                bashio::log.red "Keys are stored in:"
                bashio::log.red "${clients_dir}"
                bashio::log.red
                bashio::log.red "Public key":
                bashio::log.red "${public_key}"
                bashio::log.red
                bashio::log.red "Private key:"
                bashio::log.red "${private_key}"
                bashio::log.red
                bashio::log.red 
            else
                bashio::log.info "Keys for ${clientname} already exists; skipping..."
            fi
        done <<< "$(bashio::config 'client_names')"
    fi

    echo 'HiddenServiceAllowUnknownPorts 0' >> "$torrc"
fi

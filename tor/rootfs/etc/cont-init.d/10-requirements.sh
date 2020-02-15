#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Tor
# This files check if all user configuration requirements are met
# ==============================================================================

# A hidden service without any ports is kinda useless
if bashio::config.true 'hidden_services' \
    && ! bashio::config.has_value 'ports'; then
    bashio::log.fatal
    bashio::log.fatal 'Add-on configuration is incomplete.'
    bashio::log.fatal
    bashio::log.fatal 'Hidden services where enabled, using the'
    bashio::log.fatal '"hidden_services" add-on configuration option,'
    bashio::log.fatal 'But the "port" option does not contain any values!'
    bashio::log.fatal
    bashio::log.fatal 'Please configure the "ports" option.'
    bashio::exit.nok
fi

# Checks if client names where configured when using stealth mode
if bashio::config.true 'hidden_services' \
    && bashio::config.true 'stealth' \
    && ! bashio::config.has_value 'client_names';
then
    bashio::log.fatal
    bashio::log.fatal 'Add-on configuration is incomplete.'
    bashio::log.fatal
    bashio::log.fatal 'Stealth mode is enabled, using the "stealth" add-on'
    bashio::log.fatal 'configuration option, but there are no client names'
    bashio::log.fatal 'configured in the "client_names" add-on option.'
    bashio::log.fatal
    bashio::log.fatal 'Please configure the "client_names" option.'
    bashio::exit.nok
fi

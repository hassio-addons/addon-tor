#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Sets the correct log level to the Tor configuration
# ==============================================================================
declare log_level

# Find the matching Tor log level
if bashio::config.has_value 'log_level'; then
    case "$(bashio::string.lower "$(bashio::config 'log_level')")" in
        all|trace)
            log_level="debug"
            ;;
        debug)
            log_level="info"
            ;;
        info|notice)
            log_level="notice"
            ;;
        warning)
            log_level="warn"
            ;;
        error|fatal|off)
            log_level="err"
            ;;
    esac

    echo "Log ${log_level} stdout" >> /etc/tor/torrc
fi

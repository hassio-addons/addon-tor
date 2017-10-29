#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Sets the correct log level to the Tor configuration
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare log_level

# Find the matching Tor log level
case "$(hass.string.lower "$(hass.config.get 'log_level')")" in
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

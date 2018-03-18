# Community Hass.io Add-ons: Tor

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog][keep-a-changelog]
and this project adheres to [Semantic Versioning][semantic-versioning].

## Unreleased

No unreleased changed yet.

## [v1.2.0] (2018-03-18)

[Full Changelog][v1.1.1-v1.2.0]

### Added

- Adds add-on icon

### Changed

- Upgrades add-on base image to v1.3.3
- Optimizes add-on logo

## [v1.1.1] (2018-01-19)

[Full Changelog][v1.1.0-v1.1.1]

### Changed

- Upgrades add-on base image to v1.3.2

## [v1.1.0] (2018-01-09)

[Full Changelog][v1.0.0-v1.1.0]

### Fixed

- Fixes an issue with the Tor SOCKS proxy

### Changed

- Removes Microbadger notification hooks
- Prevents possible future Docker login issue
- Pass local CircleCI Docker socket into the build container
- Use image tagged as test as a cache resource
- Updated maintenance year, it is 2018
- Upgrades add-on base image to v1.3.1

## [v1.0.0] (2017-12-03)

[Full Changelog][v0.1.1-v1.0.0]

### Changed

- Promoted project stage to "production ready"
- Upgrades add-on base image to v1.2.0
- Improves tor S6 run script
- Updates add-on URLs to new community forum URL
- Moves copy of rootfs at a later stage

### Fixed

- Added Auth cookies in example torcc file #1 (@gerard33)

### Removed

- Removes `repository.json` to prevent user to install wrong repo
- Removes Gratipay from README, since it is EOL

## [v0.1.1] (2017-11-08)

[Full Changelog][v0.1.0-v0.1.1]

### Changed

- Authentication cookies will now be displayed in the add-on logs

## [v0.1.0] (2017-10-29)

### Added

- Initial release

[keep-a-changelog]: http://keepachangelog.com/en/1.0.0/
[semantic-versioning]: http://semver.org/spec/v2.0.0.html
[v0.1.0-v0.1.1]: https://github.com/hassio-addons/addon-tor/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/hassio-addons/addon-tor/tree/v0.1.0
[v0.1.1-v1.0.0]: https://github.com/hassio-addons/addon-tor/compare/v0.1.1...v1.0.0
[v0.1.1]: https://github.com/hassio-addons/addon-tor/tree/v0.1.1
[v1.0.0-v1.1.0]: https://github.com/hassio-addons/addon-tor/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/hassio-addons/addon-tor/tree/v1.0.0
[v1.1.0-v1.1.1]: https://github.com/hassio-addons/addon-tor/compare/v1.1.0...v1.1.1
[v1.1.0]: https://github.com/hassio-addons/addon-tor/tree/v1.1.0
[v1.1.1-v1.2.0]: https://github.com/hassio-addons/addon-tor/compare/v1.1.1...v1.2.0
[v1.1.1]: https://github.com/hassio-addons/addon-tor/tree/v1.1.1
[v1.2.0]: https://github.com/hassio-addons/addon-tor/tree/v1.2.0

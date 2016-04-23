name             'geoip_auto_update'
description      'Installs GeoIP database products from MaxMind and sets up automation to keep it up to date'
maintainer       'Rapid River Software'
maintainer_email 'nathan@rrsoft.co'
license          'Apache 2.0'
version          '0.0.1'

recipe 'geoip_auto_update', 'Installs GeoIP database products from MaxMind and sets up automation to keep it up to date'

#supports 'debian' # untested.. please let us know if it works for you!
supports 'ubuntu'

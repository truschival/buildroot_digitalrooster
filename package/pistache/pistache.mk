################################################################################
#
# Pistache
#
################################################################################

PISTACHE_VERSION = 394b17c01f928bb
PISTACHE_SITE = https://github.com/oktal/pistache.git
PISTACHE_SITE_METHOD = git

PISTACHE_INSTALL_STAGING = YES
PISTACHE_INSTALL_TARGET = YES
PISTACHE_LICENSE = Apache-2.0
PISTACHE_LICENSE_FILE = LICENSE

PISTACHE_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

$(eval $(cmake-package))

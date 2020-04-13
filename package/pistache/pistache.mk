################################################################################
#
# Pistache
#
################################################################################

PISTACHE_VERSION = 73f248acd6db4c53
PISTACHE_SOURCE = $(PISTACHE_VERSION).tar.gz
PISTACHE_SITE = https://github.com/oktal/pistache/archive
PISTACHE_SITE_METHOD = wget

PISTACHE_INSTALL_STAGING = YES
PISTACHE_INSTALL_TARGET = YES
PISTACHE_LICENSE = Apache-2.0
PISTACHE_LICENSE_FILE = LICENSE

PISTACHE_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release -DPISTACHE_USE_SSL=On

$(eval $(cmake-package))

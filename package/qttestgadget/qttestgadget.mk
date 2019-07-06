################################################################################
#
# QtTestGadget
#
################################################################################

ifeq (y , $(BR2_PACKAGE_QTTESTGADGET_VERSION_DEVEL))
	QTTESTGADGET_VERSION = develop
	QTTESTGADGET_SITE = https://github.com/truschival/QtTestGadget.git
	QTTESTGADGET_SITE_METHOD = git
else
	QTTESTGADGET_VERSION = v0.0.1
	QTTESTGADGET_SOURCE = $(QTTESTGADGET_VERSION).tar.gz
	QTTESTGADGET_SITE = https://github.com/truschival/QtTestGadget/archive
	QTTESTGADGET_SITE_METHOD = wget
endif

QTTESTGADGET_INSTALL_STAGING = YES
QTTESTGADGET_INSTALL_TARGET = YES
QTTESTGADGET_LICENSE = GPL-3.0+
QTTESTGADGET_LICENSE_FILES = LICENSE

# Debug config
ifeq (y, $(BR2_PACKAGE_QTTESTGADGET_DEBUG))
	QTTESTGADGET_CONF_OPTS += -G "Eclipse CDT4 - Unix Makefiles"
	QTTESTGADGET_CONF_OPTS += -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=true
	QTTESTGADGET_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
endif

$(eval $(cmake-package))

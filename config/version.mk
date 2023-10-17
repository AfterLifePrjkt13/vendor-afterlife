PRODUCT_VERSION_MAJOR = 3
PRODUCT_VERSION_MINOR = 0

ifeq ($(AFTERLIFE_VERSION_APPEND_TIME_OF_DAY),true)
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AFTERLIFE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# versioning
AFTERLIFE_CODENAME := Envy

# Check Official
ifndef AFTERLIFE_BUILD_TYPE
    AFTERLIFE_BUILD_TYPE := UNOFFICIAL
endif

AFTERLIFE_VERSION_SUFFIX := $(AFTERLIFE_BUILD_TYPE)-$(AFTERLIFE_BUILD)-$(AFTERLIFE_BUILD_DATE)

# Internal version
AFTERLIFE_VERSION := V$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(AFTERLIFE_CODENAME)-$(AFTERLIFE_VERSION_SUFFIX)-$(AFTERLIFE_ZIP_TYPE)

# Display version
AFTERLIFE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(AFTERLIFE_VERSION_SUFFIX)

# Codename version
AFTERLIFE_DISPLAY_VERSION_CODENAME := 13.3|EOL

# Props
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.afterlife.version=$(AFTERLIFE_DISPLAY_VERSION_CODENAME) \
  ro.afterlife.releasevarient=$(AFTERLIFE_ZIP_TYPE) \
  ro.afterlife.releasetype=$(AFTERLIFE_BUILD_TYPE) \
  ro.afterlife.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
  ro.afterlife.version.codename=$(AFTERLIFE_CODENAME)

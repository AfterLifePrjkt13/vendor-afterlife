# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# AfterLife System Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.afterlife.version=$(AFTERLIFE_VERSION) \
    ro.afterlife.releasetype=$(AFTERLIFE_BUILD_TYPE) \
    ro.afterlife.releasevarient=$(AFTERLIFE_ZIP_TYPE) \
    ro.afterlife.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.afterlife.version.codename=$(AFTERLIFE_CODENAME) \
    ro.afterlife.version.extra=$(AFTERLIFE_VERSION_EXTRA)

# AfterLife Platform Display Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.afterlife.display.version=$(AFTERLIFE_DISPLAY_VERSION_CODENAME)

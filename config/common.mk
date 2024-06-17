# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= AfterLife

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.usb.config=adb
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.usb.config=none

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/afterlife/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/afterlife/prebuilt/common/bin/50-afterlife.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-afterlife.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-afterlife.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/afterlife/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/afterlife/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Some permissions
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml

# AfterLife-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/etc/init/init.afterlife-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.afterlife-system_ext.rc

# App lock permission
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Overlay
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

ifneq ($(TARGET_DISABLE_EPPE),true)
# Require all requested packages to exist
$(call enforce-product-packages-exist-internal,$(wildcard device/*/$(AFTERLIFEBUILD)/$(TARGET_PRODUCT).mk),product_manifest.xml rild Calendar Launcher3 Launcher3Go Launcher3QuickStep Launcher3QuickStepGo android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
endif

# Call Recording
ifneq ($(TARGET_CALL_RECORDING_SUPPORTED),false)
PRODUCT_COPY_FILES += \
    vendor/afterlife/config/permissions/com.google.android.apps.dialer.call_recording_audio.features.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.google.android.apps.dialer.call_recording_audio.features.xml
endif

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# One Handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Disable remote keyguard animation
PRODUCT_SYSTEM_PROPERTIES += \
    persist.wm.enable_remote_keyguard_animation=0

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/afterlife/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Pixel customization
TARGET_SUPPORTS_GOOGLE_BATTERY ?= false

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/afterlife-ui/overlay/common

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/afterlife/build/target/product/security/afterlife

# Audio
include vendor/afterlife/config/afterlife_audio.mk

# Bootanimation
include vendor/afterlife/config/afterlife_bootanimation.mk

# Packages
include vendor/afterlife/config/afterlife_packages.mk

# Signed
include vendor/afterlife/config/afterlife_signed.mk

# Overlays Themes
include packages/overlays/Themes/themes.mk

# Versioning
include vendor/afterlife/config/version.mk

-include vendor/afterlife-priv/keys/keys.mk

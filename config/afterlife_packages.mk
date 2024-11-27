# LawnIcons
ifeq ($(TARGET_PREBUILTS_LAWNICONS),true)
    $(call inherit-product-if-exists, vendor/prebuilts/LawnIcons/config.mk)
endif

# AfterEcho
ifeq ($(TARGET_USE_ECHO),true)
    $(call inherit-product-if-exists, vendor/dolby/afterlife/afterlife.mk)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.dolby.enabled=1
else
PRODUCT_PRODUCT_PROPERTIES += \
    ro.dolby.enabled=0
endif

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# ExactCalculator
PRODUCT_PACKAGES += \
    ExactCalculator

# Etar
PRODUCT_PACKAGES += \
    Etar

# Extra tools in AfterLife
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

# Faceunlock
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace

#Omni
PRODUCT_PACKAGES += \
    OmniJaws \
    OmniStyle

# Overlay
PRODUCT_PACKAGES += \
    CustomFontPixelLauncherOverlay \
    DocumentsUIOverlay \
    NetworkStackOverlay

# PocketMode
PRODUCT_PACKAGES += \
    PocketMode

PRODUCT_COPY_FILES += \
    vendor/afterlife/pocket/privapp-permissions-pocketmode.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-pocketmode.xml

# Protobuf - Workaround for prebuilt Qualcomm HAL
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

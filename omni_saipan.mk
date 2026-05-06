#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/omni/config/common.mk)

# Inherit from saipan device
$(call inherit-product, device/motorola/saipan/device.mk)

PRODUCT_DEVICE := saipan
PRODUCT_NAME := omni_saipan
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g(50) 5G
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="saipan_retail-user 12 S1RSS32.38-20-9-13 125d12 release-keys"

BUILD_FINGERPRINT := motorola/saipan_retail/saipan:12/S1RSS32.38-20-9-13/125d12:user/release-keys

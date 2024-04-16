#!/bin/sh

# if [ "$1" = "nvidia" ]; then

  # export LIBVA_DRIVER_NAME=nvidia
  # export GBM_BACKEND=nvidia-drm
  # export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export WLR_BACKEND=vulkan
  export WLR_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1
# else
  # export WLR_DRM_DEVICES=/dev/dri/card0
# fi

Hyprland

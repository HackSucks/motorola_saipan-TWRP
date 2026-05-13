#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# TWRP Device Tree for Motorola Moto G(50) 5G

<p align="center">
  <img src="https://fdn2.gsmarena.com/vv/pics/motorola/motorola-moto-g50-5g-1.jpg" alt="Motorola Moto G(50) 5G" width="300"/>
</p>

## Device specifications

| Feature | Specification |
|---------|--------------|
| **Chipset** | MediaTek Dimensity 700 (MT6833) |
| **Architecture** | arm64-v8a / armeabi-v7a |
| **CPU** | Octa-core Cortex-A55 |
| **Screen density** | 280 dpi |
| **Boot partition** | 40 MB |
| **Dynamic partitions** | system, system_ext, vendor, product |
| **A/B (seamless)** | Yes |
| **Codename** | saipan |

## Status

> [!WARNING]
> **TWRP builds successfully but has NOT been tested on real hardware.**
> Flash at your own risk. Please report your findings!

### Build status

| Component | Status |
|-----------|--------|
| Compiles | ✅ Yes |
| Boots on device | ❓ Untested |
| Touch works | ❓ Untested |
| Decryption | ❓ Untested |
| MTP | ❓ Untested |
| Backup/Restore | ❓ Untested |

## Calling all testers! 📢

This device tree has been built but never flashed on real hardware. If you own a **Motorola Moto G(50) 5G (saipan)** and are willing to test, your help is greatly appreciated!

Please open an [issue](https://github.com/HackSucks/motorola_saipan-TWRP/issues) or submit a pull request with your findings. Report what works, what doesn't, and any logs you can capture. Every bit of feedback helps.

---

## Building

There are two ways to build: via **GitHub Actions** (easy, no local setup needed) or **locally** (full control, faster iteration).

### Option 1 — GitHub Actions (recommended for contributors)

If you've forked or have contributor access to this repo, you can trigger a build directly from the browser without installing anything.

1. Navigate to the [**Actions**](https://github.com/HackSucks/motorola_saipan-TWRP/actions/workflows/main.yml) tab of the repository.
2. Click **"Run workflow"** on the right-hand side.
3. Choose whether to do a **clean build** (wipes the workspace and starts from scratch) or reuse a cached build.
4. Click the green **"Run workflow"** button.

The workflow runs on `ubuntu-22.04`, handles the full build environment setup, syncs the TWRP manifest, clones this device tree, and produces `boot.img` as a downloadable artifact. A build log is also uploaded for debugging.

> **Note:** A full clean build takes roughly **35–40 minutes** on GitHub-hosted runners. Subsequent runs that reuse a cached workspace are much faster.

The output artifact will be named `TWRP-Saipan-12.1-YYYYMMDD` and contains `boot.img`.

---

### Option 2 — Build locally

#### System requirements

| Requirement | Minimum |
|-------------|---------|
| **OS** | Ubuntu 22.04 LTS (or equivalent) |
| **RAM** | 16 GB (32 GB recommended) |
| **Disk space** | 150 GB free (250 GB recommended) |
| **CPU cores** | 8+ (more = faster build) |
| **Python** | Python 3 (`python-is-python3`) |

#### Install build dependencies

```bash
sudo apt-get update
sudo apt-get install -y \
  git-core gnupg flex bison build-essential \
  zip curl libc6-dev libncurses5-dev \
  libx11-dev lib32z1-dev libgl1-mesa-dev \
  libxml2-utils xsltproc unzip python3 \
  libssl-dev bc ccache lz4 schedtool \
  python-is-python3 rsync
```

#### Install the `repo` tool

```bash
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Sync the minimal TWRP manifest

```bash
mkdir twrp && cd twrp
repo init --depth=1 \
  -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git \
  -b twrp-12.1
repo sync -c -j$(nproc) --no-clone-bundle --no-tags --optimized-fetch --prune
```

#### Clone the device tree

```bash
git clone https://github.com/HackSucks/motorola_saipan-TWRP.git \
  -b android-12.1 \
  --depth=1 \
  device/motorola/saipan
```

#### Build

```bash
export ALLOW_MISSING_DEPENDENCIES=true
export USE_CCACHE=1
source build/envsetup.sh
lunch omni_saipan-eng
mka bootimage
```

> **Note:** This device tree uses a **prebuilt kernel** (`prebuilt/kernel` and `prebuilt/dtb.img`). You do not need a separate kernel source tree.

The output image will be at:

```
out/target/product/saipan/boot.img
```

---

## Flashing

> [!CAUTION]
> Always back up your data before flashing anything. This is experimental software.

Since the Moto G(50) 5G uses **A/B (seamless updates)**, TWRP is embedded in the boot partition rather than a dedicated recovery partition:

```bash
adb reboot bootloader
fastboot flash boot out/target/product/saipan/boot.img
fastboot reboot
```

To test without permanently flashing:

```bash
fastboot boot out/target/product/saipan/boot.img
```

---

## Device tree structure

| File / Folder | Purpose |
|---------------|---------|
| `BoardConfig.mk` | Board-level build configuration |
| `device.mk` | Device feature/package declarations |
| `omni_saipan.mk` | Top-level product makefile |
| `recovery.fstab` | Filesystem mount table for recovery |
| `prebuilt/` | Prebuilt kernel and DTB image |
| `recovery/root/` | Recovery root filesystem overlays |
| `.github/workflows/main.yml` | CI build workflow (manual trigger) |

## Notes

- Platform: `mt6833` (MediaTek Dimensity 700)
- Security patch hack set to `2099-12-31` to prevent anti-rollback blocking
- AVB (Android Verified Boot) is enabled; vbmeta flags set to `3`
- TWRP theme: `portrait_hdpi`
- Kernel cmdline: `bootopt=64S3,32N2,64N2 buildvariant=user`
- Build target is `bootimage` (`mka bootimage`) — not `recoveryimage` — because this is an A/B device

## Credits

- [SebaUbuntu](https://github.com/sebaUbuntu) — TWRP device tree generator
- [TeamWin](https://github.com/TeamWin) — TWRP project
- [HackSucks](https://github.com/HackSucks) — Maintainer

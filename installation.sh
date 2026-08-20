#!/bin/bash

# ============================================================
# QIIME 2 Installation
# macOS - Apple Silicon (M1 / M2 / M3 / M4)
#
# Official installation:
# https://library.qiime2.org/quickstart/qiime2
# ============================================================


# ============================================================
# 1. INSTALL MINICONDA
# ============================================================

# Download and install Miniconda from:
# https://www.anaconda.com/docs/getting-started/miniconda/install

# After installing Miniconda, initialize conda:

conda init


# Close and reopen the terminal after running conda init.

# OR  INSTALL MINICONDA FROM TERMINAL
# ============================================================

# Download Miniconda for Apple Silicon (ARM64)

curl -L -o ~/miniconda.sh \ https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh

# Install Miniconda silently

bash ~/miniconda.sh -b -p "path/miniconda3"

# Remove installer

rm ~/miniconda.sh

# Initialize conda for zsh

"path/miniconda3/bin/conda" init zsh

# Reload shell configuration
source ~/.zshrc



# ============================================================
# 2. CHECK CONDA INSTALLATION
# ============================================================

conda --version


# ============================================================
# 3. UPDATE CONDA
# ============================================================

conda update conda


# ============================================================
# 4. CREATE QIIME 2 ENVIRONMENT
#
# Apple Silicon uses the x86_64 (osx-64) QIIME 2 build
# through Rosetta 2.
#
# QIIME 2 version used in the official current instructions:
# 2026.7
# ============================================================

CONDA_SUBDIR=osx-64 conda env create \
  --name rachis-qiime2-2026.7 \
  --file https://raw.githubusercontent.com/qiime2/distributions/refs/heads/dev/2026.7/qiime2/released/rachis-qiime2-osx-64-conda.yml


# ============================================================
# 5. ACTIVATE QIIME 2 ENVIRONMENT
# ============================================================

conda activate rachis-qiime2-2026.7


# ============================================================
# 6. CONFIGURE THE ENVIRONMENT FOR osx-64
# ============================================================

conda config --env --set subdir osx-64


# ============================================================
# 7. VERIFY QIIME 2 INSTALLATION
# ============================================================

conda deactivate

conda activate rachis-qiime2-2026.7

qiime info
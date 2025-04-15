#!/bin/bash

set -euo pipefail

# Export updated conda environment (Mac)

echo "[Export Conda] Preparing to export conda environment..."

if command -v conda &> /dev/null; then
  eval "$(conda shell.bash hook)"
else
  echo "Conda not found in PATH"
  exit 1
fi

# Export updated conda environment (Mac)
pushd python > /dev/null
echo "[Export Conda] Exporting conda environment to conda-env.yml..."
CONDA_ENV_REL_PATH="../../../../backend/conda-env.yml"
CONDA_LOCK_REL_PATH="../../../../backend/conda-lock.yml"
conda activate smartride-backend
conda env export --no-build | iconv -f utf-8 -t utf-8 > "$CONDA_ENV_REL_PATH"
echo "[Export Conda] Post-processing formats and generating platform selectors..."
python conda_channel_cleaner.py "$CONDA_ENV_REL_PATH"
# python conda_depver_remover.py $CONDA_ENV_REL_PATH
python conda_platform_analyzer.py "$CONDA_ENV_REL_PATH" --no_cache_output
python conda_pips_filler.py "$CONDA_ENV_REL_PATH"
python conda_yml_formatter.py "$CONDA_ENV_REL_PATH"
echo "[Export Conda] Locking conda environment..."
conda-lock lock --mamba \
  --file "$CONDA_ENV_REL_PATH" \
  --platform win-64 \
  --platform linux-64 \
  --platform osx-64 \
  --lockfile "$CONDA_LOCK_REL_PATH" 1>/dev/null
popd > /dev/null

echo "[Export Conda] The conda environment is successfully exported."
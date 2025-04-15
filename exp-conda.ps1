Set-StrictMode -Version Latest

# Export updated conda environment (Windows)
Push-Location python

Write-Host "[Export Conda] Exporting conda environment to conda-env.yml..."
$env:CONDA_ENV_REL_PATH = "../../../../backend/conda-env.yml"
$env:CONDA_LOCK_REL_PATH = "../../../../backend/conda-lock.yml"
conda activate smartride-backend
conda env export --from-history | Out-File $env:CONDA_ENV_REL_PATH -Encoding utf8
Write-Host "[Export Conda] Post-processing formats and generating platform selectors..."
python conda_channel_cleaner.py $env:CONDA_ENV_REL_PATH
python conda_depver_remover.py $env:CONDA_ENV_REL_PATH
python conda_platform_analyzer.py $env:CONDA_ENV_REL_PATH --no_cache_output
python conda_pips_filler.py $env:CONDA_ENV_REL_PATH
python conda_yml_formatter.py $env:CONDA_ENV_REL_PATH
Write-Host "[Export Conda] Locking conda environment..."
conda-lock lock --mamba `
  --file $env:CONDA_ENV_REL_PATH `
  --platform win-64 `
  --platform linux-64 `
  --platform osx-64 `
  --lockfile $env:CONDA_LOCK_REL_PATH 2>&1 1>$null
Pop-Location

Write-Host "[Export Conda] The conda environment is successfully exported."
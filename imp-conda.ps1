Set-StrictMode -Version Latest

Write-Host "[Import Conda] Importing newest update on smartride-backend conda environment..."

Push-Location "$PSScriptRoot/../../../backend"
conda activate base
# conda-lock is sometimes buggy
mamba env update -f conda-env.yml -n smartride-backend
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install/update conda environment. Aborting."
    Pop-Location
    exit 1
}
conda activate smartride-backend
Pop-Location

$hashFile = "$PSScriptRoot\parameters\last-import"

$originHash = git rev-parse origin/main
Set-Content -Path $hashFile -Value $originHash
Write-Host "[Import Conda] Conda is successfully imported."
# Copies this repo's mod and layout into the Herdr app's config folder.
# The repo is the source of truth; the copy is what runs. Saving main.js there
# hot-reloads the mod, so re-run this after every edit.
#
#   .\install.ps1                # mod + layout
#   .\install.ps1 -SkipLayout    # mod only
#   .\install.ps1 -Switch        # also make my-layout the shown layout
[CmdletBinding()]
param(
  [switch]$SkipLayout,
  [switch]$Switch
)
$ErrorActionPreference = 'Stop'

$home_ = if ($env:HERDR_APP_HOME) { $env:HERDR_APP_HOME } else { Join-Path $env:USERPROFILE '.config\herdr-app' }
if (-not (Test-Path $home_)) { throw "Herdr app folder not found: $home_" }

$modSrc = Join-Path $PSScriptRoot 'mods\my-spaces'
$modDst = Join-Path $home_ 'mods\my-spaces'
New-Item -ItemType Directory -Force -Path $modDst | Out-Null
# Only our files: the app writes gpui-kit.d.ts and jsconfig.json itself.
foreach ($f in 'main.js', 'mod.json') {
  Copy-Item -Force (Join-Path $modSrc $f) (Join-Path $modDst $f)
}
Write-Host "mod    -> $modDst"

if (-not $SkipLayout) {
  $layDst = Join-Path $home_ 'layouts'
  New-Item -ItemType Directory -Force -Path $layDst | Out-Null
  Copy-Item -Force (Join-Path $PSScriptRoot 'layouts\my-layout.json') (Join-Path $layDst 'my-layout.json')
  Write-Host "layout -> $layDst\my-layout.json"
}

if ($Switch) { & herdr-app do layout.switch '{"name":"my-layout"}' }

& herdr-app check $modDst
exit $LASTEXITCODE

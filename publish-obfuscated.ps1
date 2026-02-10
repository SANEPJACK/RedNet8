param(
  [ValidateSet("Debug", "Release")]
  [string]$Configuration = "Release",

  [string]$RuntimeIdentifier = "win-x64",

  [switch]$KeepPdb
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$project = Join-Path $root "RedSkullNet8.csproj"
$config = Join-Path $root "obfuscar.xml"

if ($Configuration -ne "Release" -or $RuntimeIdentifier -ne "win-x64") {
  throw "This script currently supports -Configuration Release -RuntimeIdentifier win-x64 (matches obfuscar.xml)."
}

if (!(Test-Path -LiteralPath $project)) {
  throw "Project not found: $project"
}
if (!(Test-Path -LiteralPath $config)) {
  throw "Obfuscar config not found: $config"
}

Push-Location $root
try {
  dotnet tool restore | Out-Host

  # Build first so we have RedSkull.dll in bin\<Configuration>\net8.0-windows\<rid>\
  dotnet build $project -c $Configuration -r $RuntimeIdentifier | Out-Host

  $tfm = "net8.0-windows"
  $outDir = Join-Path $root ("bin\{0}\{1}\{2}" -f $Configuration, $tfm, $RuntimeIdentifier)

  $dll = Join-Path $outDir "RedSkull.dll"
  if (!(Test-Path -LiteralPath $dll)) {
    throw "Build output not found: $dll"
  }

  $dllBackup = "$dll.bak"
  Copy-Item -LiteralPath $dll -Destination $dllBackup -Force

  try {
    # Run obfuscation (writes to OutPath configured in obfuscar.xml)
    dotnet tool run obfuscar.console -- $config | Out-Host

    $obfDll = Join-Path $outDir "obfuscated\RedSkull.dll"
    if (!(Test-Path -LiteralPath $obfDll)) {
      throw "Obfuscated dll not found: $obfDll"
    }

    # Replace build output with obfuscated assembly, then publish without rebuilding.
    Copy-Item -LiteralPath $obfDll -Destination $dll -Force

    dotnet publish $project -c $Configuration -r $RuntimeIdentifier --no-build | Out-Host

    $publishDir = Join-Path $outDir "publish"
    if (!(Test-Path -LiteralPath $publishDir)) {
      throw "Publish output not found: $publishDir"
    }

    if (-not $KeepPdb) {
      Remove-Item -LiteralPath (Join-Path $publishDir "RedSkull.pdb") -Force -ErrorAction SilentlyContinue
    }

    Write-Host ""
    Write-Host ("Obfuscated publish output: {0}" -f $publishDir)
  }
  finally {
    # Restore the original (non-obfuscated) DLL so Debug/Dev stays normal.
    if (Test-Path -LiteralPath $dllBackup) {
      Copy-Item -LiteralPath $dllBackup -Destination $dll -Force
      Remove-Item -LiteralPath $dllBackup -Force
    }
  }
}
finally {
  Pop-Location
}

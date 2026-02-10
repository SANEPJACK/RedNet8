สั่ง build
dotnet build .\RedSkullNet8.csproj -c Release
ถ้าจะ publish แบบ single-file
dotnet publish .\RedSkullNet8.csproj -c Release


publish แบบ obfuscate
powershell -NoProfile -ExecutionPolicy Bypass -File .\publish-obfuscated.ps1
publish-obfuscated.cmd
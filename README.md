# RedSkullNet8

## Build

```powershell
dotnet build .\RedSkullNet8.csproj -c Release
```

## Publish (Single-file)

```powershell
dotnet publish .\RedSkullNet8.csproj -c Release
```

Output:
- `bin\Release\net8.0-windows\win-x64\publish\RedSkull.exe`

## Publish (Obfuscated)

วิธีง่ายสุด:

```bat
publish-obfuscated.cmd
```

หรือถ้าจะรันตรงด้วย PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\publish-obfuscated.ps1
```

Output:
- `bin\Release\net8.0-windows\win-x64\publish\RedSkull.exe`

หมายเหตุ:
- สคริปต์จะลบ `RedSkull.pdb` ออกจากโฟลเดอร์ `publish` (ไม่ควรแจก PDB ให้คนอื่น)
- ไฟล์ map ที่ Obfuscar สร้าง (`bin\Release\net8.0-windows\win-x64\obfuscated\Mapping.txt`) ไม่ควรแจก


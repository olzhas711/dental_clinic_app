# Firebase Setup Script

# Проверка и установка Node.js
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Downloading Node.js LTS..."
    $nodeInstaller = "$env:TEMP\node-installer.msi"
    Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi" -OutFile $nodeInstaller
    Start-Process msiexec.exe -Wait -ArgumentList "/i $nodeInstaller /qn"
    Remove-Item $nodeInstaller
}

# Обновление PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Установка Firebase CLI
npm install -g firebase-tools

# Установка FlutterFire CLI
dart pub global activate flutterfire_cli

Write-Host "Firebase setup complete. Please run 'firebase login' manually and follow the prompts."

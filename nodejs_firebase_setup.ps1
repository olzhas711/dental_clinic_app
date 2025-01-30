# Node.js и Firebase Setup Script

# Функция загрузки и установки Node.js
function Install-NodeJS {
    $nodeInstallerUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi"
    $nodeInstallerPath = "$env:TEMP\nodejs_installer.msi"

    Write-Host "Downloading Node.js..."
    Invoke-WebRequest -Uri $nodeInstallerUrl -OutFile $nodeInstallerPath

    Write-Host "Installing Node.js..."
    Start-Process msiexec.exe -Wait -ArgumentList "/i $nodeInstallerPath /qn"

    # Обновление PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Проверка Node.js
try {
    $nodeVersion = node --version
    Write-Host "Node.js already installed: $nodeVersion"
}
catch {
    Write-Host "Node.js not found. Installing..."
    Install-NodeJS
}

# Установка Firebase CLI
npm install -g firebase-tools

# Проверка установки
firebase --version

Write-Host "Setup complete. Please run 'firebase login' manually."

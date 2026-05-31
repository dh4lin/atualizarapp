Write-Host "Localizando Steam..." -ForegroundColor Cyan

$steamPath = (Get-ItemProperty "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath

if (-not $steamPath) {
    Write-Host "Steam não encontrada!" -ForegroundColor Red
    Pause
    exit
}

Write-Host "Steam encontrada em: $steamPath" -ForegroundColor Green

$pluginPath = Join-Path $steamPath "plugins\luatools"
$publicPath = Join-Path $pluginPath "public"

# Verificar se LuaTools existe
if (-not (Test-Path $pluginPath)) {
    Write-Host "LuaTools não encontrado!" -ForegroundColor Red
    Pause
    exit
}

# Criar diretórios se necessário
New-Item -ItemType Directory -Force -Path "$publicPath\themes" | Out-Null
New-Item -ItemType Directory -Force -Path "$steamPath\steamui\LuaTools\themes" | Out-Null
New-Item -ItemType Directory -Force -Path "$pluginPath\backend\locales" | Out-Null

Write-Host "Copiando arquivos..." -ForegroundColor Yellow

# luatools.js
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/luatools.js" `
    -OutFile "$steamPath\steamui\LuaTools\luatools.js"

Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/luatools.js" `
    -OutFile "$pluginsPath\luatools.js"

# luatools-icon.png
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/luatools-icon.png" `
    -OutFile "$steamPath\steamui\LuaTools\luatools-icon.png"

Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/luatools-icon.png" `
    -OutFile "$pluginsPath\luatools\luatools-icon.png"

# escuro.css
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/escuro.css" `
    -OutFile "$steamPath\steamui\LuaTools\themes\escuro.css"

Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/escuro.css" `
    -OutFile "$steamPath\plugins\luatools\themes"

# themes.json
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/themes.json" `
    -OutFile "$pluginsPath\themes\themes.json"

# backend completo
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/backend" `
    -OutFile "$env:TEMP\pasta.zip"

Remove-Item "$pluginsPath\plugins\luatools" `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue

Expand-Archive `
    "$env:TEMP\pasta.zip" `
    "$pluginsPath\plugins\luatools" `
    -Force
}

Write-Host ""
Write-Host "Instalação concluída com sucesso!" -ForegroundColor Green
Write-Host ""
Pause


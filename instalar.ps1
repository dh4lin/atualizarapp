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
Copy-Item ".\luatools.js" `
    "$steamPath\steamui\LuaTools\" `
    -Force

Copy-Item ".\luatools.js" `
    "$publicPath\" `
    -Force

# luatools-icon.png
Copy-Item ".\luatools-icon.png" `
    "$steamPath\steamui\LuaTools\" `
    -Force

Copy-Item ".\luatools-icon.png" `
    "$publicPath\" `
    -Force

# escuro.css
Copy-Item ".\escuro.css" `
    "$publicPath\themes\" `
    -Force

Copy-Item ".\escuro.css" `
    "$steamPath\steamui\LuaTools\themes\" `
    -Force

# themes.json
Copy-Item ".\themes.json" `
    "$publicPath\themes\" `
    -Force

# pt-BR.json
Copy-Item ".\pt-BR.json" `
    "$pluginPath\backend\locales\" `
    -Force

# backend completo
if (Test-Path ".\backend") {
    Remove-Item "$pluginPath\backend" `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue

    Copy-Item ".\backend" `
        "$pluginPath\" `
        -Recurse `
        -Force
}

Write-Host ""
Write-Host "Instalação concluída com sucesso!" -ForegroundColor Green
Write-Host ""
Pause


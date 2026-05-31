Write-Host "Localizando Steam..." -ForegroundColor Cyan
$steamPath = (Get-ItemProperty "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath

if (-not $steamPath) {
    Write-Host "Steam não encontrada!" -ForegroundColor Red
    Pause
    exit
}

Write-Host "Steam encontrada em: $steamPath" -ForegroundColor Green

# Definição dos caminhos base (Corrigido para usar a mesma variável sempre)
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
    -OutFile "$pluginPath\luatools.js"

# luatools-icon.png
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/luatools-icon.png" `
    -OutFile "$steamPath\steamui\LuaTools\luatools-icon.png"
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/luatools-icon.png" `
    -OutFile "$pluginPath\luatools-icon.png"

# escuro.css
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/escuro.css" `
    -OutFile "$steamPath\steamui\LuaTools\themes\escuro.css"
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/escuro.css" `
    -OutFile "$pluginPath\themes\escuro.css"

# themes.json
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/themes.json" `
    -OutFile "$pluginPath\themes\themes.json"

# backend completo (Nota: baixar um repositório/pasta direto do GitHub via link bruto pode não funcionar se não for um arquivo .zip real hospedado lá)
Invoke-WebRequest `
    "https://raw.githubusercontent.com/dh4lin/atualizarapp/main/backend" `
    -OutFile "$env:TEMP\pasta.zip"

Remove-Item "$pluginPath\backend" `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue

# Extrai o conteúdo do zip diretamente para a pasta do backend
Expand-Archive `
    "$env:TEMP\pasta.zip" `
    -DestinationPath "$pluginPath\backend" `
    -Force

Write-Host ""
Write-Host "Instalação concluída com sucesso!" -ForegroundColor Green
Write-Host ""
Pause

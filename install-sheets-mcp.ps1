# ============================================================
# 4A 工作坊 · 一鍵把 Google Sheets 接進 Claude Code（Windows）
#   用法： .\install-sheets-mcp.ps1 "C:\gsheets-key\service-account.json"
#   自動讀出 project id、自動接好 mcp-gsheets，你不用碰設定檔。
# ============================================================
param([string]$KeyPath)

if (-not $KeyPath) {
  Write-Host "X 請在後面放你下載的 JSON 金鑰路徑，例如："
  Write-Host '   .\install-sheets-mcp.ps1 "C:\gsheets-key\service-account.json"'
  Write-Host "   （小技巧：對 JSON 檔按住 Shift + 右鍵 -> 複製為路徑）"
  exit 1
}
if (-not (Test-Path $KeyPath)) {
  Write-Host "X 找不到這個檔案：$KeyPath"
  exit 1
}
$Abs = (Resolve-Path $KeyPath).Path -replace '\\','/'
$ProjId = (Get-Content $Abs -Raw | ConvertFrom-Json).project_id
if (-not $ProjId) {
  Write-Host "X 這個 JSON 裡找不到 project_id——確認下載的是「服務帳戶金鑰」JSON。"
  exit 1
}

Write-Host "> 專案 ID：$ProjId"
Write-Host "> 金鑰路徑：$Abs"
Write-Host "> 接線中…"
claude mcp add mcp-gsheets -s user `
  -e GOOGLE_PROJECT_ID=$ProjId `
  -e GOOGLE_APPLICATION_CREDENTIALS=$Abs `
  -- cmd /c npx -y mcp-gsheets@latest

Write-Host ""
Write-Host "[OK] 接好了！重開 Claude Code，打： claude mcp list"
Write-Host "     看到 mcp-gsheets 已連線 就成功（第一次可能等 ~30 秒下載套件）。"

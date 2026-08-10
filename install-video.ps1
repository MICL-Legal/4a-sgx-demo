# ============================================================
# 4A 工作坊 · 一句話影片機（MoneyPrinterTurbo）一鍵安裝（Windows）
#   下載專案 + 裝好相依套件；跑完照畫面提示啟動 WebUI。
#   只做安裝，不外傳任何東西；內容明碼可讀。
# ============================================================
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "▸ 一句話影片機：開始下載＋安裝（會跑幾分鐘，正常）..."
Set-Location $HOME
if (-not (Test-Path "MoneyPrinterTurbo")) {
    git clone --depth 1 https://github.com/harry0703/MoneyPrinterTurbo.git
} else {
    Write-Host "  （已經有 MoneyPrinterTurbo 資料夾，跳過下載）"
}
Set-Location MoneyPrinterTurbo
uv python install 3.11
uv sync --frozen
if (-not (Test-Path "config.toml")) { Copy-Item config.example.toml config.toml }
Write-Host ""
Write-Host "[完成] 裝好了！"
Write-Host "啟動影片機：打這兩行，瀏覽器會自動打開："
Write-Host "     cd `$HOME\MoneyPrinterTurbo"
Write-Host "     .\webui.bat"
Write-Host "進畫面後在左邊貼上 Gemini 金鑰＋Pexels 金鑰，打一句主題就能生片。"
Write-Host ""

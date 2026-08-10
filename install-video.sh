#!/usr/bin/env bash
# ============================================================
# 4A 工作坊 · 一句話影片機（MoneyPrinterTurbo）一鍵安裝
#   下載專案 + 裝好相依套件；跑完照畫面提示啟動 WebUI。
#   只做安裝，不外傳任何東西；內容明碼可讀。
# ============================================================
set -euo pipefail

echo ""
echo "▸ 一句話影片機：開始下載＋安裝（會跑幾分鐘，正常）..."
cd "$HOME"
if [ ! -d "MoneyPrinterTurbo" ]; then
  git clone --depth 1 https://github.com/harry0703/MoneyPrinterTurbo.git
else
  echo "  （已經有 MoneyPrinterTurbo 資料夾，跳過下載）"
fi
cd MoneyPrinterTurbo
uv python install 3.11
uv sync --frozen
[ -f config.toml ] || cp config.example.toml config.toml
echo ""
echo "✅ 裝好了！"
echo "👉 啟動影片機：打這行、按 Enter，瀏覽器會自動打開："
echo "     cd ~/MoneyPrinterTurbo && sh webui.sh"
echo "   進畫面後在左邊貼上 Gemini 金鑰＋Pexels 金鑰，打一句主題就能生片。"
echo ""

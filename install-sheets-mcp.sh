#!/usr/bin/env bash
# ============================================================
# 4A 工作坊 · 一鍵把「Google Sheets」接進 Claude Code（Mac / Linux）
#   用法： bash install-sheets-mcp.sh ~/gsheets-key/service-account.json
#   它會自動讀出 project id、自動接好 mcp-gsheets，你不用碰設定檔。
#   只做這一件事；不外傳任何東西；內容明碼可讀。
# ============================================================
set -euo pipefail

KEY="${1:-}"
if [ -z "$KEY" ]; then
  echo "❌ 請在後面放你下載的 JSON 金鑰路徑，例如："
  echo "   bash install-sheets-mcp.sh ~/gsheets-key/service-account.json"
  echo "   （小技巧：把 JSON 檔直接拖進終端機，會自動貼上路徑）"
  exit 1
fi
KEY="${KEY/#\~/$HOME}"
if [ ! -f "$KEY" ]; then
  echo "❌ 找不到這個檔案：$KEY"
  echo "   確認路徑對不對（可把 JSON 檔拖進終端機自動貼路徑）。"
  exit 1
fi
ABS="$(cd "$(dirname "$KEY")" && pwd)/$(basename "$KEY")"

# 從 JSON 自動讀出 project_id（優先用 python3，退而用 grep）
PID="$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["project_id"])' "$ABS" 2>/dev/null || true)"
if [ -z "$PID" ]; then
  PID="$(grep -o '"project_id"[^,}]*' "$ABS" | head -1 | sed 's/.*:[[:space:]]*"//;s/"[[:space:]]*$//')"
fi
if [ -z "$PID" ]; then
  echo "❌ 這個 JSON 裡找不到 project_id——確認你下載的是「服務帳戶金鑰」那個 JSON。"
  exit 1
fi

echo "▸ 專案 ID：$PID"
echo "▸ 金鑰路徑：$ABS"
echo "▸ 接線中…"
claude mcp add mcp-gsheets -s user \
  -e GOOGLE_PROJECT_ID="$PID" \
  -e GOOGLE_APPLICATION_CREDENTIALS="$ABS" \
  -- npx -y mcp-gsheets@latest

echo ""
echo "✅ 接好了！重開 Claude Code，打： claude mcp list"
echo "   看到  mcp-gsheets  ✔ Connected  就成功（第一次可能等 ~30 秒下載套件）。"

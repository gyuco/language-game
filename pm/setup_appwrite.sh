#!/bin/bash
# Setup Appwrite database — attributi e indici per Language Game
# Uso: source this file or run: bash setup_appwrite.sh

export AKEY="standard_88f4459475c6e2f3825e3a0666930de7e6c9f628badd5d8e833d316970870036aa14debfb4fea11368ae3a039a304b0c6e7591574cd6d855486219489a2dcf5c898a15da76d794e22b52566228e2db505f7d71dec7ef7b93683790f2c7ef3b06bf98cd629bfcce8675190189e47e55e917ee38deb0e43bdb6eb39fe83bd29d5e"
export APROJ="6a1203cf001ec70925b1"
export AEP="https://cloud.appwrite.io/v1"
export DBID="language_game"

attr() {
  local cid=$1 type=$2 key=$3 size=$4 required=$5 default=$6 array=$7
  local url="$AEP/databases/$DBID/collections/$cid/attributes/$type"
  local data="{\"key\":\"$key\",\"size\":$size,\"required\":$required"
  [ -n "$default" ] && data="$data,\"default\":\"$default\""
  [ "$array" = "true" ] && data="$data,\"array\":true"
  data="$data}"
  curl -s -X POST "$url" \
    -H "X-Appwrite-Project: $APROJ" -H "X-Appwrite-Key: $AKEY" \
    -H "Content-Type: application/json" \
    -d "$data" | python3 -c "
import sys,json
d=json.load(sys.stdin)
if '\$id' in d:
    print(f'  ATTR OK: {d[\"key\"]} ({d[\"\$id\"]})')
elif d.get('type')=='attribute':
    print(f'  ATTR OK: {d[\"key\"]} (creating...)')
else:
    print(f'  ATTR ERR {key}: {d.get(\"message\",\"?\")}')
"
  # Wait a sec for attribute to be created before creating next
  sleep 1
}

idx() {
  local cid=$1 key=$2 type=$3
  shift 3
  local attributes=""
  local first=true
  for attr in "$@"; do
    [ "$first" = true ] && first=false || attributes="$attributes,"
    attributes="$attributes\"$attr\""
  done
  local url="$AEP/databases/$DBID/collections/$cid/indexes"
  curl -s -X POST "$url" \
    -H "X-Appwrite-Project: $APROJ" -H "X-Appwrite-Key: $AKEY" \
    -H "Content-Type: application/json" \
    -d "{\"key\":\"$key\",\"type\":\"$type\",\"attributes\":[$attributes]}" | python3 -c "
import sys,json
d=json.load(sys.stdin)
if '\$id' in d:
    print(f'  IDX OK: {d[\"key\"]} ({d[\"\$id\"]})')
else:
    print(f'  IDX ERR {key}: {d.get(\"message\",\"?\")}')
"
}

echo "=== ATTRIBUTI: words ==="
attr words string text 1024 true
attr words string translation 1024 true
attr words string language 16 true
attr words string languageName 64 true
attr words string category 64 false
attr words integer difficulty 2 true
attr words string audioFileId 64 false
attr words datetime createdAt 0 true
echo "=== INDICI: words ==="
idx words key_language key language
idx words key_category key category
idx words key_difficulty key difficulty
idx words key_language_difficulty key language difficulty

echo "=== ATTRIBUTI: user_profiles ==="
attr user_profiles string userId 64 true
attr user_profiles string displayName 128 true
attr user_profiles integer totalScore 8 true
attr user_profiles integer dailyStreak 4 true
attr user_profiles datetime lastPlayedAt 0 true
attr user_profiles string statsByLanguage 4096 true "{}"
attr user_profiles string preferredLanguage 16 true
attr user_profiles boolean audioMode 0 true false
attr user_profiles datetime createdAt 0 true
echo "=== INDICI: user_profiles ==="
idx user_profiles key_userId key userId

echo "=== ATTRIBUTI: game_sessions ==="
attr game_sessions string userId 64 true
attr game_sessions string mode 32 true
attr game_sessions boolean audioMode 0 true false
attr game_sessions string wordsPlayed 4096 true "[]"
attr game_sessions integer score 8 true 0
attr game_sessions integer maxStreak 4 true 0
attr game_sessions integer correctCount 4 true 0
attr game_sessions integer totalCount 4 true 0
attr game_sessions datetime playedAt 0 true
echo "=== INDICI: game_sessions ==="
idx game_sessions key_userId key userId
idx game_sessions key_playedAt key playedAt
idx game_sessions key_mode key mode

echo "=== ATTRIBUTI: daily_challenges ==="
attr daily_challenges string date 16 true
attr daily_challenges string wordIds 4096 true "[]"
attr daily_challenges boolean isActive 0 true true
echo "=== INDICI: daily_challenges ==="
idx daily_challenges key_date key date
idx daily_challenges key_active key isActive

echo "=== FATTO ==="

#!/usr/bin/env sh

ENV_FILE="$HOME/.config/sketchybar/.env"

if [ -f "$ENV_FILE" ]; then
  # shellcheck disable=SC1090
  set -a
  . "$ENV_FILE"
  set +a
fi

key="${WK_API_KEY:-${WK_KEY:-}}"

if [ -z "$key" ] && command -v op >/dev/null 2>&1; then
  key="$(op read 'op://Personal/Wanikani API key/password' 2>/dev/null || true)"
fi

if [ -z "$key" ]; then
  sketchybar --set $NAME icon="wk" label="no api key"
  exit 0
fi

response=$(curl "https://api.wanikani.com/v2/summary" \
  -H "Authorization: Bearer ${key}" \
  -H 'Wanikani-Revision: 20170710')

LESSONS=$(echo $response | jq '.data.lessons | map(.subject_ids) | flatten | unique | length')
REVIEWS=$(echo $response | jq '.data.reviews[0].subject_ids | unique | length')
label="l:${LESSONS} r:${REVIEWS}"

sketchybar --set $NAME icon="wk" label="${label}"

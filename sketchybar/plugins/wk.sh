#!/usr/bin/env sh
#key=${WK_KEY}
key="c030d600-1051-417f-84c2-fe0f5546d96d"
response=$(curl "https://api.wanikani.com/v2/summary" \
  -H "Authorization: Bearer ${key}" \
  -H 'Wanikani-Revision: 20170710')

LESSONS=$(echo $response | jq '.data.lessons | map(.subject_ids) | flatten | unique | length')
REVIEWS=$(echo $response | jq '.data.reviews[0].subject_ids | unique | length')
label="l:${LESSONS} r:${REVIEWS}"

sketchybar --set $NAME icon="wk" label="${label}"

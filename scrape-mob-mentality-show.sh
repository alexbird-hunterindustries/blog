#!/bin/bash

url=$1
date=$(curl $url | grep "datePublished[^>]*" -o | sed 's/[^2]*2/2/;s/T.*//')
description=$(curl $url| grep "shortDescription.*isCrawl" -o | sed 's/shortDescription":"//;s/","isCrawl//')
json=$(curl "https://www.youtube.com/oembed?url=$url&format=json")
title=$(echo -E "$json" | jq .title -r)
html=$(echo -E "$json" | jq .html -r)

filename=$date-$(echo $title | tr '[:upper:]' '[:lower:]' | sed "s/[^a-z0-9]/-/g;s/-$//;s/--*/-/g").md

cat << EOF > _posts/$filename
---
  title: Mob Mentality Show
  subtitle: $(echo $title | sed "s/:/ -/g")
  type: video
  author: Austin Chadwick and Chris Lucian
  layout: post
---

$html

$(echo -e $description)

EOF

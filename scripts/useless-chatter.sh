#!/bin/bash

set -e

[ -z "$SLACK_CHANNEL" ] && { echo "SLACK_CHANNEL is not set"; exit 1; }
[ -z "$SLACK_WEBHOOK" ] && { echo "SLACK_WEBHOOK is not set"; exit 1; }

###
# FUNCTIONS
###

postDebugMessage () {
  local name="$1"
  local image="$2"
  local message="$3"

  echo "name: ${name}"
  echo "image: ${image}"
  echo "message: ${message}"
}

postMessage () {
  local name="$1"
  local image="$2"
  local message="$3"

  curl -X POST -H 'Content-type: application/json' --data "{ \
      \"username\": \"${name}\", \
      \"icon_url\": \"${image}\", \
      \"text\": \"${message}\", \
      \"channel\": \"${SLACK_CHANNEL}\", \
    }" "${SLACK_WEBHOOK}"
  echo
}

getRandomChatter () {
  echo "$CHATTERS" | jq -r '.[]' | shuf -n 1
}

getRandomPersonaId () {
  local personaLength
  personaLength=$(echo "$PERSONAS" | jq 'length')
  shuf -i "0-$((personaLength - 1))" -n 1
}

###
# CONFIGURATION
###

CHATTERS='[
  "Did you try turning it off and on again?",
  "maybe it is the russians :rage:",
  "DR1 works fine for me",
  ":wq",
  "stop giving me notifications!!!!",
  "i will try to get a hold of some more bosses to help with this incident!",
  "I think this worked fine yesterday",
  "Please fix this fast i need to watch football later tonight!!!",
  "Outlook is very slow too, maybe it is related? :think-thunk:",
  "Have you tried just restarting the server yet? :grinning:",
  "I remember we had a major incident just like this in 2017. I will try to dig it up...",
  "is this in prod or dev?",
  "Actually im pretty sure that application is running in Rancher 2",
  "I cant get into Jenkins is it down???",
  "password123",
  "why cant i check out the app repo? my github token is ghp_k5kqxkg994hknwo78gkq3",
  "Will this decrease the OKR confidence score by 1, or more like 4 points?",
  "I will log on and help with troubleshooting. I just need to get the kids to sleep first - im sure it wont take long",
  "My pc is stuck on Windows Update... i will start troubleshooting in about 2 days :old-man-yells-at-windows:",
  "What happens if you clear your cookies?"
]'

PERSONAS='[
  {
    "name": "Daniel Umbas Sørensen",
    "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR94rSEoQeQipAyi4PEJStEBbIqcqgm_5eVRg&s"
  },
  {
    "name": "Søren Kovl",
    "image": "https://cdn12.picryl.com/photo/2016/12/31/man-funny-confused-people-c3f940-1024.jpg"
  },
  {
    "name": "David Ompap",
    "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTp8BLhwWjxPQIOLPCBFGd6VBbmLNg40YZZbw&s"
  },
  {
    "name": "Mikkel Skvadder",
    "image": "https://live.staticflickr.com/35/107366892_3e6b3181f4_b.jpg"
  },
  {
    "name": "Kurt Egle",
    "image": "https://images.pexels.com/photos/8899328/pexels-photo-8899328.jpeg"
  },
  {
    "name": "Tage Orsk Klapsen",
    "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuyHVxcqNx-uzFWhjDT_VX8BbZbjEMuXIbSg&s"
  },
  {
    "name": "Flemming Jolètte",
    "image": "https://live.staticflickr.com/3143/2953327755_242d98057a_b.jpg"
  }
]'

###
# MAIN LOOP
###

while true
do
  personaId=$(getRandomPersonaId)
  personaName=$(echo "$PERSONAS" | jq -r ".[$personaId].name")
  personaImage=$(echo "$PERSONAS" | jq -r ".[$personaId].image")
  chatter=$(getRandomChatter)

  postMessage "$personaName" "$personaImage" "$chatter"

  sleepTime="$(gshuf -i 5-30 -n 1)"
  echo "Successfully posted message from $personaName. Now sleeping for $sleepTime seconds."
  echo
  sleep "$sleepTime"
done

#!/bin/bash

# Cloudflare DDNS Script for assistant.iamdeathgod.tech
# Updates the A record with your current public IP

# Configuration
CF_API_TOKEN="iXNow1ZeJtoUlWKQOF7UPax3WPzW3AikvMdS2H_m"
CF_ZONE_ID="6465678629446e88cab276fa823169e8"
CF_RECORD_NAME="assistant"
DOMAIN="assistant.iamdeathgod.tech"

# Get current public IP
CURRENT_IP=$(curl -s https://api.ipify.org)

# Get the Record ID for the subdomain
RECORD_ID=$(curl -s -X GET \
  "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?name=$DOMAIN" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" | jq -r '.result[0].id')

# Check if record exists
if [ "$RECORD_ID" == "null" ] || [ -z "$RECORD_ID" ]; then
  echo "Creating new A record for $DOMAIN..."
  curl -s -X POST \
    "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$CF_RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":300,\"proxied\":false}" | jq .
else
  # Get current record IP
  RECORD_IP=$(curl -s -X GET \
    "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json" | jq -r '.result.content')
  
  # Update only if IP changed
  if [ "$CURRENT_IP" != "$RECORD_IP" ]; then
    echo "Updating $DOMAIN: $RECORD_IP -> $CURRENT_IP"
    curl -s -X PUT \
      "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
      -H "Authorization: Bearer $CF_API_TOKEN" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"$CF_RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":300,\"proxied\":false}" | jq .
  else
    echo "No IP change. Current: $CURRENT_IP"
  fi
fi

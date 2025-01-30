#!/bin/bash

set -e

ENDPOINTS=("image1" "image2")

# Testing each endpoint
for IMAGE in "${ENDPOINTS[@]}"; do
    IMAGE_URL="http://localhost/images/$IMAGE"
    PURGE_URL="http://localhost/purge/images/$IMAGE"

    echo -e "🖼 Testing cache for $IMAGE_URL\n"

    echo -n "🔍 First request (expecting MISS)... "
    curl -s -I "$IMAGE_URL" | grep X-Cache-Status || echo "❌ Cache header not found"

    echo -n "🔄 Second request (expecting MISS)... "
    curl -s -I "$IMAGE_URL" | grep X-Cache-Status || echo "❌ Cache header not found"

    echo -n "🔄 Third request (expecting HIT)... "
    curl -s -I "$IMAGE_URL" | grep X-Cache-Status || echo "❌ Cache header not found"

    echo -e "\n🧹 Purging cache for $IMAGE_URL... "
    curl -s -X PURGE "$PURGE_URL" | grep "<title>Successful purge</title>" && echo "✅ Success" || echo "❌ Failed"

    echo -e "\n🔍 Verification after PURGE (expecting MISS)... "
    curl -s -I "$IMAGE_URL" | grep X-Cache-Status || echo "❌ Cache header not found"

    echo -e "\n🧹 Final cleanup purge for $IMAGE_URL... "
    curl -s -X PURGE "$PURGE_URL" | grep "<title>Successful purge</title>" && echo "✅ Success" || echo "❌ Failed"

    echo "✅ Test for $IMAGE_URL completed!"
    echo "--------------------------------------"
done

echo -e "\n✅ All tests completed!"
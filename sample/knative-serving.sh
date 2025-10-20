for i in $(seq 1 10); do
  echo "Request #$i"
  curl "$(kn service describe hello -o url)"
  sleep 1
done

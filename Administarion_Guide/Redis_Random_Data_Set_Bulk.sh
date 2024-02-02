#!/bin/bash

# Define an array of server IP addresses and ports
servers=("redis-1:7000" "redis-2:7000" "redis-3:7000")

# Define the number of keys you want to set per server
keyCount=100000

# Define the password for Redis authentication
password="BIVIGIHUt78gh8ujhol"

# Number of keys to pipeline in a single batch
batchSize=1000

# Function to generate a random string for the key and value
generate_random_string() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

# Function to set keys on a specific server using pipelining
set_keys_on_server() {
  local server=$1
  local port=$2
  local totalCount=0
  local db=0  # Assuming default Redis database 0
  local batchCounter=0

  # Initialize pipelining
  while [ $totalCount -lt $keyCount ]; do
    # Start a new pipeline block
    {
      for ((i=0; i<batchSize && totalCount+i<keyCount; i++)); do
        local key=$(generate_random_string 10)  # 10 character key
        local value=$(generate_random_string 20)  # 20 character value
        echo -ne "SET $key $value\r\n"
      done
      totalCount=$((totalCount + batchSize))
      batchCounter=$((batchCounter + 1))
    } | redis-cli -c -h "$server" -p "$port" -a "$password" --pipe > /dev/null
    echo "Sent batch $batchCounter ($batchSize keys) to $server:$port, $totalCount keys so far..."
  done

  echo "Finished setting $keyCount keys on $server:$port"
}

# Loop through each server:port combination and set keys in parallel
for server_port in "${servers[@]}"; do
  # Split server and port
  IFS=':' read -r server port <<< "$server_port"

  # Call set_keys_on_server function in background for concurrency
  set_keys_on_server "$server" "$port" &
done

# Wait for all background jobs to finish
wait

echo "Concurrent data population complete."

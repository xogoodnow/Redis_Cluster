#!/bin/bash

# Define an array of server IP addresses and ports
# Assuming these are entry points to the cluster and commands will be redirected as necessary.
servers=("redis-1:7000" "redis-2:7000" "redis-3:7000")

# Define the number of keys you want to set per server
keyCount=100000

# Define the password for Redis authentication
password="BIVIGIHUt78gh8ujhol"

# Function to generate a random string for the key and value
generate_random_string() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

# Function to set keys on a specific server
set_keys_on_server() {
  local server=$1
  local port=$2
  for ((i=1; i<=keyCount; i++)); do
    local key=$(generate_random_string 10)  # 10 character key
    local value=$(generate_random_string 20)  # 20 character value

    # Set the key-value in Redis
    redis-cli -c -h "$server" -p "$port" -a "$password" SET "$key" "$value" > /dev/null
  done
  echo "Set $keyCount keys on $server:$port"
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
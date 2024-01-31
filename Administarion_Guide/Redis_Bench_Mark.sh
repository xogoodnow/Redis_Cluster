#!/bin/bash

# Define an array of server IP addresses
servers=("redis-1" "redis-2" "redis-3")

# Define an array of Redis port numbers (masters)
ports=("7000" "7001")

# Define benchmark parameters
operations=("get" "set")
requests="10000000"
connections="810"

# Loop through each server and port combination
for server in "${servers[@]}"; do
  for port in "${ports[@]}"; do
    # Loop through each operation
    for operation in "${operations[@]}"; do
      # Run redis-benchmark in the background for each combination
      # Keep in mind that the password might differ
      redis-benchmark -a "BIVIGIHUt78gh8ujhol" -h "$server" -p "$port" -t "$operation" -n "$requests" -c "$connections" -q &
    done
  done
done

# Wait for all background jobs to finish
wait

echo "Benchmarking complete."

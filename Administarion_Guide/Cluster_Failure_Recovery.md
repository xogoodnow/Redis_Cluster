
# Redis Cluster Recovery Guide

## Introduction

This document outlines the process for recovering a Redis cluster following the failure of nodes. The procedure is designed for a cluster with six instances spread across three nodes, addressing a scenario where two of these nodes fail.

## Prerequisites

- Familiarity with Redis cluster concepts and commands.
- Access to the cluster nodes with necessary permissions.
- The cluster is composed of three nodes (`redis-1`, `redis-2`, `redis-3`), with two nodes experiencing failures.

## Objectives

1. Remove failed nodes from the cluster.
2. Reassign all slots to the remaining healthy master node.
3. Clear data from failed instances and reintegrate them as slaves.
4. Achieve an even distribution of slots across all masters.

## Recovery Process

### Step 1: **Identify Failed Nodes**
   - On `redis-1`, identify failed nodes by checking the cluster status.
   - Command: `redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt -p 27000 -a "yourPassword" cluster nodes`

### Step 2: **Remove Failed Nodes**
   - Use the `CLUSTER FORGET` command for each failed node from `redis-1`.
   - Commands:
     - For `redis-2`: `redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt -h redis-1 -p 27000 -a "yourPassword" CLUSTER FORGET [FAILED_NODE_ID_OF_REDIS-2]`
     - For `redis-3`: `redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt -h redis-1 -p 27000 -a "yourPassword" CLUSTER FORGET [FAILED_NODE_ID_OF_REDIS-3]`

### Step 3: **Assign All Slots to Healthy Master**
   - Ensure all slots are reassigned to the healthy master on `redis-1`.
   - Command: Use a loop to add each slot to the healthy master, adjusting the script as necessary.

### Step 4: **Clear Data on Failed Instances**
   - Stop Redis instances on `redis-2` and `redis-3`, clear their data, and then restart.
   - Commands:
     - Stop instance: `docker stop [INSTANCE_NAME]`
     - Clear data: `rm -rf /path/to/redis/data/*`
     - Start instance: `docker start [INSTANCE_NAME]`

### Step 5: **Reintegrate Nodes and Balance Slots**
   - Add cleared nodes back to the cluster as slaves and then balance slots across all masters.
   - Command for adding nodes back: `redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster add-node [NEW_NODE_HOST]:[NEW_NODE_PORT] [REDIS-1_HOST]:[REDIS-1_PORT] -a "yourPassword"`
   - Use the `redis-cli --cluster rebalance` command with appropriate options to balance slots.

## Conclusion

This guide provides a systematic approach to recovering a Redis cluster after node failures, including steps for removing failed nodes, reassigning slots, and reintegrating nodes as slaves to restore the cluster to a fully operational state. Ensure all commands are carefully executed to prevent data loss and maintain cluster integrity.

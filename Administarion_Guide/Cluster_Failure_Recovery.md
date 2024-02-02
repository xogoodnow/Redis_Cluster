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
   - Command: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt <mark>-h [HEALTHY_REDIS_MASTER_HOST] -p [HEALTHY_REDIS_MASTER_PORT]</mark> <mark>-a "[REDIS_CLUSTER_PASSWORD]"</mark> cluster nodes</code>

### Step 2: **Remove Failed Nodes**
   - Use the `CLUSTER FORGET` command for each failed node from `redis-1`.
   - Commands:
     - For `redis-2`: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt <mark>-h [HEALTHY_REDIS_MASTER_HOST] -p [HEALTHY_REDIS_MASTER_PORT]</mark> <mark>-a "[REDIS_CLUSTER_PASSWORD]"</mark> CLUSTER FORGET [FAILED_NODE_ID_OF_REDIS-2]</code>
     - For `redis-3`: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt <mark>-h [HEALTHY_REDIS_MASTER_HOST] -p [HEALTHY_REDIS_MASTER_PORT]</mark> <mark>-a "[REDIS_CLUSTER_PASSWORD]"</mark> CLUSTER FORGET [FAILED_NODE_ID_OF_REDIS-3]</code>

### Step 3: **Assign All Slots to Healthy Master**
   - Ensure all slots are reassigned to the healthy master on `redis-1`.
   - Command:
     <code>for slot in {0..16383}; do
         redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt <mark>-h [HEALTHY_REDIS_MASTER_HOST] -p [HEALTHY_REDIS_MASTER_PORT]</mark> <mark>-a "[REDIS_CLUSTER_PASSWORD]"</mark> CLUSTER ADDSLOTS $slot
     done</code>

### Step 3.1: **Change slot states**
   - Ensure all slots are in stable state.
   - Command:
     <code>for slot in {0..16383}; do
         redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt <mark>-h [HEALTHY_REDIS_MASTER_HOST] -p [HEALTHY_REDIS_MASTER_PORT]</mark> <mark>-a "[REDIS_CLUSTER_PASSWORD]"</mark> CLUSTER SETSLOT  $slot STABLE;
     done</cod

### Step 4: **Clear Data on Failed Instances**
   - Stop Redis instances on `redis-2` and `redis-3`, clear their data, and then restart.
   - Commands:
     - Stop instance: `docker stop [INSTANCE_NAME]`
     - Clear data: `rm -rf /path/to/redis/data/*`
     - Start instance: `docker start [INSTANCE_NAME]`

### Step 5: **Reintegrate Nodes and Balance Slots**
   - Add cleared nodes back to the cluster as slaves and then balance slots across all masters.
   - Command for adding nodes back: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster add-node <mark<[NEW_REDIS_INSTANCE_HOST]:[NEW_REDIS_INSTANCE_PORT]<mark> <mark>[HEALTHY_REDIS_MASTER_HOST]:[HEALTHY_REDIS_MASTER_PORT]<mark> <mark>-a "[REDIS_CLUSTER_PASSWORD]"</mark></code>
   - Use the `redis-cli --cluster rebalance` command with appropriate options to balance slots.

### Additional Steps for Single Healthy Master Recovery

If the cluster is left with only one healthy master and no slaves, follow these steps:

1. **Ensure All Slots are Assigned to the Healthy Master**
   - Use the loop command provided in Step 3 to assign all slots to the healthy master.

2. **Resolve Slots Stuck in Migrating State**
   - If slots are stuck in migrating state

# Redis Cluster: Removing and Adding a Master Node

## Introduction

This guide provides a detailed procedure for removing a master node from a Redis cluster and then adding it back. This process is essential for maintenance, updates, or reconfiguration of the Redis cluster.

## Prerequisites

- Familiarity with Redis cluster concepts.
- Access to the cluster nodes and necessary permissions.
- Proper backup of data to avoid any loss during the process.

## Steps to Remove a Master Node

### 1. **Identify the Master Node**
   - Use the `cluster nodes` command to list all nodes and identify the master node to be removed.
   - Example: <code>redis-cli -h <mark>[ANY-REDIS-HOST-NAME] -p [REDIS-MASTER-PORT]</mark> -a "yourPassword" --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt <mark>cluster nodes</mark></code>

### 2. **Reshard Data from the Master Node**
   - Move data from the target master node to another node.
   - Command: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster reshard <mark>[ANY-REDIS-HOST-NAME]:[REDIS-MASTER-PORT]</mark> --cluster-from <mark>[ID-OF-MASTER-TO-BE-DRAINED]</mark> --cluster-to <mark>[ID-OF-TARGET-MASTER-NODE]</mark> --cluster-slots <mark>[NO-OF-SLOTS-TO-TRANSFER]</mark> -a "yourPassword"</code>
   - Adjust `[ID-OF-MASTER-TO-BE-DRAINED]`, `[ID-OF-TARGET-MASTER-NODE]`, and `[NO-OF-SLOTS-TO-TRANSFER]` accordingly.

### 3. **Remove the Master Node**
   - Execute the `del-node` command to remove the master node from the cluster.
   - Command: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster del-node <mark>[ANY-REDIS-HOST-NAME]:[REDIS-MASTER-PORT] [ID_OF_NODE_TO_BE_DELETED]</mark> -a "yourPassword"</code>
   - Replace `[ID_OF_NODE_TO_BE_DELETED]` with the ID of the master node.

## Steps to Add the Master Node Back

### 4. **Add the Node Back to the Cluster**
   - Use the `add-node` command to add the node back as a master or slave.
   - Command: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster add-node <mark>[NEW_REDIS_NODE]:[NEW_REDIS_NODE_PORT]</mark> <mark>[ANY-REDIS-HOST-NAME]:[REDIS-MASTER-PORT]</mark> -a "yourPassword"</code>
   - Replace `[NEW_REDIS_NODE]` and `[NEW_REDIS_NODE_PORT]` with the new node's host and port.

### 5. **Assign Slots to the New Master Node (If Applicable)**
   - If the node is added as a master, assign slots to it.
   - Use the `reshard` command as in step 2, but now target the new master node.

### 6. **Verify the Cluster State**
   - Use the `cluster nodes` command again to ensure the node is added and configured correctly.
   - Check for the distribution of slots and the state of other nodes.

## Conclusion

This guide illustrates the process of safely removing and adding a master node in a Redis cluster. Always ensure you have a backup and understand the implications of these operations on your cluster's

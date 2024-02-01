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
   - Command: <code>redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster del-node <mark>[ANY-REDIS-HOST-NAME]:[REDIS-MASTER-PORT]</mark> <mark>[ID_OF_NODE_TO_BE_DELETED]</mark> -a "yourPassword"</code>
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


## Example of the flow

### Step: 1
Command: Get the node ids and the assigend slots to each node
``` bash redis-cli -h redis-1 -p 27000 -a "BIVIGIHUt78gh8ujhol" --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt cluster nodes```

Output: 

``` bash
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
2b9f8570540217cae4f8f5309cb3244aea30afc8 redis-3:27000@37000 master - 0 1706720450613 12 connected 0-5460
a3ac5a0fd6b334249c2862743fd9df232301aea5 redis-2:27001@37001 slave 2b9f8570540217cae4f8f5309cb3244aea30afc8 0 1706720450108 12 connected
ab25ad812dda62d3104894c9fada71fedc9c6353 redis-3:27001@37001 slave 5e2f6b0fa94b234455ea79868b0de123f9baa71a 0 1706720450718 2 connected
7c3ece283ec042cc60b7d6957af6e190053223b8 redis-1:27000@37000 myself,master - 0 1706720450000 11 connected 10923-16383
f2e0478f3ca813986ffd8956238c08049fbc2d7c redis-1:27001@37001 slave 7c3ece283ec042cc60b7d6957af6e190053223b8 0 1706720449705 11 connected
5e2f6b0fa94b234455ea79868b0de123f9baa71a redis-2:27000@37000 master - 0 1706720449000 2 connected 5461-10922
```




### Step: 2


Command: Transfer shard from one node to another
 ```bash 
 redis-cli  -a "BIVIGIHUt78gh8ujhol" --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster reshard redis-1:27000 --cluster-from 2b9f8570540217cae4f8f5309cb3244aea30afc8  --cluster-to 5e2f6b0fa94b234455ea79868b0de123f9baa71a --cluster-slots 3
 ```

Output: 
```bash
 Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Performing Cluster Check (using node redis-1:27000)
M: 7c3ece283ec042cc60b7d6957af6e190053223b8 redis-1:27000
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
M: 2b9f8570540217cae4f8f5309cb3244aea30afc8 redis-3:27000
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: a3ac5a0fd6b334249c2862743fd9df232301aea5 redis-2:27001
   slots: (0 slots) slave
   replicates 2b9f8570540217cae4f8f5309cb3244aea30afc8
S: ab25ad812dda62d3104894c9fada71fedc9c6353 redis-3:27001
   slots: (0 slots) slave
   replicates 5e2f6b0fa94b234455ea79868b0de123f9baa71a
S: f2e0478f3ca813986ffd8956238c08049fbc2d7c redis-1:27001
   slots: (0 slots) slave
   replicates 7c3ece283ec042cc60b7d6957af6e190053223b8
M: 5e2f6b0fa94b234455ea79868b0de123f9baa71a redis-2:27000
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

Ready to move 3 slots.
  Source nodes:
    M: 2b9f8570540217cae4f8f5309cb3244aea30afc8 redis-3:27000
       slots:[0-5460] (5461 slots) master
       1 additional replica(s)
  Destination node:
    M: 5e2f6b0fa94b234455ea79868b0de123f9baa71a redis-2:27000
       slots:[5461-10922] (5462 slots) master
       1 additional replica(s)
  Resharding plan:
    Moving slot 0 from 2b9f8570540217cae4f8f5309cb3244aea30afc8
    Moving slot 1 from 2b9f8570540217cae4f8f5309cb3244aea30afc8
    Moving slot 2 from 2b9f8570540217cae4f8f5309cb3244aea30afc8
Do you want to proceed with the proposed reshard plan (yes/no)? yes
Moving slot 0 from redis-3:27000 to redis-2:27000: 
Moving slot 1 from redis-3:27000 to redis-2:27000: 
Moving slot 2 from redis-3:27000 to redis-2:27000: 
```





## Step 3: 
### Command: Delete the node after it has been emptied
```bash
redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster del-node redis-1:27000 2b9f8570540217cae4f8f5309cb3244aea30afc8 -a "BIVIGIHUt78gh8ujhol"
```

### Output:
```bash
 Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Removing node 2b9f8570540217cae4f8f5309cb3244aea30afc8 from cluster redis-1:27000
>>> Sending CLUSTER FORGET messages to the cluster...
>>> Sending CLUSTER RESET SOFT to the deleted node.
```




## Step: 4
### Command: Stop the redis container and remove its data and then restart the container

```bash 
docker stop redis-master-redis-2-3
``` 

```bash
rm -rf Redis/Data/27000/*
```

```bash 
docker start redis-master-redis-2-3
```



## Step 5: 
### Command: Add the node to the cluster
```bash
redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster add-node redis-1:27000 redis-3:27000 -a "BIVIGIHUt78gh8ujhol"
```

### Output: 
```bash 
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Adding node redis-1:27000 to cluster redis-3:27000
>>> Performing Cluster Check (using node redis-3:27000)
S: 8542495c57afe3d87deb5afec0043a3ba79e359d redis-3:27000
   slots: (0 slots) slave
   replicates a3ac5a0fd6b334249c2862743fd9df232301aea5
M: 5e2f6b0fa94b234455ea79868b0de123f9baa71a redis-2:27000
   slots:[2500-2730],[5231-16383] (11384 slots) master
   2 additional replica(s)
M: a3ac5a0fd6b334249c2862743fd9df232301aea5 redis-2:27001
   slots:[0-2499],[2731-5230] (5000 slots) master
   1 additional replica(s)
S: ab25ad812dda62d3104894c9fada71fedc9c6353 redis-3:27001
   slots: (0 slots) slave
   replicates 5e2f6b0fa94b234455ea79868b0de123f9baa71a
S: f2e0478f3ca813986ffd8956238c08049fbc2d7c redis-1:27001
   slots: (0 slots) slave
   replicates 5e2f6b0fa94b234455ea79868b0de123f9baa71a
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node redis-1:27000 to make it join the cluster.
[OK] New node added correctly.
```



## Step 6: 
### Command: Reshard the cluster and transfer the slots to the node

```bash 
redis-cli --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt --cluster reshard redis-2:27000 --cluster-from 5e2f6b0fa94b234455ea79868b0de123f9baa71a --cluster-to 996bbb18c204c27d0447fa171b3778f07a58ef36  --cluster-slots 5461 -a "BIVIGIHUt78gh8ujhol"
```

### Output:
```bash 
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
>>> Performing Cluster Check (using node redis-2:27000)
M: 5e2f6b0fa94b234455ea79868b0de123f9baa71a redis-2:27000
   slots:[2500-2730],[5231-16383] (11384 slots) master
   2 additional replica(s)
S: f2e0478f3ca813986ffd8956238c08049fbc2d7c redis-1:27001
   slots: (0 slots) slave
   replicates 5e2f6b0fa94b234455ea79868b0de123f9baa71a
M: a3ac5a0fd6b334249c2862743fd9df232301aea5 redis-2:27001
   slots:[0-2499],[2731-5230] (5000 slots) master
   1 additional replica(s)
M: 996bbb18c204c27d0447fa171b3778f07a58ef36 redis-1:27000
   slots: (0 slots) master
S: ab25ad812dda62d3104894c9fada71fedc9c6353 redis-3:27001
   slots: (0 slots) slave
   replicates 5e2f6b0fa94b234455ea79868b0de123f9baa71a
S: 8542495c57afe3d87deb5afec0043a3ba79e359d redis-3:27000
   slots: (0 slots) slave
   replicates a3ac5a0fd6b334249c2862743fd9df232301aea5
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

Ready to move 5461 slots.
  Source nodes:
    M: 5e2f6b0fa94b234455ea79868b0de123f9baa71a redis-2:27000
       slots:[2500-2730],[5231-16383] (11384 slots) master
       2 additional replica(s)
  Destination node:
    M: 996bbb18c204c27d0447fa171b3778f07a58ef36 redis-1:27000
       slots: (0 slots) master
  Resharding plan:
    Moving slot 2500 from 5e2f6b0fa94b234455ea79868b0de123f9baa71a
    Moving slot 2501 from 5e2f6b0fa94b234455ea79868b0de123f9baa71a
    Moving slot 2502 from 5e2f6b0fa94b234455ea79868b0de123f9baa71a
    Moving slot 2503 from 5e2f6b0fa94b234455ea79868b0de123f9baa71a
Do you want to proceed with the proposed reshard plan (yes/no)? yes
Moving slot 2500 from redis-2:27000 to redis-1:27000: ........................................................................
Moving slot 2501 from redis-2:27000 to redis-1:27000: ........................................................
Moving slot 2502 from redis-2:27000 to redis-1:27000: ..........................................................
Moving slot 2503 from redis-2:27000 to redis-1:27000: ................................................................
Moving slot 2504 from redis-2:27000 to redis-1:27000: .....................................................................
```


## Step 7:
### Command: Verify that the master has been added to the cluster and resharded.
```bash 
redis-cli -h redis-1 -p 27000 -a "BIVIGIHUt78gh8ujhol" --tls --cacert /root/Redis/Certs/ca.crt --key /root/Redis/Certs/redis.key --cert /root/Redis/Certs/redis.crt cluster nodes
```

### output:
```bash
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
996bbb18c204c27d0447fa171b3778f07a58ef36 redis-1:27000@37000 myself,master - 0 1706783426000 18 connected 2500-2730 5231-10460
5e2f6b0fa94b234455ea79868b0de123f9baa71a redis-2:27000@37000 master - 0 1706783427000 17 connected 10461-16383
8542495c57afe3d87deb5afec0043a3ba79e359d redis-3:27000@37000 slave a3ac5a0fd6b334249c2862743fd9df232301aea5 0 1706783426428 16 connected
ab25ad812dda62d3104894c9fada71fedc9c6353 redis-3:27001@37001 slave 996bbb18c204c27d0447fa171b3778f07a58ef36 0 1706783427435 18 connected
f2e0478f3ca813986ffd8956238c08049fbc2d7c redis-1:27001@37001 slave 5e2f6b0fa94b234455ea79868b0de123f9baa71a 0 1706783428443 17 connected
a3ac5a0fd6b334249c2862743fd9df232301aea5 redis-2:27001@37001 master - 0 1706783427939 16 connected 0-2499 2731-5230
```


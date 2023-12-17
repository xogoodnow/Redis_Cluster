
# Redis Operations Guide

## Basic Operations

1. **Connect to Redis**
   - Command: `redis-cli -h [hostname] -p [port] -a [password]`
   - Example: `redis-cli -h localhost -p 6379 -a myPassword`
   - Explanation: Connects to a Redis server. Essential for any Redis operation.


2. **Set a Key**
   - Command: `SET myKey "Hello"`
   - Explanation: Stores a string value under a key. Basic operation for storing data.


3. **Get a Key**
   - Command: `GET myKey`
   - Explanation: Retrieves the value of a key. Fundamental for data retrieval.


4. **Delete a Key**
   - Command: `DEL myKey`
   - Explanation: Removes a key and its associated value. Important for data management.


5. **Check if Key Exists**
   - Command: `EXISTS myKey`
   - Explanation: Checks whether a key exists. Useful for conditional operations.


6. **Increment a Number Stored at a Key**
   - Command: `INCR myCounter`
   - Explanation: Atomically increments a number stored at a key. Useful for counters and numeric tracking.


7. **List All Keys**
   - Command: `KEYS *`
   - Explanation: Lists all keys in the database. Helpful for getting an overview of the stored data.


8. **Expire a Key**
   - Command: `EXPIRE myKey 60`
   - Explanation: Sets a key to expire after a given number of seconds. Important for temporary data or cache.


9. **Rename a Key**
   - Command: `RENAME myKey newKey`
   - Explanation: Renames a key. Useful when changing the naming conventions or correcting mistakes.


10. **Type of Value Stored in a Key**
    - Command: `TYPE myKey`
    - Explanation: Returns the data type of the value stored at a key. Useful for understanding the stored data.



## Intermediate Operations

11. **Using Lists**
    - Push: `LPUSH myList "world"`
    - Pop: `RPOP myList`
    - Explanation: Manipulates lists, allowing pushing and popping of elements. Lists are useful for queues and stacks.


12. **Using Sets**
    - Add: `SADD mySet "Hello"`
    - Members: `SMEMBERS mySet`
    - Explanation: Manages sets, useful for storing unique items and performing set operations.


13. **Using Sorted Sets**
    - Add: `ZADD mySortedSet 1 "one"`
    - Range: `ZRANGE mySortedSet 0 -1`
    - Explanation: Sorted sets store elements with a score, allowing ordered retrieval. Great for leaderboards and priority queues.


14. **Using Hashes**
    - Set: `HSET myHash field1 "Hello"`
    - Get: `HGET myHash field1`
    - Explanation: Hashes store field-value pairs within a key. Suitable for objects or complex data.


15. **Publish/Subscribe**
    - Publish: `PUBLISH myChannel "message"`
    - Subscribe: `SUBSCRIBE myChannel`
    - Explanation: Implements a publish/subscribe messaging system. Useful for real-time data propagation.


16. **Transactions**
    - Command: `MULTI; SET key1 "value1"; SET key2 "value2"; EXEC`
    - Explanation: Groups commands into an atomic transaction. Ensures data integrity during batch operations.


17. **Pipeline Commands**
    - Command: `redis-cli --pipe`
    - Explanation: Pipes a sequence of commands to Redis. Efficient for bulk operations.


18. **Backup (Save the Dataset to Disk)**
    - Command: `SAVE`
    - Explanation: Creates a snapshot of the database. Critical for data backup and persistence.


19. **Asynchronous Replication**
    - Command: `SLAVEOF master_host master_port`
    - Explanation: Configures a Redis server as a replica of another. Important for high availability and data redundancy.


20. **Configure Persistence**
    - Command: `CONFIG SET save "900 1 300 10 60 10000"`
    - Explanation: Customizes the persistence settings. Balances between performance and data safety.



## Advanced Operations

21. **Lua Scripting**
    - Command: `EVAL "return redis.call('SET',KEYS[1],ARGV[1])" 1 myKey "value"`
    - Explanation: Executes Lua scripts in Redis. Enables complex operations and custom scripts for advanced use cases.


22. **Geospatial Indexes**
    - Add: `GEOADD myGeoSet 13.361389 38.115556 "Palermo"`
    - Query: `GEORADIUS myGeoSet 15 37 100 km`
    - Explanation: Stores and queries geospatial data. Useful for location-based services and applications.


23. **HyperLogLog**
    - Add: `PFADD myHyperLogLog "element"`
    - Count: `PFCOUNT myHyperLogLog`
    - Explanation: Estimates the cardinality of a set. Efficient for counting unique elements in large datasets.


24. **Streams**
    - Add: `XADD myStream * field1 "value1"`
    - Read: `XREAD COUNT 2 STREAMS myStream 0`
    - Explanation: Provides a stream data structure. Ideal for messaging, activity feeds, and time-series data.


25. **Bitmaps**
    - Set: `SETBIT myBitmap 7 1`
    - Get: `GETBIT myBitmap 7`
    - Explanation: Manages bitmap data. Useful for efficiently storing and querying large arrays of boolean data.


26. **Cluster Command**
    - Command: `CLUSTER INFO`
    - Explanation: Provides information about the Redis Cluster. Critical for managing and monitoring a Redis Cluster setup.


27. **Memory Management Information**
    - Command: `INFO memory`
    - Explanation: Displays memory usage details. Essential for performance tuning and capacity planning.


28. **Manage Client Connections**
    - Command: `CLIENT LIST`
    - Explanation: Lists clients connected to Redis. Useful for monitoring and debugging client connections.


29. **Slow Log**
    - Command: `SLOWLOG GET`
    - Explanation: Retrieves a log of slow commands. Helps in identifying performance bottlenecks.


30. **Monitor Commands**
    - Command: `MONITOR`
    - Explanation: Real-time monitoring of commands being executed. Useful for debugging and understanding database usage patterns.

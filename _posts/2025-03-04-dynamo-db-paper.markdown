---
layout: post
title:  "Notes : Dynamo DB Paper by Amazon"
date:   2025-03-05 11:26:31 +0530
categories: papers
---


**Motivations**

Dynamo DB serves a specific kind of system that is seen more often than you think. 
The characteristics of such a system are:
1. These only store and retrieve data by their primary keys. No complex queries are performed. In other words, they are a WASTE of relational resources. 
2. These have low consistency requirements. The user isn't going to panic looking at inconsistent data. 
3. These want to be reallly fast. 

There is a clear trade off made based on the above three criteria. Make it fast by forgoing consistency. Ahem.. in the short term. 
Dynamo DB is an eventually consistent data store. It prioritizes availability and aims to be an **"always writable"** system.

What stands between a system and this "always writable"-ity? 

1. Generally databases (notably RDBMS) want to be strictly sconsistent. Dynamo DB doesn't.
2. no holds barred writes without consistency or locks means allowing multiple different versions to exist. Hence, a sensible versioning system is needed for objects.
3. A key should only hold one value and because of versioning - we need to have a conflict resolution strategy. 
4. Because we're hell bent on latencies and writes are by design slower than reads - it makes sense to add the burden of conflict resolution on the read call. Also, one less way for writes to fail in our "always writable" system. 


**Interface (API)**

This is a simple KV store. Two operations : 
1. get(key) --> ([object1, object2, object3 ..... objectn], context)
    This call returns all the current versions of the object that exist in the system with a context. The context here is opaque to the caller but is very useful for further calls to dynamo DB. For one, context holds encoded information about version history. It can also be used to enable a sort of sticky session.
2. put(key, context, object)

The Dynamo DB API is accessible over HTTP. A client can choose between routing calls to a load balancer that then routes to the most appropriate node or employ a partition aware client library to reduce a hop. 


**Partitioning Scheme**

A slightly modified version of **consistent hashing** is used. 
The hash space is 128 bit md5. 

The modification here is that instead of considering each machine as a node, each node has multiple **virtual nodes**. The virtual nodes are placed on the hash ring. 
It is taken care of that virtual nodes that belong to the same physcial node are placed far apart. This is to **prevent hot partitions**. The paper says this is a successful technique. 
The concept of virtual nodes also helps to leverage **heterogenous infra** and segment into more or less virtual nodes based on the machine's capacity.

**Replication** 

The number of replications per key N is a tunable parameter to achieve differing levels of durability. 

For each key - there is a way for each node to figure out which are the N nodes on which this key resides. This list of nodes is the **preference list** of the key. 

While replicating, it is taken care that the N nodes correspond to N different physical nodes. Again, this is for durability. However, maintaining multiple versions while enabling an "always writeable" environment isn't easy. Hence, Dynamo DB has a neat versioning system for objects. We will also look at how DynamoDB spreads these changes - in normal cases, during temporary node failures as well as during permament node failures. 

**Data Versioning**

Vector clocks are employed for determining causality and concurrency. The **context** returned in the get() call also contains the vector clock along with all existing diverging branches of the object. A subsequent put() call is assumed and expected to resolve any divergent branches by merging the vector clocks appropriately. 

**Execution**

Any node in a Dynamo DB cluster can receive get or put calls for any key. This node then becomes the **coordinator** for the duration of that call. The coordinator initializes a state machine (per call) which tracks communication with other nodes. 
The communication with other nodes has a **sloppy quorum** approach. 
A quorum is a means of determining success of a call in a distributed system. There are two parameters R and W. R is the number of nodes that must agree for a read request to succeed and W is the number onodes that must agree for a write request to succeed.
The sloppiness comes from DynamoDB only considering healthy nodes. So, a standard quorum based system would stall a read if R nodes are not available, DynamoDB proceeds with calling it a success in the interest of latencies and partition tolerance. 
R and W are tunable parameters. For ex, if one wanted dynamo db to be highly available for writes, W could be set at 1 - with the side effect of introducing more inconsistent data. 
Also mentioned is the phenomenon of "read repair" - the coordinator in a read request takes it upon itself to send an updated version to all nodes that report a stale version. 


**Hinted Handoff**

To guard against temporary network failures, DynamoDB uses Hinted Handoff. To illustrate - say a key K is updated. Key K according to the rules of where keys go should lie in node X. However, node X is experiencing some personal troubles.
As discussed, all requests must have a coordinator, let's say it's node Y. When node Y tries to reach X, it can't. With hinted handoff
1. node Y stores what must be sent to X in a separate local data store. 
2. node Y will also keep checking up on X to see when it comes back up.
3. node Y will send this data to X once it is available again. 

What if node Y goes down? This information is now only in a local store in node Y. 
For this, node Y is in it's capacity as coordinator required to perform a durable write on at least one other node. If this is not possible, the write request is a failure. This is when none of the nodes in the preference list for a key are available. This should be a very unlikely scenario and only happen during major outages.

**Permanent Failures**

Scenarios where a node permanently goes down are rare but must be accounted for. Since, all data is replicated across N nodes, there needs to be a synchronization task that detects discrepancies and keeps them all in sync.
Dynamo uses Merkle Trees for anti-entropy. Merkle trees are normal trees with each node also containing a hash of all of it's children, which in turn contain a hash of all of their own children. 
Creating these trees is an expensive task but it all pays off in the ease with which one can detect discrepancies. When nodes gossip amongst each other, they're constantly broadcasting the hash of the root of the merkle tree.I f the hashes differ between two nodes - the differing keys are identified and a data transfer takes place.

Merkle Trees are great for synchronization because they reduce the network overhead greatly - both during actual data transfer and the constant discrepancy checks.
It is important to note that there is one merkle tree per range (per virtual node) maintained by each node.

**Membership**

Since transient failures are quite normal in a DynamoDB cluster, explicit admin actions are required to add or remove a node from the cluster. 
When a node is added, this node gossips with nodes to announce it's arrival. Token are assigned as per the position of the new node and all the data is moved to the new node in a background process.


**Takeways**

Managing a distributed data storage is hard.
The tunable nature of DynamoDB with it's three parameters (R, W, N) that make it adaptable to different use cases. 
The simple as hell interface makes one treat it like one is accessing a slightly sophisticated dictionary while there exists a mammoth system behind it.
The idea that most commercial system  don't require the levels of consistency and query complexity afforded by a traditional RDBMS and that this simplicity is there to be exploited.















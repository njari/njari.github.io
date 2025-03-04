---
layout: post
title:  "Notes : Dynamo DB Paper by Amazon"
date:   2025-03-04 11:26:31 +0530
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

The Dynamo DB API is accessible over HTTP. 


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

Uses vector clocks due to lack of a central clock authority.








-------- TBD -----------------------

















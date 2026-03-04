---
layout: post
title: "Are the MySQL docs lying about isolation levels?"
date: 2026-03-04 11:26:31 +0530
categories: testing
---

What are isolation levels in relational databases?

Isolation of transactions is a key offering of relational database systems and it’s manifestation are isolation levels. These define how the current transaction is affected by other transaction - in terms of what is visible to it and concurrency guarantees.

MySQL (and most others) offers four isolation levels:

Repeatable Read

Read Committed

Read Uncommitted

Serializable

Set up a tiny testing ground with the sql script at the bottom.

## Repeatable Read

![Repeatable Read Illustration]({{ "/assets/isolation-levels/.img1.jpg" | relative_url }})

Guarantees that the result of a certain select statement will not change during a transaction aka the first read is snapshotted and is treated as the final read. This is also the default isolation level. Even after the COMMIT in Block 2, the REPEATABLE READ transaction does not read the new values.

## Read Committed

![Read Committed Illustration]({{ "/assets/isolation-levels/img2.jpg" | relative_url }})

Only after the transaction is committed in Block 4 , the READ COMMITTED transaction is able to read the new data. This level does not guarantee repeatable reads as demonstrated.

## Read Uncommitted

![Read Uncommitted Illustration]({{ "/assets/isolation-levels/img3.jpg" | relative_url }})

The READ UNCOMMITTED transaction is able to read the new data even before it is committed. In Block 6, we see that a ROLLBACK is issued after which the READ UNCOMMITTED loses the previously read data. This is called a ‘dirty read’. This level also does not guarantee repeatable reads as demonstrated.

## Serializable

![Serializable Illustration]({{ "/assets/isolation-levels/img4.jpg" | relative_url }})

SERIALIZABLE makes all DML sequential instead of concurrent. This is the highest level of isolation.
Observe that once the SERIALIZABLE transaction has executed a SELECT statement, that table is locked for writes. The INSERT in Block 3 fails while waiting for this lock to be released. After the COMMIT in Block 4 , it is accessible again.

## Setup A Tiny Testing Ground

```sql
CREATE DATABASE isolationtest;
USE isolationtest;
CREATE TABLE testing_ground (
    foo INT,
    bar INT
);
---
layout: post
title: "A Series Of Silly Questions about Atomic Notes and My Answers in Progress"
date: 2026-03-30 11:26:31 +0530
categories: fieldwork
---

If you've been around the Personal Knowledge Management side of the world - you've heard of atomic notes. I had my first encounter with this concept during college - the first time I tried to use Obisidian. My workflow back then involved a lot of "work" and hence it was a colossal failure. 
Over time, I have refined how I do this and I believe I've arrived at something that works (for me). Personal knowledge management is first and foremost personal. 
Here I will try to elaborate on what made me stumble and what my current resolution to this is.
P.S. Although this is really not about note keeping in Obsidian, it is my application of choice purely because I love that the core of it is just markdown files. There is a sense of security about that and [here is a nice note by the creator about Obsidian's philosophy.](https://stephango.com/file-over-app)
Let's start with the silly stuff now. 

# What is an atomic note? 

The atomic note is a vague concept that has a few constraints that are really hard to reason about. 
If you're new to this - this is what everyone absolutely agrees on: 
An atomic note should capture a _single unit of thought_. 

Everything beyond this is a digression into people's personal workflows and how they like their folders (or lack of). 

This was too vague a guideline for me because as I sat to write my beautiful atomic notes that are going to grow into my little digital garden like this guy's - I simply couldn't frame my thoughts into these clean "units". 

## What is a single unit of thought? 

Thinking is best described by thinking out loud. Say, today I start reading about isolation levels in databases -- is each level a single thought or do they all make a composite atomic thought? Is it even my own thought? Haven't the people making and researching databases been thinking of this all along -- is this theirs? To me, this looks just like information - important but not exactly a thought. 

Now if I say - "Read Committed is the default isolation level for PostGres databases". Is this a thought or is it a regurgitation of information? 

Although this information isn't my own thought - it deserves have a place in my personal knowledge management because: 
1. It may save my ass one day
2. It tells me a lot more about how PostGres differentiates itself in the database market - it allows for higher throughput while sacrificing a bit of consistency that suits most use cases (as evaluated by the PostGres team, ofc).
3. It talks about how subtle differences - a tiny drop in compute - makes for vastly different user experiences at scale. 
4. Given that PostGres is a popular choice for most high scale systems at the moment - resulting in an overall belief that postGres is a highly scalable relational database as opposed to other options. Even without know  - I believed this. 
5. I also find it interesting that postGres made a hypothesis -> infra stuff is finicky -> teams want to delay making read_replicas and sharding as much as possible -> more throughput with the same deployment strategy will be appreciated. 
   P.S., I only imagine they made this hypothesis given what I know. No sources, just vibes. 

So now that we have meandered around what happens in my head when I read -> "Read Committed is the default isolation level for PostGres databases", we've unpacked a whole lot of tangential thoughts about 
- high scale systems today have defaulted to a very standard tech stack - why? 
- how we developers just "believe" things - why? 
- everyone hates making infra changes - why? 

These are now meatier things to unpack. They involve both what I know about PostGres and marries it with my own personal experience of "believing" things on the internet and optimising for the fewest infra changes. 
These seem quite far away from where I started off and can themselves serve as launchpads for even more ideas. 

# So is this what a single unit of thought looks like? 

Lets try to diagnose these ideas. 
These secondary thoughts are more general - in fact I can arrive at these ideas from other sources. These are also not new ideas - they've been accumulating and brewing somewhere and most likely have existing connections. 

This infographic shows how I would structure these in my notes.  

![Facts -> Thoughts]({{ "/assets/atomic-notes-define/image.png" | relative_url }})


This reflects how my mind makes connections. These are not obviously connected. For eg - how developers process online discourse is unrelated to this very specific choice made by the PostGres team. But my mind guided me there and hence, I must believe these are related. There is an inherent connection and I will honour that.

Most days, I will not be sitting and expounding with this kind of depth on a derived fact. That is not something I expect myself to do. But sometimes - the secondary thoughts really hit you and that's when you put them down. 

So to summarize - my workflow looks like this:

- put down any kind of text - no catalog - just a .md file with the current data and time. 
- even if you want to write something again in 5 minutes, new file. 
- create a link to anything that jumps out at you - not what's important, what you think. For eg - if i see something and I think its stupid - that's exactly what goes in my notes.  
- No judgment. You're allowed to be wrong and make snappy judgments. Write for your own self and use this as a thinking space. 
- go with your gut feeling - connections dont have to make any sense. No types of connection bullshit. If you thought of it, its connected. 
- make as many connections as you like. you'll quickly find yourself connecting by default.

The most important part of the workflow is YOU. You really are the centre of this world, please treat yourself so. Don't second guess, over-onalyse, take "feedback" or try to follow other people's workflows. Taking inspiration is lovely, take an idea and make it your own. 

This is a work in progress but I'm quite happy with where this has stabilised for now. I intend to reflect on this again and trace more changes in an years time. 

I am currently developing an agentic (maybe?) application to help myself (and you) write better. It's in it's nascent days and I hope to post about my experiments. The core of this is going to be your own notes and these connections with the end goal of writing pieces that feel like you. 

Follow along if you're keen. :) 

























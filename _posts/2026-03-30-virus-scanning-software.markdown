---
layout: post
title: "Detective Work and Software"
date: 2026-03-30 11:26:31 +0530
categories: fieldwork
---

Virus scanning software dominated back in the 2000s, everyone knew it was a good thing to have it - why and what it did was irrelevant. It was a proxy for being a [[responsible netizen]]. That word really had it's moment.  

First - what is a "virus"? 
A term borrowed from biology - it's a bit of code that can alter/take over key systems with an aim to be "malicious". 
The intended effects can range from - 
- extracting sensitive keys from your system 
- following you around on the internet - spying on activity 
- recording your keystrokes (aka passwords). 
- encrypting critical files. 
and this list goes on as far as human creativity allows. 

But malice is not testable. So are you buying when you buy a scanner software? 

As in offline life, let's pretend to be a detective that needs to evaluate a file for it's safety. We'll go from easiest to the most intensive bits. 

# Eliminate serial offenders and whitelist govt employees

- Most criminals are second time offenders - so first, let's compare against a set of known malware byte sequences. Since this is likely to be a massive database -- to do it with some efficiency we may use Bloom Filters. These are a bit of magic all by themselves -- check this! 
- Another kind of database is the File Hash Reputation Databases which can be quickly queried to check if the file is on it before downloading to confirm it's authenticity. This is a list of certified 'good boys' as opposed to the first list of offenders.

# Scan through his carry on - enforce a strict no knives policy

Akin to us checking a criminal's pockets - is he carrying lock picking equipment, we can do a heuristic analysis on the file. We must see what permissions it asks for and what parts of the system it wants to access. This can sound an alarm if these seem to beyond the scope we're comfortable with. 
An external application should not need root access unless there's some ulterior motive. This is why the recent OpenClaw release had people worried. First, users giving away root access should not be normalized, second - this one app itself could be misused. Given our lives are governed by so many apps that we trust - we shouldn't forget every file and app does not deserve our trust. 

# Employ the secret service to follow it around

run it inside a Virtual Machine and observe it's behaviour -- does it download some code? does it connect to some external server? does it write some files that are suspicious? does it start some long running processes that it do not align with it's announced purpose? 

If proof of ill intent is detected - the virtual machine can be disposed off without affecting the main system. 

# Call in a specialist

There exists AI trained to detect malware. Like all AI - we know the inputs and the outputs, the rest is a mystery. I do want to read further on what the results are. 

Overall, crime and detective work feed each other and both sides are always being as creative as possible. 
This recent bit of news inspired me to learn more here. Leaving a note on it here and hoping it's as interesting to you. 

# Mar 2026 - LiteLLM Github Account Takeover

[[Litellm]] is a open source library that is a layer over all other llms to allow applications to be built in an provider agnostic manner. It absorbs all the differences and provides an easy to use abstraction. 
In terms of popularity - claude code uses it - hence all of us using claude code using it use it too. 

What happened - the primary github account that owns the repository was hacked into.

Next, a new version of the software was released. This release was distributed through the same channels as legitimate releases to everyone using litellm - intentionally or unintentionally. 

This version altered a file that is called just before the python interpreter starts up -- a .pth file. However, due to a little bug in this code, it was discovered before it affected user systems. 

Read a timestamped account of events here.
https://cycode.com/blog/lite-llm-supply-chain-attack/



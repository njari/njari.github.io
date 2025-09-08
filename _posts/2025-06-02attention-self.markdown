---
layout: post
title:  "Cryptic measurements like Attention"
date:   2025-09-08 11:26:31 +0530
categories: papers
---


**ChatGPT and its Cultural Relevance, circa 2024**

ChatGPT took the world by storm in 2024, we saw users from all over use the tool for many tasks. All social media was flooded with how people were using it to improve their own workflows, get ahead and the expected fear mongering that comes with new tech. 
ChatGPT is a Generative Pretrained Transformer (GPT) wrapped into a nice chat interface. The foundational goals for such a model -
- one that is able to perform tasks non-trivial for humans 
    - we've all seen AI say a cat is a bat and a dog a rat
- contextualizing conversations and remembering context
    - we don't want to relate an event every time we chat about it
- general purpose and trainable to do any describable tasks
    - an assistant who's freely available and can "learn"
were laid in a groundbreaking paper from 2014 - Attention is All you Need by Vaswani et al. 


Here we'll talk about what really changed in 2014 and the key ideas discussed in the paper. This may be a series, who knows.

**Pre-2014**

Sequence transduction models are models that take in one input sequence and output another sequence. Translation, summarisation, speech recognition, all fall into this category of models. These are all very important applications that were being looked at long before LLMs. 
So what was state of the art in 2014? 
In 2014 we had RNNs and the vastly more improved variety of RNNs - LSTMs. 
Andrej Karpathy has a wonderful blog from 2015 emphasizing how groundbreaking RNNs were. https://karpathy.github.io/2015/05/21/rnn-effectiveness/
When one moves from a single input/single output to a sequence to sequence model - What really changes? 

The key idea for an RNN was to have inbuilt memory (hidden states) in neural networks. This memory is what allowed an RNN to contextualize. However, the more hidden states you have - the more you have to compute for each sequence and the more expensive it gets. 
An improvement the basic RNN was the LSTM -- this is an RNN that can decide what information to store and what to toss. It reduces compute but eventually does suffer fro mthe same problems. 

LSTMs were very  successful (even commercially) as single purpose models where one expected a model to be trained on very specific data and then to be used to predict the same. 
RNNs however could never reach the general purpose model benchmark. This was the age of enterprise models.

**Elephant in the Room **

First, we talk about this cryptic measurement called Attention. In layman (and expert) terms, it is a measure of how much a certain part of a sequences relates to another part. Consider this an arbitrary function that outputs the "relatedness" of any two positions in the input. 
In this paper, this is a dot product with extra steps like normalization etc. to keep the numbers sane. 

Why a dot product between two positions reveals the relatedness of two positions is rooted in high school vector math. A dot product is a projection of one vector onto the other and a measure of similarity. The same idea applies here and all sequences are interpreted as vectors. 
Attention was a concept already widely used in machine learning models pre 2014. 
This paper explores the possibility of using ONLY attention. 

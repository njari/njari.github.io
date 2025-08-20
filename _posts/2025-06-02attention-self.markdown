---
layout: post
title:  "Cryptic measurements like Attention - Attention is all you need"
date:   2025-06-04 11:26:31 +0530
categories: notes
---


ChatGPT and its Cultural Relevance, circa 2024

ChatGPT took the world by storm in 2024, we saw users from all over use the tool for many tasks. All social media was flooded with how people were using it to improve their own workflows, get ahead and the usual fear mongering that comes with new tech. 
ChatGPT is a Generative Pretrained Transformer (GPT) wrapped into a nice chat interface. The foundational ideas for such a model -
- one that is able to perform tasks non-trivial for humans 
    - we've all seen AI say a cat is a bat and a dog a rat
- contextualizing conversations
    - we don't want to relate an event every time we chat about it
- general purpose and trainable to do any describable tasks
    - an assistant who's freely available and can build capabilities
were laid in a groundbreaking paper from 2014 - Attention is All you Need by Vaswani et al. 


Here we'll talk about what really changed in 2014 and the key ideas discussed in the paper. 

Elephant in the Room 

First, we talk about this cryptic measurement called Attention. Consider this an  arbitrary function that outputs the relatedness of any two positions in the input. Generally, this is a dot product with extra steps like normalization etc. 
Why a dot product between two positions reveals the relatedness of two positions is yet to be explored. Attention was a concept already widely used in machine learning models pre 2014. 
This is an experiment with a model that only uses attention.


Pre-2014 

Sequence transduction models take in one input sequence and output another sequence. The relationship between the two can vary. Translation, summarisation, speech recognition, all fall into this category of models. 
So, pre 2014 - state of the art - we had RNNs, CNNs and offshoots like LSTMs. 
RNNs are neural networks that are able to process sequences and output sequences. Andrej Karpathy has a wonderful blog from 2015 emphasizing how groundbreaking this was. https://karpathy.github.io/2015/05/21/rnn-effectiveness/
When one moves from a single input/single output to a sequence to sequence model - What really changes? 

- we have to look at an arbitrary number of elements in a sequence. 
- the output will depend on the entire sequence. 
- the meaning of a certain element can alter based on its relative position and other elements in a sequence. 

RNNs adressed these very concerns. 

However, they were sequential and dealt with memory issues -- both an explosion and forgetting things. Hence, it was not very impressive when asked about long range topics. 
However, this was still an extremely meaningful chapter in AI history - we now had ways to niche down and make models for specific tasks that were really good. 
CNNs were great for computer vision because they encapsulate the very 2D nature of images.

The Encoder Decoder Stack 

The encoder decoder stack is also seen in the RNN world where RNNs were stacked together ending up with better results.















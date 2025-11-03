 ---
layout: post
title:  "Transformers - the meat minus the math"
date:   2025-011-03 11:26:31 +0530
categories: papers
---
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
</script>

 

 ChatGPT - the well loved and controversial tool that's permeated all online spaces is a a variation on a Transformer (slight). 
 The idea behind Transformers is simple yet powerful - especially coupled with the kind of compute and storage available today. 
We'll skip most of the math except when its easier to understand the math (this happens). I want this to be a way for me (and possibly others) to review transformers in the future with a skim. 

Let's follow a certain input statement through this system. Keep in mind this is only an idea of how things work - an actual transformer is a total black box and one can only speculate about how it may have gone through an input and what it may have gleaned from it. Still, I find this a useful way to analogise and understand the intuition behind transformers. 

Let's imagine we're a non human transformer - StupidBox - and StupidBox now needs to understand the following input. How would it go about this? 

Input : "The cat decided to push over the tumbler because it looked simply irresistable."


First, StupidBox is unfamiliar with English and is natively comfortable with 0s and 1s or a little more sophisticated - rational numbers. So very reasonably, step one is to translate this input statement into a set of rational numbers.
 It does have access to a tokenizer which performs a one to one translation of the input.A tokenizer’s goal is to break text into the smallest useful chunks — balancing frequency and meaning.
So instead of splitting by spaces, it looks for subword patterns it has seen before in its giant text corpus and for the above input statement - it may end up with something like 

["The", "cat", "decided", "to", "push", "over", "the", "tumbler", "because", "it", "looked", "simply", "irresist", "able", "."]

All these tokens are then mapped to an ID in a nD token vector space where they are clustered together based on "relatedness". For, eg - dogs and cats are going to be closer together than dogs and deer. This happens in the tokenizer and we end up with a list of nD token representations. This is called the input embedding. We're quite close to where StupidBox now knows what we're saying. 
Say, the output of the tokenizer is 

$$
E_i = [v1, v2, v3, v4 ]
$$

Here, $ E_i $ is now called the input embedding. It is, in essence, a dictonary lookup done by the tokenizer. 

However, a sentence is more than the sum of its words. So to really understand meaning - there are other aspects StupidBox also must focus on. How many such aspects can we name? 

- cat chasing a dog and a dog chasing a cat are two different things - ordering matters.
- What does “it” refer to? (the tumbler, not the cat) - nouns and pronouns
- “Cat” (subject) → “pushed” (verb) → “tumbler” (object)
- “The cat pushed…” vs. “The cat is pushing…” vs. “The cat will push…” - tense 
- simply irresistible - "simply" here adds something

to peel off another layer 

- some knowledge of the world to know cats do this playfully, not maliciously
- Cat and tumbler: physical interaction possible
- Push and over: co-occur often
- Because: causal connector

and another layer to see what how StupidBox should respond (if it wanted to pretend to be human). It would be natural to do any of the following

- ask about whether the tumbler was precious
- make a cat joke
- say the cat is cute
- forgive the cat

The core idea behind the above exercise is that - a simple human sentence carries a lot of meaning and requires context beyond what it literally contains. Additionally, although ordering is meaningful, there are relationships between tokens that may run in either direction.

Hence, now StupidBox needs to go about understanding this context. 
How does it do so - 
we know that any word could be related to any other word (in any way). 
But StupidBox only knows numbers so now it will try to crudely understand this rich context by employing self-attention. 

Say, it takes each token and tries to answer three about it - 
What am I looking for? 
What do I have to offer? 
What information can I share if someone needs me?

| Token  | Role        | Query (Q) — “What am I looking for?”                    | Key (K) — “What do I offer?”                                   | Value (V) — “What info do I carry?”              |
|---------|-------------|----------------------------------------------------------|----------------------------------------------------------------|--------------------------------------------------|
| The     | Determiner  | Looks for the noun it belongs to                         | Offers “I start a noun phrase”                                 | Word meaning “the”                              |
| cat     | Noun        | Looks for verbs or pronouns connected to it              | Offers “I’m a living agent / subject”                          | Concept of a cat — a small animal               |
| pushed  | Verb        | Looks for subject and object nouns                       | Offers “I’m an action connecting subject → object”              | The meaning “to apply force to something”       |
| the     | Determiner  | Looks for the noun it modifies                           | Offers “I start a noun phrase”                                 | Word meaning “the”                              |
| tumbler | Noun        | Looks for verbs or pronouns that act on it               | Offers “I’m an object / recipient of an action”                 | Concept of a tumbler — a drinking glass         |
| it      | Pronoun     | Looks for the noun it refers to (based on recency & type) | Offers “I refer to something inanimate / previously mentioned”  | The same entity as “tumbler”                    |










 **Elephant in the Room**


A certain cryptic measurement called Attention is at the core of Transformers. In layman terms, it is a measure of how much a certain part of a sequence relates to another part. For example, in the sentence *"The cat sat on the mat because it he bwas tired"*,  
the word **"it"** most strongly *attends* to **"the cat"**, not **"the mat"** —  
that’s how the model figures out what *"it"* refers to.  
A good attention function will be able to understand relatedness as well as we do. 


In this paper, this function is a dot product with extra steps( like normalization etc).
Why a dot product between two positions reveals the relatedness of two positions is rooted in high school vector math. A dot product is a projection of one vector onto the other and a measure of similarity. This is the intuition for how this works. 

How do we dot product words? 
Each word (actually token, this is a slightly different concept) is represented as a vector. This process is called encoding. 
Words/tokens are encoded into vectors called embeddings. 









So we have embeddings. For each embedding we calculate the following information - 
- What do I want to know? - Q
- What do I know? - K
Then we compute relatedness of what an embedding wants to know with what other embeddings already know to get how much an embedding should attend to the other embeddings.

 
 Instead of having an encoder analyse input tokens sequentially - we have a vector where each row represents a token. 
so the number of rows = number of tokens
 Now tokens are words and don't mean much to a machine so what this row needs to contain is a meaningful representation from the model's perspective. These meaningful representiations are called embeddings.
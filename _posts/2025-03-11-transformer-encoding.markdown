---
layout: post
title:  "Transformers - the meat minus the math - 1 [Encoders] "
date:   2025-011-03 11:26:31 +0530
categories: papers
---
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
</script>

 

 ChatGPT - the well loved and controversial tool that's permeated all online spaces is a a variation on a Transformer (slight). 
 The idea behind Transformers is simple yet powerful - especially coupled with the kind of compute and storage available today. 
We'll skip most of the math except when its easier to understand the math (this happens). 

Briefly, the transformer is a stack of encoders followed by a stack of decoders. Encoders take input and produce a context rich representation of it and decoders use this representation to provide an output. 

We'll look at how encoders work here.
Let's follow a certain input statement through this system. Keep in mind this is only an idea of how things work - an actual transformer is a total black box and one can only speculate about how it may have gone through an input and what it may have gleaned from it. Still, I find this a useful way to analogise and understand the intuition behind transformers. 

### Encoders

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

Say, it takes each token and tries to answer three questions about it - 
What am I looking for? 
What do I offer? 
What info do I carry?

| Token  | Role        | Query (Q) — “What am I looking for?”                    | Key (K) — “What do I offer?”                                   | Value (V) — “What info do I carry?”              |
|---------|-------------|----------------------------------------------------------|----------------------------------------------------------------|--------------------------------------------------|
| The     | Determiner  | Looks for the noun it belongs to                         | Offers “I start a noun phrase”                                 | Word meaning “the”                              |
| cat     | Noun        | Looks for verbs or pronouns connected to it              | Offers “I’m a living agent / subject”                          | Concept of a cat — a small animal               |
| pushed  | Verb        | Looks for subject and object nouns                       | Offers “I’m an action connecting subject → object”              | The meaning “to apply force to something”       |
| the     | Determiner  | Looks for the noun it modifies                           | Offers “I start a noun phrase”                                 | Word meaning “the”                              |
| tumbler | Noun        | Looks for verbs or pronouns that act on it               | Offers “I’m an object / recipient of an action”                 | Concept of a tumbler — a drinking glass         |
| it      | Pronoun     | Looks for the noun it refers to (based on recency & type) | Offers “I refer to something inanimate / previously mentioned”  | The same entity as “tumbler”                    |



The above table explores the noun - pronoun relationships that exist in the input. 
StupidBox might look at it as a function.


$$
\begin{align*}
Q_1 &= W_q v_1 \\
K_1 &= W_k v_1 \\
V_1 &= W_v v_1
\end{align*}
$$



The vectors $W_q , W_k, W_v$ are learned vectors and lets accept that $Q1, K1$ and $V1$ are reasonable representations for what v1 contains. Similarly, we will do this for all tokens. Now once we have calculated these values for all the tokens - we can compare them to glean some meaning from it. 
Here, we try to understand the token "it" and its relationship with all other tokens. 



$$
V_{it} = (Q_{it} \cdot K_{tumbler}) \, V_{tumbler} 
       + (Q_{it} \cdot K_{cat}) \, V_{cat} 
       + (Q_{it} \cdot K_{push}) \, V_{push} 
       + (Q_{it} \cdot K_{decided}) \, V_{decided} 
       + \dots
$$





| Token (source) | Value (V) summary                        | Attention weight | Contribution to “it”’s new meaning |
|----------------|------------------------------------------|------------------|------------------------------------|
| tumbler        | Concept of a glass / inanimate object    | 0.80             | Strongly shapes the meaning of “it” |
| cat            | Concept of an animal / living subject    | 0.10             | Slightly influences — possible confusion |
| push           | Action / verb meaning                    | 0.05             | Adds trace of “action context”      |
| decided        | Mental action / decision concept         | 0.03             | Almost negligible                  |
| others (“the”) | Article, no real semantic weight          | 0.02             | Very minor                         |


Hence $V_it$ strongly suggests it is refers to the tumbler. Hence, everything that related to "tumbler" also relates to "it". This is the contextual meaning we have found here. 

Now, StupidBox will evaluate each token against every other token to contextualize this relationship. This is what self-attention is. Mathematically, this is a scalar product of vectors which is a simple operation for StupidBox.

Now, since we saw that there are many aspects of meaning that need to be captured - StupidBox decides to have different sets of Q, K and V values for each. The foundational paper that introduced self attention used 8 heads, however models like the GPT series use dozens of them. Each head can be seen as a different way of looking at the input.

 Then we merge it all into one context rich understanding. 

Now StupidBox has numerical input with enough context and information to finally try to respond to this.


To be continued - we'll talk about decoders next to see what StupidBox intends to do with these numbers it has worked up. 
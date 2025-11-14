---
layout: post
title:  "Transformers - the meat minus the math - 2 [Decoders] "
date:   2025-11-11 11:26:31 +0530
categories: papers
---
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
</script>


Transformers are sophisticated logical machines that are trained to understand natural language and produce an output again in natural language. 

This requires transformers to first understand natural language, then contextualize it within the world the user operates in and then give a reasonable response based on the above two. 

We saw how transformers understand natural language by morphing them into context rich embeddings that hold both the input and its wider context in the user's world. This transformation happens in the encoder. [See how!](https://njari.github.io/papers/2025/11/03/transformer-encoding.html)

Next, the transformer needs to generate a response to this context rich understanding it has developed. Generation of this response happens in the decoder. 
The transformer is fully reliant on this calculation called attention. This is very succintly put in the the title of the paper that introduced Transformers - Attention is all you need by Vaswani et al. and this is what sets this architechture apart. 
We have learnt that the encoder employs multi headed attention to create this context rich understanding - which we will call $$ E_{\text{output}} $$ henceforth.
The decoder now employs attention in two different ways to generate a response. We will discuss these two in a bit. 

The output of the transformer is a a list of tokens and each token is generated one after another. 
This is a sequential process. 
Each token that is generated should "attend" (pay attention) to : 
1. What has been generated before that. 
  This is important for the whole text to make sense. This is obvious becuase this is something we do as well. To write the next line, you read the previous one and see what follows, right? 
2. The encoders output - i.e. the context rich understanding of the input.
  It's important to know what you're responding to if the goal is to give a coherent answer.


Let's extend our example from the discussion on encoders and follow it through the decoder. The transformer is presented with the input statement -
"The cat decided to push over the tumbler because it looked simply irresistable.". This input goes through the encoder layers and gives us $$ E_{\text{output}} $$.

Now, we enter the decoder. 
The decoder generates tokens one by one. The first token is fixed as a constant <start> token. There is a corresponding <end> token as well that will be generated when the decoder has "finished".
So, here is what our decoder output $$ D_{\text{output}} $$ looks like to begin with.  

$$ D_{\text{output}} = [ <start> ]
$$

Here, it will through a masked self attention layer and then a cross attention layer. Let's keep in mind what the decoder needs to pay attention to, each of these corresponds to a specific layer.

### Masked Self Attention

Next, $$ D_{\text{output}}$$  goes through the masked self attention layer. 
This layer looks at all tokens generated in $$D_{\text{output}}$$ upto the current token. 

For what it's worth, this is the same as a self-attention layer from the encoder. The layer performs self attention on whatever it has generated till the current token. To start with, we only have <start> so the first pass of this layer is trivial as it will be the same for all inputs.

If it's the same as the encoder layer's self attention, why does it have a fancier name? The masking in this layer is input but serves a different purpose (from what we're discussing). There are two modes of a any machine larning model - training and inference. We are currently discussing inference. The masking is useful in the training phase. However, it is kept in the inference phase to just keep the math the same. Everyone loves simplicity.


### Cross Attention

Next, we go through the cross attention layer. This is where we take into account $$ E_{\text{output}} $$.  
What we're saying is that - hey StupidBox, I know you've decided to say something based on what you've already said - but look at what you're responding to first! 
So StupidBox does what's told and pays attention to $$ E_{\text{output}} $$ and this contextualizes the output token. 

Now, here we have the following equations that show how this works : 

$$
\begin{align*}
E_{\text{output}} &=
\begin{bmatrix}
h_{\text{enc},1} \\
h_{\text{enc},2} \\
\vdots \\
h_{\text{enc},n}
\end{bmatrix},
\quad h_{\text{enc},i} \in \mathbb{R}^{d_{\text{model}}} \\[1em]
K &= E_{\text{output}} W_k^{(\text{enc})} \\
V &= E_{\text{output}} W_v^{(\text{enc})} \\[1em]
Q &= D_{\text{output}} W_q^{(\text{dec})} \\[1em]

\end{align*}
$$

Notice that the K and V are calculated based on the encoder's outputs and the query is based on the decoder's output.
Conceptually, the decoder is asking questions via its query vector $$Q$$ to understand what’s relevant in the encoder’s representation of the input which is represented by K and V. 
This is what cross attention is. 


So, to recap, there is a masked self attention layer and then a cross attention. 

| Step | Decoder Input So Far                | Masked Self-Attention Can See       | Cross-Attention Attends To (Encoder Context)                                      | Predicted Next Token |
| ---- | ----------------------------------- | ----------------------------------- | --------------------------------------------------------------------------------- | -------------------- |
| 1    | `<BOS>`                             | `<BOS>`                             | *The cat decided to push over the tumbler because it looked simply irresistible.* | “It”                 |
| 2    | `<BOS> It`                          | `<BOS> It`                          | Same full input sequence                                                          | “knocked”            |
| 3    | `<BOS> It knocked`                  | `<BOS> It knocked`                  | Same full input sequence                                                          | “it”                 |
| 4    | `<BOS> It knocked it`               | `<BOS> It knocked it`               | Same full input sequence                                                          | “off”                |
| 5    | `<BOS> It knocked it off`           | `<BOS> It knocked it off`           | Same full input sequence                                                          | “the”                |
| 6    | `<BOS> It knocked it off the`       | `<BOS> It knocked it off the`       | Same full input sequence                                                          | “table”              |
| 7    | `<BOS> It knocked it off the table` | `<BOS> It knocked it off the table` | Same full input sequence                                                          | `<EOS>`              |



### How do we understand this output? 

The transformer now has an output token that is informed by the input's rich context as well as earlier tokens that were generated. This output is in it's own native tongue - numbers  - how we represent probabilities. 
But we're expecting text right? Back in the encoder we talked about tokens and token ids which is how StupidBox was translating words to the numbers it needs. 
So we go about doing the same - in the opposite direction.
However, each number here is arrived at through so much that we can't really guarantee if it will correspond to a token exactly. So a one-to-one dictionary look up might not be the greatest idea. 
 Luckily, we do have a massive vector space of all possible tokens and overlay the output onto this and see what's around it. Now, there is a bit of subjectivity here - any word in it's vicinity is probably an okay match but we must select one.
We can select this token however - few ideas : 
1. Find the top 10 closest tokens to our output and randomly pick one. 
2. Always select the 5th closest token. 
3. Always pick the closest token. 
4. Find the top 10 tokens and vary the "randomness".

Once a token is selected, it is fed back into the decoder and this time the masked self attention layer will have to pay attention to this token while generating the next. This loop goes on till the decoder finally produces the special token <end>. 
That is the final output of the transformer.


### Conclusion 

ChatGPT in partuclar selects the top N tokens and selects one randomly amongst them. Interestingly, they vary the randomness using temperature.
This is a way to get wilder or more sober outputs from the same model to suit different purposes. 
 Their API itself has a temperature parameter. To have a fully deterministic output - one can set the temperature to 0, or for more "creative" answers one may increase it. At some point, it will start giving out nonsense because the selected token might be too far from whatthe decoder wants to convey. 

So here we have it, Stupidbox has learned how to understand and respond to human input and so have we. Cheers.




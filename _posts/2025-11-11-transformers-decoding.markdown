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


Transformers are sophisticated logical machines that are trained to understand natural language and produce an output in natural language. 

This requires transformers to first understand natural language, then contextualize it within the world the user operates in and then give a reasonable response based on the above two. 

We saw how transformers understand natural language by morphing them into context rich embeddings that hold both the input and its wider context in the user's world. This transformation happens in the encoder. Wnat to read more about this bit? 

Next, the transformer needs to generate a response. We know that the transformer is fully reliant on this calculation called attention. 
This is very succintly put in the the title of the paper that introduced Transformers - Attention is all you need by Vaswani et al. 
The decoder now employs attention in two varied ways to generate a response. 

The output of the transformer is a a list of tokens and tokens are generated one after another. 
Each token that is generated should "attend" (pay attention) to : 
1. What has been generated before that. This is important for the whole text to make sense. 
2. The encoders output - i.e. the context rich understanding of the input.


Let's extend our example from the previous piece and follow it through the decoder. The transformer is presented with the input statement -
"The cat decided to push over the tumbler because it looked simply irresistable.". Then the encoder creates a context rich understanding of this input and we have the encoder output which we will refer to as $$ E_{\text{output}} $$. 

Now, we enter the decoder. 
The decoder output is initialized with a constant <start> token. This is a constant.

$$ D_{\text{output}} = [ <start> ]
$$


### Masked Self Attention

Next, $$ D_{\text{output}}$$  goes through the masked self attention layer. 
This layer looks at all tokens generated in $$D_{\text{output}}$$ upto the current token. 

For what it's worth, this is the same as a self-attention layer from the encoder. The layer performs self attention on whatever it has generated till  the current token. To start with, we only have <start> so the first pass of this layer is trivial. 



## Training and Inference (and Masking)

If it's the same as the encoder layer's self attention, why does it have a fancier name? 
The masking in this layer is input but serves a different purpose (from what we're discussing). There are two modes of a any machine larning model - training and inference. 
Training is when we have both the inputs and the outputs and we're trying to get our model to take in inputs and predict the output. To achieve this, we are tweaking our weights - all the W matrices we've seen - till we get it just right (or close enough). 
During training, since we know the entire output before our model can generate it - we must hide it from that model or it will learn to be a cheat. If it learns to cheat, it's going to perform really well during the tests but be lost when it comes to the real world - where it won't know the output to begin with. 

Once the training is done, we fix the weights to the most optimal values we've found and put it into the real world. The real world is where we do inference. 
During inference, we don't know the tokens that come after the current token because they have not been generated yet. Masking is nonsensical here. However, it doesn't hurt and helps to keep the math the same all through (why write new equations and create confusion?). 


### Cross Attention

Next, we go through the cross attention layer. This is where we take into account $$ E_{\text{output}} $$.  
What we're saying is that - hey StupidBox, I know you've decided to say something based on what you've already said - but look at what you're responding to first! 
So StupidBox does what's told and pays attention to the encoder's output (representiation of actual input)

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

The transformer now has an output that is informed by the input's rich context as well as itself. This output is in it's own native tongue - numbers  - how we represent probabilities. 
But we're expecting text right? Back in the encoder we talked about tokens and token ids which is how StupidBox was translating words to the numbers it needs. 
So we go about doing the same - in the opposite direction.
However, each number here is arrived at through so much that we can't really guarantee if it will correspond to a word exactly. So a one-to-one dictionary look up might not be the greatest idea. 
 Luckily, we do have a massive vector space of all possible tokens and overlay the output onto this and see what's around it. Now, there is a bit of subjectivity here - any word in it's vicinity is probably an okay match but we must select one.
We can select this token however - few ideas : 
1. Find the top 10 closest tokens to our output and randomly pick one. 
2. Always select the 5th closest token. 
3. Always pick the closest token. 
4. Find the top 10 tokens and vary the "randomness".

ChatGPT in particular is known to do something like option 4. The variable of randomness is called temperature - a nod to thermodynamic concepts. at 0 temperature, it is a deterministic system and as the temperature increases, the randomness increases too. 


### Conclusion 

So here we have it, Stupidbox has learned how to understand and respond to human input and so have we. Cheers.



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
Each token that is generated should "pay" attention to : 
1. What has been generated before that. This is important for the whole text to make sense. 
2. The encoders output - i.e. the context rich understanding of the input.


Let's extend our example from the previous piece and follow it through the decoder. The transformer is presented with the input statement -
"The cat decided to push over the tumbler because it looked simply irresistable.". Then the encoder creates a context rich understanding of this input and we have the encoder output which we will refer to as $$ E_output $$. 

Now, we enter the decoder. 
The decoder output is first initialized with a constant <start> token. This is a constant.

$$ D_output = [ <start> ]
$$


Next, $$ D_output$$  goes through the masked self attention layer. This layer looks at all tokens generated in $$D_output$$. This is called "masked" because we must ignore all the tokens that come after the current token. This "masking" is only useful during training since during inference, we don't know the tokens that come after the current token because they have not been generated yet. However, it doesn't hurt during inference and helps to keep the math the same all through. To start with, we only have <start> so the first pass of this layer is trivial. 

Next, we go through the cross attention layer. This is where we take into account $$ E_output $$.  
Now, here we have the following: 

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












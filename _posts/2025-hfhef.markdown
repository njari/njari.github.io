 ---
layout: post
title:  "Transformers after stripping away the frills"
date:   2025-09-10 11:26:31 +0530
categories: papers
---
 


 **Elephant in the Room**

This cryptic measurement called Attention is the core of Transformers. In layman terms, it is a measure of how much a certain part of a sequences relates to another part. 
So we have embeddings. For each embedding we calculate the following information - 
- What do I want to know? - Q
- What do I know? - K
Then we compute relatedness of what an embedding wants to know with what other embeddings already know to get how much an embedding should attend to the other embeddings.
In this paper, this is a dot product with extra steps like normalization etc. to keep the numbers sane. 

Why a dot product between two positions reveals the relatedness of two positions is rooted in high school vector math. A dot product is a projection of one vector onto the other and a measure of similarity. The same idea applies here and all sequences are interpreted as vectors. 

This is a very rudimentary explanation for what attention is. I will explore this further with a concrete example in another post.

 
 Instead of having an encoder analyse input tokens sequentially - we have a vector where each row represents a token. 
so the number of rows = number of tokens
 Now tokens are words and don't mean much to a machine so what this row needs to contain is a meaningful representation from the model's perspective. These meaningful representiations are called embeddings.
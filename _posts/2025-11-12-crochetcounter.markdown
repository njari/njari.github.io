---
layout: post
title:  "Crochet Counter - Product Note "
date:   2025-11-12 11:26:31 +0530
categories: notes
---

### Introduction 

Crochet is an fabric artform that relies on a hook and yarn and is worked in rows to make various decorative items/toys/garments. 
Each row is a collection of stitches and there are a few basic stitches. 

- Chain Stitch
- Skip stitch (or lack of a stitch)
- Slip Stitch 
- Single Crochet
- Double Crochet 
- Treble Crochet 

All other stitches are either variations on these or a composition of the above.
For instance - single crochet back loop only is a variation of the single crochet.
and the mesh stitch is a combination of a chain and a double crochet. 

All crochet items are made from patterns - these can be commercial patterns made by pattern designers or self drafted. 
This is typically a pdf documenting the pattern designer's instructions and notes. 
There is no standard format for patterns - however, there is a common language of stitches that is used. However, this is "common" nomenclature itself comes in two flavours - US and UK. To make things more complicated - the same words are used to refer to different stitches in both leading to widespread frustration and confusion while using patterns. 

| **UK Term (Abbrev.)**       | **US Term (Abbrev.)**     |
| --------------------------- | ------------------------- |
| Double crochet (dc)         | Single crochet (sc)       |
| Half treble crochet (htr)   | Half double crochet (hdc) |
| Treble crochet (tr)         | Double crochet (dc)       |
| Double treble crochet (dtr) | Treble crochet (tr)       |
| Slip stitch (sl st)         | Slip stitch (sl st)       |
| Chain (ch)                  | Chain (ch)                |


These patterns are not always memorizable and need one to refer back to it many times (interrupting flow). There are many cases where each row is unique - for instance, in the case of filet crochet and tapestry patterns. 

An very simple example row -> 

$$
\begin{align*}

dc x 10 , [ch, dc ] x10, dc x 10 

\end{align*}
$$


Similarly - there are complex patterns that require rigorous counting across 100s and 1000s of stitches. 
There are some mechanical solutions out there. Most crocheters use "stitch markers" that they pin into - say, every 10th row. This reduces counting since one only needs to count beyond the last marked stitch but counting remains an important part of the process. 

Also, crocheters love to savour their work and know how long it takes them to work on a certain project. It is common to have multiple WIPs at a time.  Projects can clock from anywhere within an hour to years depending on the scale and complexity of the pattern and the crocheter. 
So forgetting where your count is on a particular project is a common occurence. 


### Goals

1. Give crocheters an easier time with counting their stitches. 
    - have the stitches counted row by row 
    - have a row counter
    - name "markers" and keep notes on what they mean. For eg - 100th row, or decreases started here, round begins here
    

2. Allow for flow while crocheting

    What breaks flow? Biggest culprits -> 
    - looking at the pattern
    - translating patterns 
    Hence, we can do the following : 

    - store pattern in an easy to read form - such that it is at the artist's fingertips.
    -  translatxe patterns from US -> UK -> symbols to remove friction


### User Journeys 


## User Sign Up 
- we'll have a simple username and password system for the time being. 
- Everything will be stored on device. Later think about whether this data should be stored centrally. (I don't want to pay for storage)
- later enhance this with email verification, etc. 


### Journey no 1 - <i>Writing down a pattern</i> 

Provide a space for a detailed plan for the project being undertaken.

Meta information one would store - 
nomenclature system
Name, 
hook size
yarn used 
notes (optional)
item type - this can be used to give a little graphic for a sweater/top/toy etc

row information
[ x , y , z ] x n1
[y , z , x ] x n2
... 


x , y, z are stitches and n1, n2 are the repeats of each row. 
For now we will focus on single panel patterns. All larger pieces can be broken down into single panel patterns. (even ones worked in the round as one only has to keep track of the rows).


### Journey 2 - <i>Using the pattern</i> 

Allow users to go through each row one and mark it as done/undo it. One can end at any point in a row. 
This should be saved and progress can be shown as a bar? 
On completing the very last row - one can have a celebratory gif that pops up. 


### Journey no 3 - <i>Translating a pattern</i> 

Allow users to create a pattern and translate it to another system. Then use as above. 
This is a major annoyance with patterns - having to do the mental gymnastics to keep track of what your hands must do. 

### Journey 4 - <i>Analytics</i> 

We will log the hours taken for a certain project (have a pause/play button when you're crocheting). 
Count how much is frogged and how many stitches did one make. 
These are statistics to delight the user because the user cares about the time and effort they have invested into their handmade project.


### Further Ideas.

- Count stitches using a watch app - eliminating the need for the user to update here.

- Create patterns for others to use. Social Network element - ravelry exists. 

- Onboard existing pattern creators to provide their patterns in a better format - not just pdfs as they are now.

- Read visual crochet charts and traslate into rows. 

- Tell if a crochet object in a picture is AI or not. A problem the crochet community is dealing with rn. Good way to gain traction? 


- rewards - hour based, frogging based - inspired by StackOverflow's uncanny reward system.

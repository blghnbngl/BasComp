# bascompsemibehavioral
Basic Computer Semi Behavioral Description

-This is incomplete, but I put it for you to see before we talk to Uluc Hoca. Some modules and wires are likely to change.

-This is semibehavioral, because inside working of modules is behavioral but the connections between them are done with dataflow modelling.

- There are some differences between the project that Enes started. First, in the Enes' project, all the necessary modules were directly connecting to each other (if I understood correctly). Rather, I did it with a bus as we saw it in the class. For this, I created a module called buschooser. This module is controlled by control module and chooses who can speak to bus at a given time. Also, all the necessary modules take their input from the bus, when the load signal comes whatever is in bus gets loaded. Secondly, I changed most of the wire names but if you want it to be in Enes' way I can switch them back.

- The real thing happens in control module. What's in there is similar to all-behavioral module I wrote before. The difference is that this time control module does not do any assignments itself, but send the necessary signals to outer modules. If you want to understand what this semi behavioral is all about, it is enough for you to look just at the control module. 

-As I said, this is incomplete. Below are some of the incomplete points and possible problems:

1) Above the main module, there should be a module called board. This module deals with physical input/outputs and also slowing of the FPGA's clock.

2) I'm not sure whether the timing of the always blocks be correct. Some take posedge clk as input, sone take * as input, etc.

3) Start, interrupt, halt are a bit problematic.

4) Input output serial transfer is very problematic and I do not know how to exactly do them.

I'm sure some more problems are likely to occur, but the main structure is solid, I guess.

UPDATE 1 (DATE: 25.07.2016, 01:39) (By Bilgehan): I have made several simple updates.
a) Earlier, I did not have the time to write all the wire definitions in the main module. I completed them so all the wire definitions required in the main module should be in place.
b) A few simple mistakes sticked to my eye so I corrected them, and also added a few more comments.

---
title: Barista
description: An awesome bar graph widget for Dashing
author: Michael Woffendin
tags: bar, widget, dashing, graph, bar graph
created:  2014 Mar 13
modified: 2014 Mar 13

---

Barista
=========

![alt tag](https://raw.github.com/osu-sig/Bar-Widget/master/bar_widget_screenshot.png)

## What is it?

Sick of pie charts? Here's something different! View proportionality of multiple values within a set, or view utilization within different sets with Barista!

No more messing around with Javascript for styling. Everything from the color palate to the size of the graphs is determined by CSS. Just supply some simple rules and Barista will do the rest. If you are the kind of person who gets annoyed by 1px offset, Barista has built-in classes that enable easy fine-tuning.

Flexible! Want one graph per tile? Easy. Want multiple graphs per tile? Still easy! Want massive graphs on a 5-column wide tile? Barista can do it! Just give it data and maybe do some CSS tweaking.

## How do I use it?

There are two ways to use Barista: comparing values within a series, and comparing a single series value to a maximum. Look at the demo job to get an idea of what data you'll need to send. 

Make sure that the tile has a background-color and font-size set, as Bar uses those when drawing the graphs. You may want to just modify the supplied bar.scss to meet your needs. 

## What are the options?

Each of these options should be supplied as a key-value pair inside a series.
* hide_percentages : Hides percentages being drawn inside the bars. Boolean
* hide_total : For multiple value series, hides the total above the graph. Boolean
* max_value : Must be supplied if using single value series. Must be larger than the value's value. Should be an integer (can have units though)

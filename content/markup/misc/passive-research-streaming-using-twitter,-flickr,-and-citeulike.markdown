--- 
kind: article
title: Passive research streaming using Twitter, Flickr, and CiteULike
category: misc
created_at: 2008-03-18 20:56:28
---
<a href="http://mndoci.com/blog/2008/03/09/aggregators-and-meta-conversations/">Deepak</a>, <a href="http://nsaunders.wordpress.com/2008/03/10/lifestreaming/">Neil</a>, and <a href="http://blog.openwetware.org/scienceintheopen/2008/03/10/a-small-feeding-frenzy/">Cameron</a> have set up life streams which aggregate the feeds from services from sites like Last.fm and Flickr into a single set of posts. I'm a bit wary of this doing this because I already get easily distracted by Ruby and bioinformatics blogs, but Neil gave me an idea when he wrote about using these technologies to track research. I currently use <a href="http://subversion.tigris.org/">Subversion</a> to back up my project files, and I noticed <a href="http://twitter.com/bioinformatics">Twitter</a> status updates are very similar in length to subversion log messages. I created a short script so that every time I do a subversion repository check in, the message is also sent to Twitter.

<!--more-->
<pre lang="bash">#!/bin/sh
#Inspired by tinyurl.com/yt4ssq

# Scrub weird characters
MSG=`echo $@|tr ' ' '+'`

# Send twitter request
curl --basic --user "username:password" --data-ascii "status=$MSG" "http://twitter.com/statuses/update.json"

# Send SVN request
svn ci -m $MSG</pre>
Combined with an RSS Wordpress plugin, my most recent research activity from Twitter is displayed as a stream on my blog. Taking this a step further I included feeds for my research tagged Figures on Flickr, my paper bibliography on CiteULike, and discussion of my research on my blog. <a href="http://www.michaelbarton.me.uk/research-stream/">This stream is available on www.michaelbarton.me.uk/research-stream/</a>, and shows the general idea of what I'm trying to do. I like this because in bioinformatics its sometimes difficult to know what other people are doing, but, now I hope that other people in my group can have a quick glance to see what I've been up to. Furthermore this all works passively, where I'm already using these services in my research anyway, and the only thing I had to do, was use yahoo pipes to aggregate the already existing information.

Because bioinformatics work is amenable to being displayed, shared, and edited on the web I think that the field should be at the bleeding edge of using Web 2.0 services like this. Of course many other bloggers before me, in particular Deepak, are already discussing this. Compared to most mashups what I've created is a rather shoddy as I'm cobbling together various services and trying to use Wordpress plugins to create something not exactly what they were intended for. However I don't have much time in my PhD to spend experimenting, and I think this would be true for most scientists. Therefore the more that existing services can be used, the better. As a further example, I think Flickr has a lot of potential, and I would like to create a group for my lab, so everyone can upload and tag their figures, as they are producing them. Then the group's pictures can be browsed and organise by tag to visualise what everyone is working on. The only effort required is for people to upload and tag their photos as they are making them.

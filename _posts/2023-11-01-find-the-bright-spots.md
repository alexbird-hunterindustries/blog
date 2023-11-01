---
  title: Find the Bright Spots
  subtitle: Notes while reading Switch
  author: Alex Bird
  layout: post
---

If I had to describe how to identify, analyze, and address problem areas, I
could probably give very precise and thorough instructions. Maybe you could too. 
It seems that "fix what's broken" is a common approach to problem solving.

In the book *Switch*, Dan Heath and Chip Heath suggest that problem solvers "find the
bright spots". If you're familiar with
[Woody Zuill's talk "Turn Up The Good"](https://www.youtube.com/watch?v=Y1u6Hzve6rk),
it seems to me that both give the same advice:

**When a solution exists already in some small space or time, find a way to
make that solution work more broadly.**

This is an application of the axiom "don't reinvent the wheel": before we start
from scratch dreaming up new solutions to our problem, let's see what's already
working. Are the folks who don't experience the problem? What's unique about
them or their setting? Is there a time when we don't see the problem manifest?
What is special about those times?

### Some examples

 - If we have a new test strategy and one team is applying it with success and
   satisfaction, but others are not: let's chat with the team for whom it's
   working
 - If we are frustrated with a tool, but one team has no concerns with the tool:
   let's work with them and see if there is something different about their
   workflow that avoids the problem
 - If we want to improve the reliability of our pipelines, and one team has
   really reliable pipelines, let's go learn from them

### Applying "find the bright spots" to software dev

We have lots of tricks and techniques for solving software problems with
process, tooling, architecture, etc. After reading *Switch*, I have a new
technique to add to the repertoire: *find the bright spots*

1. Understand the problem
2. Identify those impacted by the problem (or those likely to be impacted by the
   problem)
3. Determine if any of them don't experience the problem or experience a lesser
   version of it
4. Work with those folks to understand what they're doing differently. You will
   need their help to understand what they're doing, and they may need your help
   to understand what "everyone else" is doing. Maybe, by working together, you
   can come up with a set of recommendations that others could follow that would
   resolve the problem
5. Share your findings with other folks who are impacted by the problem

### Comparing to other problem solving techniques

#### Compared to outside research

A related technique that I'm more familiar with is to search for expert advice
in blogs, recorded conference talks, textbooks, or other places where folks with
experience have communicated what worked for them in a similar situation. When I
find someone who faced a similar problem, I study their solution and consider
whether there is something I can apply from that to our context.

The *find the bright spots* approach is similar, except we're looking within our
organization for the expertise, and it may be less obvious than a text book. The
folks who don't have the problem probably haven't written a how-to guide for
imitating them; we would have to collaborate to put their experience to words
that are meaningful to others.

#### Compared to brainstorming

The *find the bright spots* approach is different from any brainstorm-based
approach because instead of looking in our own mind and experiences for a
solution, we look to others. It shifts the work from solution generation to
solution facilitation.

There is also a difference in quality: any solution found to be working in
practice has a big head start over a newly generated solution. All things being
equal, it seems preferable to start with a proven solution and apply it more
generally than to invent something new. Only if there is no proven solution
available do we turn to new ideas.

### Downsides

This process can take a lot of research: identifying the affected group,
surveying group members, etc. If a problem is simple enough, it may be "good
enough" to invent a solution in isolation. Probably the *find the bright spots*
approach becomes more viable as the scale and impact of the problem increase.

### Open questions

I would like to learn more about *how* to identify, understand, and share
existing solutions. Probably the better I get at this, the less effort-intensive
the process, and the more often I can apply it.

### Conclusion

Before inventing a new solution, consider looking for folks who don't have that
problem, and enlist their help in generalizing their approach. It doesn't always
make sense to solve problems this way, but it's good to consider it as an
option.

---
  title: "&ldquo;Jump onto the desk, Harry&rdquo;"
  subtitle: Distributed Monoliths, Harry Potter, and Half-Doing New Ideas
  author: Alex Bird
  layout: post
---

In the fourth Harry Potter book, there is a scene where the Defense Against the
Dark Arts teacher is teaching the class about illegal spells. One of those
"unforgivable curses" allows the one who casts it to control the mind of the
person on whom they cast it.  When it's Harry's turn to experience this Imperius
Curse, he finds he is unexpectedly able to resist the spell -- partially. Here's
what happens after Professor Moody casts the curse on Harry in class:

> &ldquo;And then he heard Mad-Eye Moody’s voice, echoing in some distant
> chamber of his empty brain: *Jump onto the desk&hellip; jump onto the
> desk&hellip;*
>
> Harry bent his knees obediently, preparing to spring.
>
> *Jump onto the desk&hellip;*
>
> Why, though? Another voice had awoken in the back of his brain.
>
> Stupid thing to do, really, said the voice.
>
> *Jump onto the desk&hellip;*
>
> No, I don’t think I will, thanks, said the other voice, a little more
> firmly&hellip; no, I don’t really want to&hellip;
>
> *Jump!* NOW!
>
> The next thing Harry felt was considerable pain. He had both jumped and tried
> to prevent himself from jumping — the result was that he’d smashed headlong
> into the desk, knocking it over, and, by the feeling in his legs, fractured
> both his kneecaps.&rdquo;
>
> ― J.K. Rowling, Harry Potter and the Goblet of Fire 

**Sometimes, half-doing hurts more than doing or not doing.**

### Half-doing new ideas

In software development, we sometimes respond to new ideas just like Harry
did with the suggestion "jump onto the desk" -- we end up trying the new thing,
but also resisting it, and the results are underwhelming. Ron Jeffries, one of
the signatories of the [Agile Manifesto](https://agilemanifesto.org/), writes
about this phenomenon in a post called
["We Tried Baseball and It Didn't Work"](https://ronjeffries.com/xprog/articles/jatbaseball/).
He tells a story of a group that hears about baseball, wants to try it, but
makes so many substitutions and alterations to the rules that the result is
unrecognizable as baseball -- and then they conclude that they don't like
baseball.

I have seen this happen in software development with team processes and
architecture with similar outcomes. Folks try collaborative programming, but
don't learn about how to work together, and the result feels like you're coding
with a judge watching your every move. Or, folks try TDD without learning about
refactoring and making code easy to test, and they find themselves frustrated by
how difficult their development process has become.

By contrast, I had a coworker who taught me a lot about mob programming who
admitted that when he first heard about it, he was strongly opposed to the idea.
I remember him telling me something like this:

> I thought mobbing was a bad idea, but the only way I could prove that was to
> try it sincerely for a few weeks. If I didn't try it wholeheartedly in those
> two weeks, then I couldn't fairly say that I disliked it.

To his great surprise, he found collaborative programming satisfying and
effective, and he and his teammates adopted it as their regular development
practice. When I joined their team, that was my first time in a group that did
ensemble programming full-time. That was a great experience!

#### Why do we half-try an idea?

There are at least two big reasons:
1. We don't like the idea -- like Harry being told "jump onto the table". We
   hear it, understand it, but some part of us is against it.
2. We focus on the unimportant details -- like the folks who tried baseball and it
   "didn't work". We hear the idea, adopt it with zeal, but only some parts --
   and the parts we leave out turn out to be essential.

#### Half-doing microservices: the distributed monolith

When it comes to microservice architecture, the "half-tried" version is so
common it's been given a name: "distributed monolith". The antipattern goes like
this: folks diligently separate their monolith into many microservices which can
be compiled, unit-tested, and deployed independently -- but leave in place some
other type of coupling that prevents independent development. The result is that
all the code must still be deployed as a unit. For example, multiple services share
a database, so any schema changes impact all of the services. They successfully
completed a big part of the monolith-split work -- splitting the code and
compute infrastructure -- but since they share the database the services cannot
be changed independently. Not only are they missing out on the benefits, they
have also introduced a new problem. When it was a monolith, a change to one part of the
system that was incompatible with another part of the system resulted in a
compiler error or unit test failure. Now, one part of the system can be compiled
and unit-tested in isolation, even if it breaks another part of the system. In
this setup, it's not until we deploy the microservices together that we see the
problem.

Here are some symptoms of a distributed monolith:
 - When we want to run our service locally we must also run one or more other
   services; our service cannot operate independently
 - When we add a feature, we must deploy changes across multiple pipelines in a
   specific sequence or the deployment will fail
 - When a new person joins the team, we have to teach them about the inner
   workings of other services before they can contribute well to changes to our
   service
 - In production, if there is an outage in one service, the others don't work
   either

In a monolith world, we still had all of those challenges -- except there was a
single code repository, a single build process, and a single pipeline to
coordinate the work. By splitting up the monolith, we can no longer rely on
those centralized tools for the coordination. If changes to our application
still require coordination, we're left manually coordinating something that used
to be tool-supported.

**The problem with a distributed monolith is that we have the complexity of a
distributed system with the challenges of a monolith.**

#### "Jump on the desk" -- how to recognize a full commitment to microservices

To avoid the challenges of the monolith, we need entirely independent services.
That independence needs to span from design and coding through to deployment and
operation of the service in production.

- in **dev/test**, we can run one service locally without also running any others
- in **dev/test**, we can demonstrate that our new feature works without running
  any other services
- in **dev/test**, we can change shared code without coordinating with owners of
  other services (the other service owners can opt in to our changes at any
  time that is convenient for them)
- while **deploying**, we can deploy our service even when other teams'
  pipelines are blocked
- in **production**, our service can run even when other services have outages.
- during a **production incident**, we can debug our service without
  understanding other services

#### Splitting a monolith so you have isolated services

Those goals are nice, but -- practically speaking -- how do we keep our service
isolated throughout all the stages of the software development lifecycle? How do
we avoid the "half-jump" that crashes us into a desk?

##### Extracting a single service from an existing monolith

Let's suppose we have a monolith and we want to extract a new, isolated service
from it. How do we start?

1. As an organization, we create an independent team to be responsible for the
   new service. (This is an example of an
   [Inverse Conway Maneuver](https://martinfowler.com/bliki/ConwaysLaw.html)
   where one instigates an architecture change by changing the team structure.
   The team structure change is formal; the resulting architecture change is
   organic.)
2. As a member of that new team, we pay attention to anything that prevents us
   from working independently -- where are we forced to coordinate with others?
3. On the new team, we focus our improvement efforts on the areas with the most
   coordination friction. We make technical changes to separate the code and
   infrastructure needed by the new team. This could include:
     - moving code from the main code repository to a new one
     - creating a new deployment mechanism to deploy the code independently
     - separating production monitoring or other debugging tooling
     - creating an independent development environment so the new team can work
       on their code without running the rest of the monolith
     - other creative ideas from the team

#### Getting started: let the retrospectives drive the change

Since every application is unique, you're unlikely to find every source of
coupling in a generic list of steps to split a monolith. We'll have a very independent
production environment but entangled development processes, or independent code
and deployment but a highly coupled design process, or we'll have a small shared
database that forces us to coordinate changes, or a shared config file, or some
other project specific source of coupling. When we focus on the mecahnical steps
to extract a service, we are likely to end with an incomplete separation.
Instead, we observe and reflect on what keeps us from the goal of independent
delivery, and address those obstacles. That's how we'll "fully jump onto the
desk" and get the much-desired benefits of a microservice architecture.

To triage between our ideas for what to change first, we can follow the "Easiest
Nearest Owwie First" approach introduced by Geepaw Hill in his
[post on tackling scary refactorings.](https://www.geepawhill.org/2019/03/03/refactoring-pro-tip-easiest-nearest-owwie-first/)

1. First, we look for something painful (that's the "Owwie")
2. We don't need to go searching; we can look for something that comes across
   our path in the course of our regular work (i.e. "Nearest", not "Hidden")
3. We limit ourselves to problems that we can actually do something about ("Easiest").

Once we tackle the first Nearest Easiest Owwie, we move on to the next. Each
time we ask "What did we notice this week that is keeping us from delivering
independently?", and then fix it. In that way our big architecture refactoring
initiative turns into a series of small steps.

### Conclusion

When trying out new ideas, beware of our inclination to resist what's new, or to
focus on non-essential details. Instead, identify the key outcome and iterate
towards a point where you achieve that. You may make use of standard advice and
suggestions as you pursue the goal, but you may also invent something new. In
particular with microservices, that means that an independent service can be
built, tested, deployed, and operated without coordinating with other services.


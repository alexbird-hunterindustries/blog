---
  title: "Jump onto the desk, Harry"
  subtitle: Harry Potter, the Imperius Curse, and Distributed Monoliths
  author: Alex Bird
  layout: post
  hidden: true
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

In software development, sometimes we respond to new ideas like Harry did to the
suggestion "jump onto the desk" -- we end up trying the new thing, but also
resisting it, and the results are underwhelming. Ron Jeffries, one of the
signatories of the [Agile Manifesto](https://agilemanifesto.org/), writes about
this phenomenon in a post called
["We Tried Baseball and It Didn't Work"](https://ronjeffries.com/xprog/articles/jatbaseball/).
He tells a story of a group that hears about baseball, wants to try it, but
makes so many substitutions and alterations to the rules that the result is
unrecognizeable as baseball -- and then they conclude that they don't like
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
practice. When I joined their team, that was my first time in a group that does
ensemble programming full time.

#### Why do we half-try an idea?

There are at least two big reasons:
1. We don't like the idea -- like Harry being told "jump onto the table". We
   hear it, understand, but some part of us is against it.
2. We focus on the unimportant details -- like the folks who tried baseball and it
   "didn't work". We hear the idea, adopt it with zeal, but only some parts --
   and the parts we leave out turn out to be essential.

#### Half-doing microservices: the distributed monolith

When it comes to the microservice architecture, the "half-tried" version is so
common it's been given a name: "distributed monolith". The antipattern goes like
this: folks diligently separate their monolith into many microservices which can
be compiled, unit tested, and deployed independently -- but leave in place some
other type of coupling that prevents independent development. The result is that
all the code must still be deployed as a unit. For example, multiple services share
a database, so any schema changes impact all of the services. Splitting the code
and compute infrastructure was 80% of the monolith split work, but as long as
they still share the database the services cannot be changed independently. When
it was a monolith, a change to one part of the system that was incompatible with
another part of the system resulted in a compiler error or unit test failure.
Now that the monolith has been split, one part of the system can be compiled and
unit tested in isolation, and it's not until we deploy the microservices
together that we see the problem.

Here are some symptoms of a distributed monolith:
 - Changes need to be coordinated across multiple deployment pipelines ("make
   sure we push to the Glarrrb pipeline first, otherwise our change to Flummox
   will fail")
 - To run a microservice locally, the others services also need to be run
   locally
 - When a new person joins the team, you have to teach them about the inner
   workings of other services before they can contribute well to changes to your
   service
 - If there is an outage in one microservice, the others don't work

In a monolith world, we still had all of those challenges -- except there was a
single code repository, a single build process, and a single pipeline to
coordinate the work. By splitting up the monolith, we can no longer rely on
those centralized tools for the coordination. If changes to our application
still require coordination, we're left manually coordinating something that used
to be tool supported.

**The problem with a distributed monolith is that we have the complexity of a
distributed system with the challenges of a monolith."

#### "Jump on the desk" -- how to recognize a full commitment to microservices

To avoid the challenges of the monolith, we need properly independent services. That
independence needs to span from design and coding through to deployment and
operation of the service in production.**

- in **dev/test**, we can run one service locally without also running any others
- in **dev/test**, we can demonstrate that our new feature works without running
  any other services
- in **dev/test**, we can change shared code without coordinating with owners of
  other services (the other service owners can opt in to our changes at a time
  that is convenient for them)
- while **deploying**, we can deploy our service even when other teams'
  pipelines are blocked
- in **production**, our service can run even when other services have outages.
- during a **production incident**, we can debug our service without
  understanding other services

#### Splitting a monolith so you have isolated services

Those goals are nice, but practically speaking how do we keep our service
isolated throughout all the stages of the software development lifecycle? How do
we avoid the "half jump" that crashes us into a desk?

##### Extracting a single service from an existing monolith

Let's suppose we have a monolith and we want to extract a new, isolated service
from it. How do we start?

1. Create an independent team to be responsible for the new service. (This is
   an example of an [inverse Conway
   manoever](https://martinfowler.com/bliki/ConwaysLaw.html) where you start an
   architecture change with a team structure change.)
2. Pay attention to anything that prevents this new team from working
   independently -- where are they forced to coordinate with others?
3. Starting with the areas with the most coordination friction, make technical
   changes to separate the code and infrastructure needed by the new team. This
   could include:
     - moving code from the main code repository to a new one
     - creating a new deployment mechanism to deploy the code independently
     - separating production monitoring or other debugging tooling
     - creating an independent development environment so the new team can work
       on their code without running the rest of the monolith
     - other creative ideas from the team

#### Bottom line: iterate towards independence

The bottom line is this: if you work off of a list of "split the monolith"
steps, you're likely to half-do the split. You'll have a very independent
production environment but entangled development processes, or independent code
and deployment but a highly coupled design process, or there is a small shared
database that forces you to coordinate changes, or a shared config file, or some
other project specific source of coupling.

Instead of working from the list of standard "split the monolith" steps, work
from the goal: **can the new team design, develop, deploy, and operate their
service independent of other teams?  If not, what stops them?** Let that
question drive the ideation and triage of monolith splitting steps, and you will
"fully jump on the desk" -- you'll get the much-desired benefits of the
microservice architecture. Make a change, pay attention to the independence, and
then address the next biggest cause of interdependence.

#### Getting started: let the retrospectives drive the change

Geepaw Hill introduces the expression "Easiest Nearest Owwie First" in his [post
on tackling scary refactorings.](https://www.geepawhill.org/2019/03/03/refactoring-pro-tip-easiest-nearest-owwie-first/)

We apply "Easiest Nearest Owwie First" to break up big changes into small steps.
We look for something painful ("Owwie") that you happen to notice during your
work ("Nearest"), and that you can actually do something about ("Easiest").
That's what you start with, and after that you move on to the next Easiest
Nearest Owwie. In this way, a big architecture refactoring initiative turns into
a series of small steps:

1. "What did we notice this week that is keeping us from delivering independently?"
2. fix it
3. repeat

### Conclusion

When trying out new ideas, beware of our inclination to resist what's new, or to
focus on non-essential details. Instead, identify the key outcome and iterate
towards a point where you achieve that. You may make use of standard advice and
suggestions as you pursue the goal, but you may also invent something new. In
particular with microservices, that means that an independent service can be
built, tested, deployed, and operated without coordinating with other services.


---
  title: Motivation Engineering
  subtitle: Technical strategies for tackling overwhelming lists of compiler errors
  author: Alex Bird
  layout: post
---

During regular development, we try to work in small little chunks so if
something goes *very wrong* with our build step, we can undo our changes and all
is well again. Suppose you manually rename a function that is called hundreds of
times, but didn't rename all hundred usages. You run your build script, and it's
a wall of red. You scroll up to find the top, and it's endless red. You scroll
so far you wonder if you're seeing the output of the previous build, so you
clear your terminal window, and run again just to be sure. Yup, red red red.

As long as you had a git commit shortly before the rename, you can revert your
recent change and the build succeeds. Crisis averted.

But what if there is nothing to revert? For example, you've decided to change
your TypeScript compiler settings to enable `noImplicitAny` and there are
hundreds of failures because your code uses implicit any throughout. Or, you
want to upgrade major versions of a library or framework, and there are breaking
changes. You can't revert your way out of the wall of red build errors -- you
have to go through them.

It's like that kids song *Going On A Bear Hunt* where the group encounters all
kinds of unavoidable obstacles that they need to go right through.

![Going on a bear hunt book](/blog/assets/images/posts/2023/11/going-on-a-bear-hunt.jpg)

The trouble is, when I'm staring down a wall of errors of unknown length, my
biggest challenge has nothing to do with the "how to solve" part. It's not an
engineering problem, it's a morale problem. Whenever I work, there is some
background process in my mind that's checking if I'm going down a dead end.
Usually, that process is valuable because it keeps me from wasting time. In
cases like this, that process will make it nearly impossible for me to muster up
the motivation to tackle this list -- unless I can change the situation somehow.

### Staying motivated when working on walls of compiler errors

Visibility, visibility, visibility. The problem with the wall of errors is that
I have no idea how many there are. 50? 500? 500 000??

I can fix that by processing the build output to get a count of errors.

But even if I know that there are 500 errors, I know that I can't do 500 things
this afternoon. If I have to take one action for each error, this will take me
days and days. My "dead end detector" still warns me to give up. So, I group the
errors by type and identify the most frequently occurring. I'm looking for
errors I can fix in bulk. Maybe I can get some quick wins to prove to myself
this is not impossible.

### Example: extracting and upgrading some Angular code

In this post, I'll show some examples from some recent work I did in extracting
some Angular code from a complete web application to a separate reusable
library. After copying over the code to extract, there were many import
statements to correct, and some dependency issues.

### 1. Find a way to track progress

I could pick away at the hundreds of errors one at a time, but I would lose
heart. Eventually, my motivation would run out and I would slow or stop. Even if
it was mission critical to continue and I applied all my self discipline, I
would not have the vigor or creativity that comes from working with motivation.
Instead, I find a way to see my progress.

My first questions were:
 1. how many errors are there?
 2. are there many common errors, or are they all different?

I want the stderr output from `ng build` in a file so I can work with it:

```
ng build > todo.txt 2>&1
```

I chose the name `todo.txt` because this is the list of errors I need to address.

Now, let's generate some statistics. The output has hundreds of different
errors, for example:

```
✘ [ERROR] TS-991010: Value at position 4 in the NgModule.imports of ControllerStatusModule is not a reference
  Value could not be determined statically. [plugin angular-compiler]

    src/app/controller-home/controller-status/controller-status.module.ts:11:11:
      11 │   imports: [
         ╵            ^

  Unknown reference.

```

I've noticed that every build error from Angular has an error code which I could
use to check for frequently occurring errors. In a different ecosystem, I could
find some other way to group similar errors.

I filter for lines containing ERROR (`grep ERROR`), and delete everything after
the first colon (`sed "s/:.*//"`) . Then I count the frequency of each (`sort |
uniq -c | sort -n`). I append the results to my `todo.txt` to use as a kind of
table of contents.

```
cat todo.txt | grep ERROR | sed "s/:.*//" | sort | uniq -c | sort -n >> todo.txt
```

```

   1 ✘ [ERROR] TS2345
   1 ✘ [ERROR] TS2525
   1 ✘ [ERROR] TS2698
   1 ✘ [ERROR] TS2700
   1 ✘ [ERROR] TS2769
   3 ✘ [ERROR] NG5
   3 ✘ [ERROR] NG9
   4 ✘ [ERROR] TS2322
   4 ✘ [ERROR] TS2554
   5 ✘ [ERROR] NG2
   6 ✘ [ERROR] TS-996001
   6 ✘ [ERROR] TS-996003
   6 ✘ [ERROR] TS2339
   8 ✘ [ERROR] Can't find stylesheet to import.
   8 ✘ [ERROR] TS-996002
  10 ✘ [ERROR] TS18048
  13 ✘ [ERROR] TS2493
  22 ✘ [ERROR] TS-991010
  41 3. To allow any property add 'NO_ERRORS_SCHEMA' to the '@NgModule.schemas' of this component. [plugin angular-compiler]
  59 ✘ [ERROR] TS-992003
  66 ✘ [ERROR] NG8002
 109 ✘ [ERROR] NG8001
 146 ✘ [ERROR] NG8004
 267 ✘ [ERROR] TS2307
```

### 2. Find some quick wins

~500 errors is more than I have time to fix. I skim through the errors and see
that many of them relate to one component. I don't need that component, it just
happened to be in the folder that I copied over. I remove this superfluous
component and try again.

```

   1 ✘ [ERROR] NG5
   1 ✘ [ERROR] TS-996001
   1 ✘ [ERROR] TS-996003
   1 ✘ [ERROR] TS2769
   2 ✘ [ERROR] TS2322
   2 ✘ [ERROR] TS2493
   2 ✘ [ERROR] TS2554
   3 ✘ [ERROR] Can't find stylesheet to import.
   3 ✘ [ERROR] TS2339
   5 ✘ [ERROR] NG8001
   6 ✘ [ERROR] TS-991010
   7 3. To allow any property add 'NO_ERRORS_SCHEMA' to the '@NgModule.schemas' of this component. [plugin angular-compiler]
   7 ✘ [ERROR] NG8002
  11 ✘ [ERROR] TS-992003
  22 ✘ [ERROR] NG8004
  74 ✘ [ERROR] TS2307
```

Much better. I've taken one action and gone from ~500 down to ~100.

Next, I look for an error that I can fix with a search and replace. Let's start
with the 74 counts of TS2307. I filter my `todo.txt` to lines that match
`TS2307` and sort them so I can see some patterns. About half of the items begin
with `Cannot find module 'src/app/something'` and I recognize the three
different `something`s as code that I moved but the path changed. With three
global search and replaces, I swap the imports of `src/app/somethingX` for
`new/path/to/somethingX`, and rerun.

Now, the error output shows the following (I'll omit the errors that occur
fewer than 10 times for now, but they haven't disappeared in the output yet).

```

  12 ✘ [ERROR] NG8001
  15 ✘ [ERROR] NG8002
  19 ✘ [ERROR] NG8004
  36 ✘ [ERROR] TS2307
  58 ✘ [ERROR] NG9
```

Now TS2307 occurs 36 times (down from 74!), but I have new NG9s. I'll take a look at those.

The errors are all of type `Property '<some variable name>' does not exist on type
'unknown'` -- it looks like there are different compiler options in the project
I copied this code from. I don't like the idea of ignoring this error, but we
were ignoring it in the previous project and now is not the time to go clean up
59 files -- I'll look for a compiler option to disable that error... but I don't
find any after a few web searches. I need another approach, and I notice almost
all of these NG9 errors have an identical error message. I wonder if they're all
from the same file?

They are!! And what's better, they're on a file that I know I don't need, so I
delete it and some related files.

```

  13 ✘ [ERROR] NG8001
  17 ✘ [ERROR] NG8002
  19 ✘ [ERROR] NG8004
  42 ✘ [ERROR] TS2307
```

The `NG9`s are gone, but I have a few more `TS2307`s -- probably because some
files referenced the files I just deleted. When I look through those, I find 15
or so related to missing dependencies on the deleted files, and I fix those and
delete some more unneeded files.

Now, the full error report is:

```

   1 ✘ [ERROR] NG8001
   1 ✘ [ERROR] TS-996002
   2 ✘ [ERROR] TS-991010
   2 ✘ [ERROR] TS-992003
   2 ✘ [ERROR] TS2322
  24 ✘ [ERROR] TS2307
```

So far, I have taken 4 actions (delete unused; search and replace common missing
dependencies; delete unused; delete unused) and gone from ~500 errors to ~30.

At this point, I switch gears from "look for low hanging fruit" to "put my head
down and blast through the last short list".

### Aside: frequent git commits

Every time I take an action and rerun the build, I commit all my changes. That
way, I can take risks (broad search and replace or deleting 10s of files)
knowing that I can easily reset to a known state if the risk doesn't pan out.
I've heard this approach compared to a "ratchet" -- we take a small step
forward, and lock in so we don't go backwards. Then we take a small step
forward, and lock in again. This slow ratchet motion brings us steadily towards
the goal. It's the only way I could manage the stress of going through 500 build
errors.

### 3. Blast through the last short list

Whereas a sea of red compiler errors (500!) was overwhelming, 30 is much less
so. In a few quick strokes I eliminated 470, so I'm feeling motivated. I also
see that most of them are TS2307 (missing dependency), and I'm hopeful that I
can do some more search and replace to clear out those.

Starting with the most frequently occurring, I get to work. I filter `todo.txt`
by `TS2307` and sort alphabetically to look for patterns.

I take several actions:
 - four errors are from missing packages I can install from npm, so I do that
 - about 10 errors are from imports of deleted code that are safe for me
   to remove, so I remove those imports

```

   1 ✘ [ERROR] NG8001
   1 ✘ [ERROR] TS-996002
   2 ✘ [ERROR] TS-991010
   2 ✘ [ERROR] TS-992003
   2 ✘ [ERROR] TS2322
  10 ✘ [ERROR] TS2307
```

Now, I'm out of repeated errors that I can tackle in bulk, so I go through the
list one at a time to resolve issues, starting with the TS2307 errors because
they're familiar to me by now. As I resolve the errors, I delete them from
todo.txt to keep track of my progress. By the time I finish the ones I know how
to resolve, the build errors span only a few pages. I can scroll through them
from top to bottom without losing my place, which is far less daunting than
when I started!!

```

   1 ✘ [ERROR] NG4
   1 ✘ [ERROR] NG8001
   1 ✘ [ERROR] NG8002
   2 ✘ [ERROR] NG2
   3 ✘ [ERROR] TS-996002
```

So far, I have taken fewer than 30 actions and I have gone from ~500 errors to
eight. After some more work, it's down to one page:

```

   1 ✘ [ERROR] NG4
   1 ✘ [ERROR] NG8001
   2 ✘ [ERROR] NG2
```

At this point I can go back to the regular build process. I run the dev build
command that rebuilds automatically whenever I change files and use that quick
feedback to work through the final four errors.

### 4. Celebrate

```
Application bundle generation complete. [0.325 seconds]
  ➜  Local:   http://localhost:4200
```

Amazing!!! 

### Recap

When my "dead end detector" tells me to quit, before I give up, I look for ways
to get more visibility and progress tracking. Maybe it's not hopeless, it's just
unclear. We can unlock new technical frontiers by finding creative ways to make
chaotic work visible with progress markers.

Sometimes, we stop because of an insurmountable technical obstacle. Other times,
as the case might have been with this migration, we stop because we lose heart,
because we can't see the end or the path to get there.

### Closing Thoughts

So far, I've spoken of the impact of my internal "dead end detector".

Our strategic leaders -- the ones who approve the budget -- have a similar "dead
end detector". In fact, theirs is probably better tuned and more capable than
ours, since it's their job to make investment decisions on behalf of our
organization about what's worth attempting and what we should abandon.

If we can give visibility into our progress by linking our daily work to broad
goals, and if we can show steady progress by delivering in small increments,
then we increase our odds of getting funding. This type of transparent,
iterative work can increase our organizational courage, giving us the collective
boldness to tackle problems that -- at first glance -- look like an unscrollably
long list of errors.

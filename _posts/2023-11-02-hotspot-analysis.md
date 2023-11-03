---
  title: Hotspot Analysis
  subtitle: Finding the most maintenance-worthy code in the project
  author: Alex Bird
  layout: post
---

Have you ever owned an old car that's no longer worth keeping in good repair?
With a newer car, if there is a problem, you get it fixed. But when a car
reaches a certain age, there are some problems that aren't quite worth fixing.
For a car like that, as it falls into disrepair, it seems to collect quirks. It
starts out modestly, with one or two specific problems. Maybe it idles rough,
and the power locks on the passenger door don't work. As time goes on, your
mental model of the car shifts from "these 5 things are problematic" to a vague
sense of "this car is in rough shape". Suppose you wanted to get it running
really well -- where would you start?

Sometimes, a software system feels like that: we can tell that it needs some
maintenance, but there is not one or two specific problems -- it's more vague,
more systematic than that. For systems like that, once we have bandwidth to make
some improvements, we need a triage system.  How do we identify areas to
improve? There are some obvious tactical moves:
  - issues that impact current customers 
  - glaring technical issues like deprecated software, security gaps

But suppose we want to invest in the foundation of our system? Suppose we have
bandwidth to take some maintenance initiative. Where do we start?

### What parts of the code most need maintenance?

Maybe there are folks on the team who could answer this question without a
second thought. If you have a system that's small enough that one person can
have a mental model of the whole system in their head, then expert opinion
works. But what about systems that are too big for one person to fit in their
head?

#### Focus on files that change frequently

There is no point in improving a part of the code that never changes, no matter
how unmaintainable it is. We only need maintainability if we do maintenance on
the file.

Let's get a list of the top 100 most frequently changed files:
  1. list all the files that were added or modified in the last year
  2. for each file, count the number of git commits that modify the file (`git
     log --oneline` emits one line per commit, `wc -l` counts the lines)
  3. limit that list to the 100 files most frequently changed this year

```bash

git log --since "1 year ago" --diff-filter=MA --name-only --pretty="" |  sort -u | \
  xargs -L 1 -I FILE bash -c 'f() { echo "$(git log --since '"'1 year ago'"' --oneline -- $1 | wc -l) $1"; }; f FILE' \
  > files-by-commit-frequency.txt

cat files-by-commit-frequency.txt | sort -n | tail -n 100 | awk '{ print $2 }' > top-100-most-changed-files.txt
```

Now, `top-100-most-changed-files.txt` has a list of 100 file names, and
`files-by-commit-frequency.txt` has the number of commits for each file name.

Those 100 files are a good starting point for interesting or valuable files, but
it's still too long of a list. Let's narrow it down.

#### Narrow the list to files with maintainability concerns

Before you read more, answer this: would you rather make a change to a file with
50 lines of code, or one with 1500? You probably want to know more about the
files, but suppose all you know is the length -- which would you choose?

It would be even better to take a look at the files before making your decision
-- and if you're choosing between two files, looking at them is a great plan.
Now if you have hundreds or thousands of files and need to choose where to
start, how would you approximate maintainability?

Although there are lots of good metrics to give hints about code maintainability
(cyclomatic complexity, average function length, level of indentation, etc.),
file size is a great starting point. It would take a really messy 50loc file and
a really spectacular 1500loc file for the big one to be nicer to work with than
the small one. Let's start with lines of code. For alternatives, see the
*Further Reading* section below.

Let's get a list of the 100 longest files:
  1. list all the files that were added or modified in the last year
  2. for each file, count the number of lines with `wc -l`
  3. limit that list to the 100 files with the most lines

```bash

git log --since "1 year ago" --diff-filter=MA --name-only --pretty="" | sort -u | \
  xargs -L 1 -I % wc -l "%" | sort -n > files-by-size.txt

cat files-by-size.txt | sort -n | tail -n 100 | awk '{ print $2 }' > top-100-biggest-files.txt
```

Note: these commands don't bother filtering out files that no longer exist, so
there are some warnings while executing the command. You could get fancy and
filter those out before counting the lines, but the noise doesn't interfere with
the results.

After running those commands, `top-100-biggest-files.txt` has a list of 100 file
names, and `files-by-size.txt` has the number of lines for each file.

#### Find the most interesting files

Let's compare those lists: what are the files that are in the top 100 most
frequently changed, and the top 100 largest? Those are great candidates for
maintenance, since they are likely to be both hard to change and frequently
changed.

We concatenate the two `top-100-*` files, count how many times each line occurs,
and select only the lines which occur twice (that means they show up in both
lists).

```bash
cat top-100-* | sort | uniq -c | grep " 2 " | awk '{ print $2 }' > hotspots.txt
```

This is a list of hotspots. 

#### Hotspot Analysis

At this point, you could go and look at the files on that list. But, if you have
patience for one more step, you can get a nice table showing filename, commit
frequency, and size. Then you can sort, filter, and analyze.

In the appendix, there's an idea of how to combine the two sets of file
statistics in Excel. The short version: set up two sheets, one which maps file
names to commit count, and another that maps file name to file size. Then, in a
third sheet, show commit count and file size for each file so you can sort and
filter by the metrics.

If you wanted to include more dimensions, you could pull them into this analysis
also. See *Appendix* for details.

### Next Steps

At the start of this post, we knew nothing about the code repository. With a few
bash commands and some Excel work, we now have a short list of frequently
changed, potentially hard to maintain files. Now, we go and read those files,
read the commit history for those files, and look for opportunities to improve.

### Further Reading

The concepts in this post come from Adam Tornhill's book
[Software Design X-Rays: Fix Technical Debt with Behavioral Code Analysis](https://pragprog.com/titles/atevol/software-design-x-rays/).

Whereas this post deals only with change frequency and file size, Adam Tornhill
presents many dimensions and strategies for understanding a codebase. If you
found this post interesting, you're likely to find that book much more
interesting.

### Appendix: analyzing the data in Excel

- First sheet (called `ChangeFrequency`) has the contents of
  `files-by-commit-frequency.txt` -- the names in the first column and the
  counts in the second
- Second sheet (called `Size`) has the contents of
  `files-by-size.txt` -- the names in the first column and the
  counts in the second
- Third sheet has three columns:
   - A: hotspots (the contents of `hotspots.txt`)
   - B: commits last year: `VLOOKUP(A1, 'ChangeFrequency'!A:B, 2, FALSE)`
   - C: size: `VLOOKUP(A1, 'Size'!A:B, 2, FALSE)`

Now we can sort by change frequency and size, look for interesting files, and
start reading the code!

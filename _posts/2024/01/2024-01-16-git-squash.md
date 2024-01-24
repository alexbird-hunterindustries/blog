---
  title: Git Squash
  subtitle: How to combine multiple commits
  author: Luis Martinez, Kevin Vicencio, Alex Bird
  layout: post
---

## Context

We were rewriting ~30 lines of code, supported by tests. To do so, we disabled
the tests for that code and deleted the 30 lines of code (leaving an empty
method and a handful of disabled tests).  One test at a time, we enabled the
test and wrote the code to pass the test.  Then, we committed to git.

Since the code was technically broken at each commit (the disabled tests
represented missing behavior), we did not want to push our changes as-is.

When the rewrite was finished (and all tests were enabled and passing), we were
ready to think about pushing our code. Instead of pushing broken commits, we
chose to squash the commits into one single commit, review it as a single
commit, and then commit and push following our regular process.

This post describes the squash, in case we (or you) want to repeat it.

Here's out git log before we started the squash:
```

*       a65f9096b 👥 Our Team [3 hours ago] WIP - To Be Squashed
*       111b88098 👥 Our Team [3 hours ago] WIP - To Be Squashed
*       822f1598b 👥 Our Team [3 hours ago] WIP - To Be Squashed
*       df494ccbb 👥 Our Team [4 hours ago] WIP - To Be Squashed
*       537a4b4cc 👥 Our Team [4 hours ago] WIP - To Be Squashed
*       39abaa97e 👥 Our Team [4 hours ago] WIP - To Be Squashed
*       9a92a6ed0 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       f4a1d0f1a 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       bbee46810 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       397bba973 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       2f44cd9ec 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       e8b1b50d0 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       65ebc02ad 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       752ddf1b2 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       2318eaab4 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       4338ef173 👥 Our Team [5 hours ago] WIP - To Be Squashed
*       fbc7f8c03 👥 Our Team [23 hours ago] WIP - To Be Squashed
*       d67b88ce3 👥 Our Team [23 hours ago] WIP - To Be Squashed
*       b523773c1 👥 Our Team [23 hours ago] WIP - To Be Squashed
*       7b13cb1d8 👥 Our Team [23 hours ago] WIP - To Be Squashed
*       6d13d3801 👥 Our Team [23 hours ago] WIP - To Be Squashed
*       e4ccb2783 👥 Our Team [23 hours ago] WIP - To Be Squashed
*       b02247c9f 👥 Our Team [24 hours ago] WIP - To Be Squashed
*       5336a7275 👥 Our Team [24 hours ago] WIP - To Be Squashed
*       10f466ac5 👥 Our Team [24 hours ago] WIP - To Be Squashed
*       512201561 👥 Our Team [24 hours ago] WIP - To Be Squashed
*       13ddbb6c4 👥 Our Team [24 hours ago] WIP - To Be Squashed
*       2a5ab91a3 👥 Our Team [25 hours ago] R - Moved deprecated methods below non-deprecated methods.
*       2810574d5 👥 Our Team [28 hours ago] (origin/master, origin/HEAD) R- Encapsulate the foobar and the whatsit methods
*       9447c3891 👥 Our Team [28 hours ago] r - move all whizbang services into a new service subdirectory
*       c89f46071 👥 Our Team [28 hours ago] r - rename whizbang.models.ts to whizbang.ts
```

Interactive rebase back to the last clean commit: 
```

git rebase -i 2a5ab91a3
```

This opens up a new editor window:
```

pick 12ddbb2c4 WIP - To Be Squashed
pick 512201560 WIP - To Be Squashed
pick 9f42f6ac5 WIP - To Be Squashed
pick 5335a7271 WIP - To Be Squashed
pick b02246c5f WIP - To Be Squashed
pick e3ccb2779 WIP - To Be Squashed
pick 5d9db3801 WIP - To Be Squashed
pick 6b9ccb1d8 WIP - To Be Squashed
pick b523772c6 WIP - To Be Squashed
pick d66b84ce3 WIP - To Be Squashed
pick fbc6f4c03 WIP - To Be Squashed
pick 4337ef169 WIP - To Be Squashed
pick 2317eaab0 WIP - To Be Squashed
pick 751ddf6b2 WIP - To Be Squashed
pick 64ebc06ad WIP - To Be Squashed
pick e7b6b50d0 WIP - To Be Squashed
pick 1f40cd9ec WIP - To Be Squashed
pick 396bba969 WIP - To Be Squashed
pick bbee46809 WIP - To Be Squashed
pick f3a6d0f1a WIP - To Be Squashed
pick 8a88a6ed0 WIP - To Be Squashed
pick 38abaa93e WIP - To Be Squashed
pick 536a0b4cc WIP - To Be Squashed
pick df493ccbb WIP - To Be Squashed
pick 3d7c7549d WIP - To Be Squashed
pick 821f1594b WIP - To Be Squashed
pick 110b88094 WIP - To Be Squashed
pick a63f9092b WIP - To Be Squashed
pick f62d58425 WIP - To Be Squashed

# Rebase 2a5ab91a3..f62d58425 onto 2a5ab91a3 (29 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
#                    commit's log message, unless -C is used, in which case
#                    keep only this commit's message; -c is same as -C but
#                    opens the editor
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
#         create a merge commit using the original merge commit's
#         message (or the oneline, if no original merge commit was
#         specified); use -c <commit> to reword the commit message
# u, update-ref <ref> = track a placeholder for the <ref> to be updated
#                       to this position in the new commits. The <ref> is
#                       updated at the end of the rebase
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#

```

Next change the lines from "pick" to "squash" except for the first line - that one stays as pick as there needs 
to be a commit to squash to.

```

pick 12ddbb2c4 WIP - To Be Squashed
squash 512201560 WIP - To Be Squashed
squash 9f42f6ac5 WIP - To Be Squashed
squash 5335a7271 WIP - To Be Squashed
(etc.)
```

Then we save the file and git performs the rebase. (It shows `Rebasing (8/29)`.) Afterward, we're prompted to enter a new commit message, and we put
something temporary (we will update the commit shortly).

Then, our git log looks like this. Notice that master has a single commit on top
of the last clean commit. We left a "placeholder" branch at the end of our "wip"
commits so we could see the before and after. When we diffed `master` and
`placeholder`, they were identical, which told us the squash was successful: all
the same changes, but in a single commit instead of many.
```

*       b78d20d66 👥 Our Team [25 hours ago] (HEAD -> master) something temporary
| *     f62d58425 👥 Our Team [3 hours ago] (placeholder) WIP - To Be Squashed
| *     a63f9092b 👥 Our Team [3 hours ago] WIP - To Be Squashed
| *     110b88094 👥 Our Team [3 hours ago] WIP - To Be Squashed
| *     821f1594b 👥 Our Team [4 hours ago] WIP - To Be Squashed
| *     3d7c7549d 👥 Our Team [4 hours ago] WIP - To Be Squashed
| *     df493ccbb 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     536a0b4cc 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     38abaa93e 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     8a88a6ed0 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     f3a6d0f1a 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     bbee46809 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     396bba969 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     1f40cd9ec 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     e7b6b50d0 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     64ebc06ad 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     751ddf6b2 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     2317eaab0 👥 Our Team [5 hours ago] WIP - To Be Squashed
| *     4337ef169 👥 Our Team [6 hours ago] WIP - To Be Squashed
| *     fbc6f4c03 👥 Our Team [23 hours ago] WIP - To Be Squashed
| *     d66b84ce3 👥 Our Team [23 hours ago] WIP - To Be Squashed
| *     b523772c6 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     6b9ccb1d8 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     5d9db3801 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     e3ccb2779 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     b02246c5f 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     5335a7271 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     9f42f6ac5 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     512201560 👥 Our Team [24 hours ago] WIP - To Be Squashed
| *     12ddbb2c4 👥 Our Team [25 hours ago] WIP - To Be Squashed
|/
*       2a5ab91a3 👥 Our Team [25 hours ago] R - Moved deprecated methods below non-deprecated methods.
*       2810574d5 👥 Our Team [28 hours ago] (origin/master, origin/HEAD) R- Encapsulate the foobar and the whatsit methods
*       9447c3891 👥 Our Team [28 hours ago] r - move all whizbang services into a new service subdirectory
*       c89f46071 👥 Our Team [28 hours ago] r - rename whizbang.models.ts to whizbang.ts
```

Finally, we reset that commit so we could review the diff of all the squash and commit using our normal commit process.

```

git reset --soft HEAD^
```

Now we see a diff showing the combination of all of our WIP commits. 

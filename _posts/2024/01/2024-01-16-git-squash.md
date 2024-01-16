---
  title: Git Squash
  subtitle: How to combine multiple commits
  author: Luis Martinez, Kevin Vicencio, Alex Bird
  layout: post
---

## Context

We wanted to make many small changes which left our code in a broken state. After each little change we committed, but
we don't want to push those commits as-is because not all tests were passing. After a dozen or so changes, the code was
good again. We want one commit that has all our changes -- this is a good commit where the tests pass.

In the case that you want to consolidate many commits into one, you can follow these steps.

Here's out git log before we started the squash:
```
*       a63f9092b 👥 ACC2 Features [3 hours ago] WIP - To Be Squashed
*       110b88094 👥 ACC2 Features [3 hours ago] WIP - To Be Squashed
*       821f1594b 👥 ACC2 Features [3 hours ago] WIP - To Be Squashed
*       df493ccbb 👥 ACC2 Features [4 hours ago] WIP - To Be Squashed
*       536a0b4cc 👥 ACC2 Features [4 hours ago] WIP - To Be Squashed
*       38abaa93e 👥 ACC2 Features [4 hours ago] WIP - To Be Squashed
*       8a88a6ed0 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       f3a6d0f1a 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       bbee46809 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       396bba969 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       1f40cd9ec 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       e7b6b50d0 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       64ebc06ad 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       751ddf6b2 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       2317eaab0 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       4337ef169 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
*       fbc6f4c03 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
*       d66b84ce3 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
*       b523772c6 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
*       6b9ccb1d8 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
*       5d9db3801 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
*       e3ccb2779 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
*       b02246c5f 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
*       5335a7271 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
*       9f42f6ac5 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
*       512201560 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
*       12ddbb2c4 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
*       1a1ab91a3 👥 ACC2 Features [25 hours ago] R - Moved deprecated methods below non-deprecated methods.
*       2810573d1 👥 ACC2 Features [27 hours ago] (origin/master, origin/HEAD) R- Encapsulate conflict resolution snapshot program and name difference methods
*       9446c3887 👥 ACC2 Features [28 hours ago] r - move all conflict resolution services into a new service subdirectory
*       c88f46067 👥 ACC2 Features [28 hours ago] r - rename conflict-resolution.models.ts to conflict-resolution-snapshot.ts
```

Interactive rebase back to the last clean commit: 
```
git rebase -i 1a1ab91a3
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

# Rebase 1a1ab91a3..f62d58425 onto 1a1ab91a3 (29 commands)
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

Then, our git log looks like this:
```
*       b77d16d66 👥 ACC2 Features [25 hours ago] (HEAD -> master) something temporary
| *     f62d58425 👥 ACC2 Features [3 hours ago] (placeholder) WIP - To Be Squashed
| *     a63f9092b 👥 ACC2 Features [3 hours ago] WIP - To Be Squashed
| *     110b88094 👥 ACC2 Features [3 hours ago] WIP - To Be Squashed
| *     821f1594b 👥 ACC2 Features [4 hours ago] WIP - To Be Squashed
| *     3d7c7549d 👥 ACC2 Features [4 hours ago] WIP - To Be Squashed
| *     df493ccbb 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     536a0b4cc 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     38abaa93e 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     8a88a6ed0 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     f3a6d0f1a 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     bbee46809 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     396bba969 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     1f40cd9ec 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     e7b6b50d0 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     64ebc06ad 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     751ddf6b2 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     2317eaab0 👥 ACC2 Features [5 hours ago] WIP - To Be Squashed
| *     4337ef169 👥 ACC2 Features [6 hours ago] WIP - To Be Squashed
| *     fbc6f4c03 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
| *     d66b84ce3 👥 ACC2 Features [23 hours ago] WIP - To Be Squashed
| *     b523772c6 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     6b9ccb1d8 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     5d9db3801 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     e3ccb2779 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     b02246c5f 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     5335a7271 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     9f42f6ac5 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     512201560 👥 ACC2 Features [24 hours ago] WIP - To Be Squashed
| *     12ddbb2c4 👥 ACC2 Features [25 hours ago] WIP - To Be Squashed
|/
*       1a1ab91a3 👥 ACC2 Features [25 hours ago] R - Moved deprecated methods below non-deprecated methods.
*       2810573d1 👥 ACC2 Features [28 hours ago] (origin/master, origin/HEAD) R- Encapsulate conflict resolution snapshot program and name difference methods
*       9446c3887 👥 ACC2 Features [28 hours ago] r - move all conflict resolution services into a new service subdirectory
*       c88f46067 👥 ACC2 Features [28 hours ago] r - rename conflict-resolution.models.ts to conflict-resolution-snapshot.ts
```

Finally, we reset that commit so we could review the diff of all the squash and commit using our normal commit process.

```
git reset --soft HEAD^
```

Now we see a diff showing the combination of all of our WIP commits. 
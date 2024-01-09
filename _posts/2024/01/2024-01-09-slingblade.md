---
  title: Slingblade
  subtitle: When it's time to abandon your precious idea
  author: Alex Bird
  layout: post
---

In Pierce Brown's sci-fi novel *Red Rising*, there is a community of people
whose vocation is dangerous helium-3 mining deep inside Mars. There is
considerable risk of getting an arm or leg permanenly jammed in the mining
equipment, in which case they die. So, they each carry a "slingblade" -- a
scythe shaped knife they can use to cut off the trapped limb.

Uncle Nero says about the slingblade

> it will save your life for the cost of a limb

In software, sometimes we have good ideas that go bad. A clever refactoring, a
useful pattern, a tool to use or strategy to employ. As we act on the plan, we
hit more and more obstacles. Maybe the next change will make it work! It did,
but there is a new problem. Another web search. Another experiment. Another
small step forward -- but still the plan doesn't work. The more we invest in the
plan, the more emotionally attached we become to it. It feels like part of us.

Sometimes, that tenacity pays off -- we finaly get to the end of the weird
obstacles and voila! We have made something incredible.

Other times, the obstacles keep coming and minutes turn into hours turn into
days, and we can hardly remember why we started down this track.

In those cases, it's time for the slingblade. It will save our life for the cost
of a limb. We abandon our half-finished code, close all our browser tabs, take a
deep breath, and move on to whatever is our plan B.

### Full Git Reset

For cases like this, I have a git alias that clears out everything -- staged
changes, unstaged changes, and untracked files:

```
git reset --hard HEAD && git clean -f -d
```

Happy Coding! 

---
  title: Extend the Standard Libraries
  subtitle: Code with a language that's built for your business domain
  author: Alex Bird
  layout: post
---

The English Merriam Webster dictionary
[defines](https://www.merriam-webster.com/dictionary/joie%20de%20vivre) "joie de vivre" (a
French phrase) as "keen or buoyant enjoyment of life". Isn't it odd that we have no
English word for keen enjoyment of life? Whenever we express that idea in
English, we borrow the french phrase.

On the other hand, there were [690 words added](https://www.merriam-webster.com/wordplay/new-words-in-the-dictionary)
to the Merriam Webster dictionary in 2023, including *bussin'* ("extremely
good").

In the introduction to the list of new words for 2023, the Merriam Webster
editors say:

> Signs of a healthy language include words being created, words being borrowed
> from other languages, and new meanings being given to existing words. Based on
> our most recent research, we are pleased to inform you that English is very
> (very!) healthy.

Is our programming language healthy? Do we change the vocabulary to make it
easier to express our ideas?

### Background: standard libraries

Imagine a world with no
[`Math.floor`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/floor)
function in JavaScript. In a JavaScript application where we need to round down
to the closest integer value less than a number, we would end up with something
like this:

```javascript
const floor = number => Math.round(number - 0.5);
```

If we were writing an application that relied on this operation often, someone
would eventually say

> this is silly! Why doesn't JavaScript have `Math.floor`? I'm going to move
> this function to a new file that I'm naming `math.js` so that we can use it
> throughout our application.

Now, throughout our app we write `floor(number)` instead of `Math.round(number - 0.5)`.
Much better!

Fortunately, JavaScript *does* have `Math.floor` in the standard library because
it's common enough to be worth including. We regularly use many standard methods
that we *could* implement ourselves with lower level language constructs, but
our code is enhanced by not doing that. 

What happens when the common idea we use in our business *is not* included in a
standard library?

### An expressive proramming language for our business rules

When it comes to our business, we have all kinds of specific, nuanced words that
aren't defined in standard libraries. Let's use an example: suppose our business
sells clothing, and throughout our app we find ourselves converting between
waist sizes and the size names that we use in our company. We have the following
code in our app:

#### Validation
```javascript

if (size < 28 || size > 42) {
  /* handle unsupported size error */
}

```
```javascript

if (!sizeName.match(/(S|M|L|2?XL)/)) {
  /* handle unsupported size error */
}

```

#### Conversion
```javascript

let sizeName;
if (size > 27 && <= 30) {
  sizeName = 'S';
} else if (size > 30 && size <= 33) {
  sizeName = 'M';
} else if (size > 33 && size <= 36) {
  sizeName = 'L';
} else if (size > 36 && size <= 39) {
  sizeName = 'XL';
} else if (size > 39 && size <= 42) {
  sizeName = '2XL';
}

```

#### Additional rules
Also we offer more color options for the most common sizes, so we also have the
following throughout the code:

```javascript

if (size > 30 && size <= 36) {
  /* handle most popular sizes */
}

```
#### Generalize the example

If you think about code that you have maintained in the past months or years,
can you think of business rules that are mixed with other code and repeated?

Here are some symptoms of this pattern:
 - it is difficult to determine how the words of the feature request or bug
   report relate to the code that you're reading. You have to think hard to
   express the code in business terms and the business need in code terms.
 - you alias code in your mind (using a summary name instead of reading the
   code)
     - e.g. you read `size > 30 && size <= 36` as "size is popular"
 - **shotgun surgery**: you find yourself making a similar change in many places
   in your code. ([read more](https://refactoring.guru/smells/shotgun-surgery).)

#### A healthy language

There is no need to limit the code we author to standard vocabularly; we can
write our own language. I don't mean compilers and other low level hackery -- I
mean using simple language constructs to encode our vocabulary and all the
nuanced ideas it entails. Consider this small class. (I'm showing only the
interface for brevity; it would be a fun exercise for us to implement this.)

```javascript

interface PantSize {
    static fromWaistSize(size: number): PantSize;
    static fromSizeName(sizeName: string): PantSize;

    getSize(): number;
    getName(): string;
    isPopular(): boolean;
    isValid(): boolean;
}

```

Once we introduce this `PantSize` concept to our glossary, our code becomes more
expressive:

 - Validation: `if (!pantSize.isValid()) { /* handle unsupported size error */ }`
 - Conversion: `PantSize.fromSizeName(sizeName).getSize()`
 - Additional rules: `if (pantSize.isPopular()) { /* handle most popular sizes */ }`

### More than just DRY

This is similar to DRY (Don't Repeat Yourself), but unlike DRY it deals with
conversations and ideas, not just code. The DRY principle prompts us to say
"This code appears in multiple places. Let's extract it to a shared place and
give it a name."

Instead, I'm suggesting you should pay attention to the ideas and vocabulary
that we use often when discussing the software, and then put that language into
the code. Just like `Math.floor` encodes a common mathematical function for
general use, we can encode ideas that are common in our business.

With DRY, you'll know you're successful because you don't see duplication in
your code. With what I'm describing here, you'll know you're successful because
the code will use the same language as customers and product owners use.

### Putting this into action

When you have an insight about your business that is relevant to your code, put
that insight into the code (in a well named and well tested class) so that you
can benefit from the insight while coding.

1. **Listen** for words and ideas that you naturally use when talking about your
   software -- words related to your business domain and your customers' goals
2. **Encode** those words and ideas in your programming language
3. **Express** your system behaviour using those special terms you've captured.

### Further reading

If you want to learn more, here are some terms to search for and links to other
resources. I've split this into the **principle** and **practice** of what's
discussed in this post.

#### **Principle** of encoding your business language into your programming language

This post describes an aspect of **Domain Driven Design** (DDD). In DDD terms, the
work of developing a shared mental model expressed in a common language specific
to our business is called "domain modelling" and produces a "ubiquitous
language" which should be codified in our programming language and kept up to
date as our understanding evolves. There are patterns in DDD for understanding
this language that you might find helpful for structuring the business-code
language: entities, value objects, aggregates, etc. In
[Implementing Domain-Driven Design](https://www.oreilly.com/library/view/implementing-domain-driven-design/9780133039900/),
Vaugh Vernon describes this aspect of DDD as "tactical Domain Driven Design"
because it deals with individual steps for aligning code and business domain (in
contrast to the other strategic aspects of DDD).

#### **Practice** of extracting domain-specific code from the surrounding integrations

A common architectural pattern that emerges when applying DDD is **Hexagonal
Architecture** (ports and adapters), which emphasizes separating the valuable
business code (domain model) from the messy plumbing (framework integrations,
input/output, etc.). You can think of this as exactly your current architecture,
except the domain specific stuff is extracted into a core that has no direct
dependencies. It means the business rules are easy to test in isolation.

Resources about hexagonal architecture:
 - [Ready for changes with Hexagonal Architecture](https://netflixtechblog.com/ready-for-changes-with-hexagonal-architecture-b315ec967749) (from the Netflix Technology Blog)
 - Vaugh Vernon's *Implementing Domain-Driven Design*
For more on hex architecture, refer the the Vaugh Vernon book *Implementing
Domain-Driven Design*, this 
 - you'll also find lots through a web search for "hexagonal architecture" or
   "ports and adapters architecture"

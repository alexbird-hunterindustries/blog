# The Cannery - a Hunter Industries Software Department Blog

Published through GitHub pages at https://alexbird-hunterindustries.github.io/blog/

Notes about software development at [Hunter Industries](https://www.hunterindustries.com/).

## Contributing

Members of the Hunter Software Department are welcome to participate. In the
future, we might serve this under a different domain name or move this from GitHub
pages to our internal code repo/pipeline. For now, the process for contributing
is as follows:

1. Create a GitHub account with your Hunter email
2. Request access to this repo by sending a message to Alex
3. Commit some markdown using one of the two editing modes below

### GitHub editing

1. Through GitHub, browse to a recent post. You'll use this as an example for
   the format
2. In another tab, browse to the `_posts` folder and add a new file following
   the naming scheme: `yyyy-mm-dd-hyphen-separated-summary-of-your-post.md`
3. Add the front matter (title, subtitle, author, etc.) following the example in
   the other post you loaded
    - If it's a video link, include `type: video` in the front matter
    - If you used generative AI to produce some of the content, make sure you've
      reviewed it thoroughly and include `type: ai-assist` in the front matter. 
4. When you have finished editing, you can commit through the GitHub interface
   and wait for GitHub actions to publish

### Local Editing

1. [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/) >=
   2.5.0
2. Install dependencies `bundle install`
3. Run Jekyll `bundle exec jekyll serve`
4. Browse to `http://127.0.0.1:4000/blog/` to preview
5. Create your post as described in "GitHub Editing", except you can preview it
   locally before committing

## Review and Approval

- If you're adding a post, you can do that solo.
- If you're modifying site styles / layout, please involve the other recent
  contributors to the blog (`git shortlog -s --since "6 months ago"` will list
  recent contributors).

## Technical Notes

This blog is built with Jekyll (which uses Ruby) because that's the default for
GitHub pages. It seemed like a good option because it works out of the box and
integrates nicely with the deployment process and hosting for GitHub pages.

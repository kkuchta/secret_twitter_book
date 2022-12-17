# The Secret Corey Book Project

...because I'm too lazy to think of a good name.

This is the code behind a probably-soon-to-be-revealed gift for Corey Quinn, Cloud Economist and shitposter extrodinaire. Corey once tweeted:

# Dependencies:

- `brew install poppler`
  todo:
- Put tweets with images underneath image. The dates might line up - the floated tweets won't match the normal tweets, but that's ok. Randomize/alternate float direction

# Useful Commands

- `make`/`make build` does the whole build pipeline _except_ the slow process of turning the CSVs into the json cache (via hitting the twitter api)
- `make tweet_data` turns the CSVs into the json cache (takes a few days to run to completion when not cached)
- `make watch_css` will automatically copy over any changes from the CSS file - good for rapid css experimentation
  ` make html copy_css` with produce the html pages that you can open in a browser. Good for layout work.

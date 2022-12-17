# The Secret Corey Book Project

...because I'm too lazy to think of a good name.  Anyway, this is the code behind a probably-soon-to-be-revealed gift for Corey Quinn, Cloud Economist and shitposter extrodinaire, from his friends Kevin Kuchta, Helen Edwards, Mike Julian, and his wife Bethany Quinn (who is presumably also his friend).

The project produced a 5-volume leatherbound set of books containing all of Corey's tweets.  The code here is a mess of ruby, html, css, and some shell scripts mostly focused on turning a massive CSV of those tweets into a printable pdf.  This was a one-time project, so the code it's pretty awful.  If you want to attempt to run it, some notes on that are at the end.  But first, the story!

## Preamble
It all started when this tweet came across my timeline in 2021:

<img src="https://github.com/kkuchta/secret_twitter_book/blob/main/initial_tweet_image.png" width=400 />

My first thought was "I'll bet I could scrape twitter and figure out how many words he's actually tweeted," followed quickly by "hmm... you know, I could maybe make that into an *actual* book"!  What followed was this project.

## Timeline
The original plan was for this to be a gift for Corey's 31st birthday, which was coming up.  Mike Julian, a friend and Corey's partner in crime/business, egged me on.

1. Tried to pull all of Corey's historical tweets from the twitter api.  Failed - it won't give you more than a few thousand recent tweets.
2. Tried scraping twitter's web api.  Failed for reasons I don't recall.
3. Payed someone $15 on fiverr with access to twitter's corporate premium api to give me an XLS file (later converted to CSV) of all corey's tweets with IDs and contents.
4. Wrote [a little ruby script](https://github.com/kkuchta/secret_twitter_book/blob/main/build_tweet_data.rb) to go through the CSV and download additional information, plus images, for each tweet.  Why ruby?  It's one of my stronger languages and it's a little easier for things like file + string processing than JS or TS.
5. Wrote [a dumb little caching layer](https://github.com/kkuchta/secret_twitter_book/blob/main/cache.rb) because that script took several days to run.  It results in a big honkin' json file containing a bunch of info about each tweet, plus a big folder full of downloaded tweet images.
6. Set up a Makefile since it was clear this was going to be a multi-step build pipeline.
7. Start cleaning the data: removing retweets and striping out t.co links to media (since I was already downloading the media anyway)
8. Set up an [HTML template](https://github.com/kkuchta/secret_twitter_book/blob/main/book_template.html.erb) and another [little script](https://github.com/kkuchta/secret_twitter_book/blob/main/build_books.rb) to use that template to turn tweet data into an html file.  Also [some CSS](https://github.com/kkuchta/secret_twitter_book/blob/main/style.css).  I actually learned some new things about CSS directives that are meant for printing , like `  page-break-inside: avoid;`!
9. Iterate on the design.  A *lot*.  I *really* wanted to have tweets with images show up, but how do you handle that?  Having images just in the center of the page is kinda ugly - let's float the images.  Floating everything left looks weird - let's alternate floating left and right.  What happens when a tweet has 3+ images?  What happens when there are a bunch of image-heavy tweets in a row?  How do you keep floated images close to the tweet they're associated with?  You can float both the images *and* their associated tweets, but then these image tweets really out of order relative to the rest of the tweets in the chapter.  And remember: we're going to be paying by the page, so space is valuable!  I eventually settled for floating images combined with their matching tweets, but spreading them out throughout the chapter and piling up extra images at the end in a semi-grid.  Here's [a representative chapter](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/book_16_11.pdf).
10. Convert the HTML+CSS to PDF.  Should be easy, right?  Just run it through wkhtmltopdf!  Ah, what a sweet summer child I was.  It turns out that every html->pdf converter I could find struggled mightly with any non-trivial CSS.  I eventually decided to say "screw it" and just use an actual browser.  Thankfully, chrome has a headless mode and a "print to pdf" CLI option that [I used extensively](https://github.com/kkuchta/secret_twitter_book/blob/main/html_to_pdf.sh).  However, as it turns out, people don't generally use chrome headless pdf printing to print 1GB+ PDFs.  I spent a few months trying to get it to print out the PDF for an entire Corey book.  I'd decided by this point to split the whole thing by year into 5 volumes (2016-2018, 2019, 2020, 2021, 2022), but the bigger years would repeatedly crash Chrome headless.  Eventually my clever fiance, Helen, suggested that I just generate each *chapter* as its own PDF, then [combine them afterwards](https://github.com/kkuchta/secret_twitter_book/blob/main/compare_tweets.rb)!  I did that, and it all worked - woo!
11. Fastforward about year.  In that year, I iterated on the design a lot, but mostly I procrastinated because I wasn't happy with the design yet and I was putting off figuring out the actual printing.  After finally getting a design that I was ok with, I decided I needed cover pages!  I referenced a few books off my shelf and came [up](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_0_book_1.pdf) [with](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_1_book_1.pdf) [some](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_2_book_1.pdf) [cover](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_3_book_1.pdf) [pages](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_4_book_1.pdf).  They were built using the same [html](https://github.com/kkuchta/secret_twitter_book/blob/main/cover_page_2.html.erb) to [pdf](https://github.com/kkuchta/secret_twitter_book/blob/main/build_cover_pdf.sh) strategy.


# Dependencies:

- `brew install poppler`
  todo:
- Put tweets with images underneath image. The dates might line up - the floated tweets won't match the normal tweets, but that's ok. Randomize/alternate float direction

# Useful Commands

- `make`/`make build` does the whole build pipeline _except_ the slow process of turning the CSVs into the json cache (via hitting the twitter api)
- `make tweet_data` turns the CSVs into the json cache (takes a few days to run to completion when not cached)
- `make watch_css` will automatically copy over any changes from the CSS file - good for rapid css experimentation
  ` make html copy_css` with produce the html pages that you can open in a browser. Good for layout work.

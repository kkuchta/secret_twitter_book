![Flj_418aEAE-t2T](https://user-images.githubusercontent.com/820965/227816051-99b7f23a-6f5e-4e2b-89b2-f778017fac37.jpg)


# The Secret Corey Book Project

...because I'm too lazy to think of a good name.  Anyway, this is the code behind a probably-soon-to-be-revealed gift for Corey Quinn, Cloud Economist and shitposter extrodinaire, from his friends Kevin Kuchta, Helen Edwards, Mike Julian, and his wife Bethany Quinn (who is presumably also his friend).

The project produced a 5-volume leatherbound set of books containing all of Corey's tweets.  The code here is a mess of ruby, html, css, and some shell scripts mostly focused on turning a massive CSV of those tweets into a printable pdf.  This was a one-time project, so the code it's pretty awful.  If you want to attempt to run it, some notes on that are at the end.  But first, the story!

Update: if you'd like to skip to Corey's reaction, [you may do so here](https://twitter.com/QuinnyPig/status/1610317856876683264)!

## Preamble
It all started when this tweet came across my timeline in 2021:

<img src="https://github.com/kkuchta/secret_twitter_book/blob/main/initial_tweet_image.png" width=400 />

My first thought was "I'll bet I could scrape twitter and figure out how many words he's actually tweeted," followed quickly by "hmm... you know, I could maybe make that into an *actual* book"!  What followed was this project.

## Timeline
The original plan was for this to be a gift for Corey's 39th birthday, which was coming up.  Mike Julian, a friend and Corey's partner in crime/business, egged me on.

1. Tried to pull all of Corey's historical tweets from the twitter api.  Failed - it won't give you more than a few thousand recent tweets.
2. Tried scraping twitter's web api.  Failed for reasons I don't recall.
3. Payed someone $15 on fiverr with access to twitter's corporate premium api to give me an XLS file (later converted to CSV) of all corey's tweets with IDs and contents.
4. Wrote [a little ruby script](https://github.com/kkuchta/secret_twitter_book/blob/main/build_tweet_data.rb) to go through the CSV and download additional information, plus images, for each tweet.  Why ruby?  It's one of my stronger languages and it's a little easier for things like file + string processing than JS or TS.  It turns out that "making a neat gift" is not sufficient justification for twitter to approve a new api key, but I had an old one lying around from [an older project](https://github.com/kkuchta/lyric_bot).
5. Wrote [a dumb little caching layer](https://github.com/kkuchta/secret_twitter_book/blob/main/cache.rb) because that script took several days to run.  It results in a big honkin' json file containing a bunch of info about each tweet, plus a big folder full of downloaded tweet images.
6. Set up a Makefile since it was clear this was going to be a multi-step build pipeline.
7. Start cleaning the data: removing retweets and striping out t.co links to media (since I was already downloading the media anyway)
8. Set up an [HTML template](https://github.com/kkuchta/secret_twitter_book/blob/main/book_template.html.erb) and another [little script](https://github.com/kkuchta/secret_twitter_book/blob/main/build_books.rb) to use that template to turn tweet data into an html file.  Also [some CSS](https://github.com/kkuchta/secret_twitter_book/blob/main/style.css).  I actually learned some new things about CSS directives that are meant for printing , like `  page-break-inside: avoid;`!
9. Iterate on the design.  A *lot*.  I *really* wanted to have tweets with images show up, but how do you handle that?  Having images just in the center of the page is kinda ugly - let's float the images.  Floating everything left looks weird - let's alternate floating left and right.  What happens when a tweet has 3+ images?  What happens when there are a bunch of image-heavy tweets in a row?  How do you keep floated images close to the tweet they're associated with?  You can float both the images *and* their associated tweets, but then these image tweets really out of order relative to the rest of the tweets in the chapter.  And remember: we're going to be paying by the page, so space is valuable!  I eventually settled for floating images combined with their matching tweets, but spreading them out throughout the chapter and piling up extra images at the end in a semi-grid.  Here's [a representative chapter](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/book_16_11.pdf).
10. Convert the HTML+CSS to PDF.  Should be easy, right?  Just run it through wkhtmltopdf!  Ah, what a sweet summer child I was.  It turns out that every html->pdf converter I could find struggled mightly with any non-trivial CSS.  I eventually decided to say "screw it" and just use an actual browser.  Thankfully, chrome has a headless mode and a "print to pdf" CLI option that [I used extensively](https://github.com/kkuchta/secret_twitter_book/blob/main/html_to_pdf.sh).  However, as it turns out, people don't generally use chrome headless pdf printing to print 1GB+ PDFs.  I spent a few months trying to get it to print out the PDF for an entire Corey book.  I'd decided by this point to split the whole thing by year into 5 volumes (2016-2018, 2019, 2020, 2021, 2022), but the bigger years would repeatedly crash Chrome headless.  Eventually my clever fiance, Helen, suggested that I just generate each *chapter* as its own PDF, then [combine them afterwards](https://github.com/kkuchta/secret_twitter_book/blob/main/compare_tweets.rb)!  I did that, and it all worked - woo!
11. Fastforward about year.  In that year, I iterated on the design a lot, but mostly I procrastinated because I wasn't happy with the design yet and I was putting off figuring out the actual printing.  After finally getting a design that I was ok with, I decided I needed cover pages!  I referenced a few books off my shelf and came [up](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_0_book_1.pdf) [with](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_1_book_1.pdf) [some](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_2_book_1.pdf) [cover](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_3_book_1.pdf) [pages](https://github.com/kkuchta/secret_twitter_book/blob/main/sample/cover_page_4_book_1.pdf).  They were built using the same [html](https://github.com/kkuchta/secret_twitter_book/blob/main/cover_page_2.html.erb) to [pdf](https://github.com/kkuchta/secret_twitter_book/blob/main/build_cover_pdf.sh) strategy.
12. At this point Corey's 39th birthday had come and gone, but hey, now it was almost time for his 40th!  Time to buy another data dump from a new random person on the internet.  I [compare the data](https://github.com/kkuchta/secret_twitter_book/blob/main/compare_tweets.rb) against the original dump and find a *few* discrapancies, but not too many.  I [normalize](https://github.com/kkuchta/secret_twitter_book/blob/main/normalize_updated_tweets.rb) the CSV so it matches the format of the original data dump, plug it into the existing pipeline, and we're off the the races!
13. And the technical work is done!  Now all that remains is to send it off to [the bindery](https://www.grimmbindery.com/).  I was hoping to get a little more advice from them on what the book *should* look like, but they mostly needed me to dictate all the minutae of fonts, leather types, and stamping patterns. Ultimately, though, they did great work and the books came out looking amazing!  I would definitely recommend them.

# How to run this
Honestly, I barely remember how to run this myself.  I didn't write this code for much maintainability - I wrote it to fit in my head once, get run, and then be done.  That said, here are some notes for anyone trying to make it work:

- The `Makefile` is the starting point.  Run `make tweet_data` to turn the CSVs of tweet data into a nice JSON dump.  That'll take several days to run, but it'll cache partial progress.  It's a lot faster when fully cached.
- `make` will run the rest of the steps starting after getting the json dump of tweet data.  This takes about an hour.  The various substeps are available via make as well (eg `make html`).
- `make watch_css` will watch the style.css file and copy it out the /out folder whenever it changes.  Handy when you're iterating on that file.

## Dependencies
- You'll need ruby.  I used 3.0, but 2.7 might work.  `bundle install` as-needed.
- You'll need Chrome installed.  Update the path to Chrome in html_to_pdf.sh to reflect wherever it's installed on your system.  It's used for generating pdfs from html+css files.
- We use Poppler (`brew install poppler`) to combine pdfs
- You'll need twitter api credentials.  Check out build_tweet_data.rb for the keys needed, then set up a `.env` file with those keys.


## Misc
- There's also a script called `word_analysis.rb` that finds the most common strings of N words in Corey's tweets.  The results are not as interesting as you might think - the most common 6-word phrases are promotion for his various media (eg `*AND* AWS news in the same`), but there are some fun ones.  Did you know that corey said `Do I know anyone who works` 19 times in the last 8 years, and `This is relevant to my interests` 25 times?  :)

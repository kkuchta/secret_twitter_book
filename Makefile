build: html cover_page_html copy_css cover_pdfs month_pdfs book_pdfs
# 	echo 'done'

# Don't include this one by default because it's slow.
tweet_data:
	ruby build_tweet_data.rb
# build_html:
# 	ruby build_html.rb
# Depends on tweet_data
html:
	ruby build_books.rb

cover_page_html:
	ruby cover_page_html.rb

copy_css:
	cp style.css out/style.css

cover_pdfs:
	bash ./build_cover_pdfs.sh

month_pdfs:
	bash ./build_pdfs.sh

book_pdfs:
	ruby combine_pdfs.rb

watch_css:
	watchman-make -p style.css -t copy_css

compare_tweets:
	ruby compare_tweets.rb

normalize_updated_tweets:
	ruby normalize_updated_tweets.rb
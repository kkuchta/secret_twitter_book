build: build_html copy_css build_pdf
	echo 'done'

build_html:
	ruby build_html.rb

copy_css:
	cp style.css out/style.css

build_pdf:
	/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
	--headless \
	--print-to-pdf=./out/final.pdf \
	--print-to-pdf-no-header \
	./out/final.html
# build_pdf:
# 	ulimit -n 65536 && wkhtmltopdf --enable-local-file-access --encoding utf-8 ./out/final.html out/final.pdf

# clean:
# 	rm -r out/*
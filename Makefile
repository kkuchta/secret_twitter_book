build: build_html build_pdf
	echo 'done'

build_html:
	ruby build_html.rb
	cp style.css out/style.css

build_pdf:
	wkhtmltopdf --enable-local-file-access --encoding utf-8 ./out/final.html out/final.pdf

clean:
	rm -r out/*
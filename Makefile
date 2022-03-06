build: build_html build_pdf
	echo 'done'

build_html:
	ruby build_html.rb

build_pdf:
	wkhtmltopdf --enable-local-file-access ./out/final.html out/final.pdf

clean:
	rm -r out/*
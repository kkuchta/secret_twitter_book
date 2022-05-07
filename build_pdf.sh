echo "--- Building book ${BOOK_NUMBER} --- "
ulimit -n 65536  && /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
--headless \
--print-to-pdf=./out/book_${BOOK_NUMBER}.pdf \
--print-to-pdf-no-header \
--use-fake-ui-for-media-stream \
./out/book_${BOOK_NUMBER}.html 2>&1 
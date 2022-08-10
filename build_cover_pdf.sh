HTML_FILE=$1

echo "Building ${HTML_FILE} to pdf"
FRAGMENT=$(echo "$HTML_FILE" | grep -o 'cover_page_\d_book_\d')
sh html_to_pdf.sh $HTML_FILE ./out/${FRAGMENT}.pdf
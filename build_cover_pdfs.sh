echo "Building cover pdfs"
find -E out \
  -regex '.*/cover_page_.*\.html' \
  -exec sh build_cover_pdf.sh {} \;
  # Need to include the outfile here...
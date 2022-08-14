# !/bin/bash
# for i in {0..62}
# do
#   BOOK_NUMBER=$i bash ./build_pdf.sh
# done

echo "Building single-month pdfs"
find -s -E out \
  -regex '.*/book_.*\.html' \
  -exec sh build_pdf.sh {} \;
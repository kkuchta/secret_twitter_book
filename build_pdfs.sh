#!/bin/bash
for i in {0..3}
do
  BOOK_NUMBER=$i bash ./build_pdf.sh
done
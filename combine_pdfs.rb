require 'pry-byebug'
puts "Combining pdfs"

# filename, year, month
pdf_filenames = Dir.new('./out')
  .each_child
  .select {|filename| filename =~ /book_\d\d_\d\d\.pdf/ }
  .sort
  .map { _1.match(/book_(\d\d)_(\d\d)\.pdf/).to_a }

groupings = []
pdf_filenames.each do |filename, year, month|
  i = case year.to_i
    when 16..18 then 0
    when 19 then 1
    when 20 then 2
    when 21 then 3
    when 22 then 4
    else raise "bad year #{year.to_i}"
  end
  groupings[i] ||= []
  groupings[i] << filename
end
groupings.each_with_index do |grouping, i|
  output_name = "./out/combined_book_#{i}.pdf"
  files_string = grouping.map{"./out/#{_1}"}.join(' ')
  puts "Building #{output_name} from #{files_string}"
  `pdfunite #{files_string} #{output_name}`
end

puts "done"
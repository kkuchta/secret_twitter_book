require 'erb'
require 'pry-byebug'
puts "Building cover pages"

book_data = [ 
  {date_range_string: '2016-2018'},
  {date_range_string: '2019'},
  {date_range_string: '2020'},
  {date_range_string: '2021'},
  {date_range_string: '2022'},
]

def render_to_html(erb_filename, book_index, data)
  puts "  rendering #{erb_filename}"
  out_filename = erb_filename.sub('.html.erb', "_book_#{book_index}.html")
  erb = ERB.new(File.read(erb_filename))

  # Too lazy for a proper converter
  book_roman_numeral =
  case book_index
    when 0
      'i'
    when 1
      'ii'
    when 2
      'iii'
    when 3
      'iv'
    when 4
      'v'
    when 5
      'vi'
    end

  result = erb.result_with_hash(data.merge(
    book_index: book_index,
    book_roman_numeral: book_roman_numeral
  ))
  File.write('./out/' + out_filename, result)
end

book_data.each_with_index do |book_data, book_index|
  puts "Building cover pages for book #{book_index}..."
  render_to_html('cover_page_0.html.erb', book_index, book_data)
  render_to_html('cover_page_1.html.erb', book_index, book_data)
  render_to_html('cover_page_2.html.erb', book_index, book_data)
  render_to_html('cover_page_3.html.erb', book_index, book_data)
  render_to_html('cover_page_4.html.erb', book_index, book_data)
  render_to_html('cover_page_5.html.erb', book_index, book_data)
end
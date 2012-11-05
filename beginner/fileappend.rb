require_relative 'fileopen'

File.open("../experiment/text_written.txt", "a") do |f|
  f.puts "new entry"
  f.puts Time.now
  f.puts $aa
  f.puts
end

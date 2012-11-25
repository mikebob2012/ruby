require 'rubygems'
require 'ruby-tmdb3'
require '/Users/bbelderbos/Documents/key.rb' # sets $apikey variable 
Tmdb.api_key = $apikey
Tmdb.default_language = "en"

# cli args 
abort("Please provide a movie string to search for") if ARGV.empty? 
searchTerm = ARGV.join(' ')

# query tmdb
moviesFound = []
@movie = TmdbMovie.find(:title => searchTerm, :limit => 10, :expand_results => false )
@movie.each do |movie|
  moviesFound << { :id => movie.id, :title => movie.title, :released => movie.release_date, }
end

# show results
moviesFound.each_with_index do|movie, i|
  puts "#{i+1}) #{movie[:title]} (#{movie[:released]})"
end

# ask what movie to show
choice = ''
loop do
  puts "Which movie you want to check out? ( 1-10 , q to abort)\n"
  choice = $stdin.gets.chomp # bit.ly/pcHDYJ
  abort("Pressed q, so aborting ...")   if choice.match(/q|Q/)
  break                                 if (1..10).to_a.include? choice.to_i 
end

# open browser window, for now on mac, to be extended to support other OSs, maybe lynx as well? 
index = choice.to_i-1
url = "http://sharemovi.es/movie/#{moviesFound[index][:id]}-#{moviesFound[index][:title].downcase.gsub(' ', '-')}"
system("open #{url}")

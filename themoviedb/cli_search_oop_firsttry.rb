class FindMovie
  def initialize(apikey, search)
    @apikey=apikey
    @search=search
  end

  def search
    query()
    show()
    choose()
    open()
  end

  # query tmdb
  def query
    require 'rubygems'
    require 'ruby-tmdb3'
    Tmdb.api_key = @apikey
    Tmdb.default_language = "en"
    @moviesFound = []
    @movie = TmdbMovie.find(:title => @search, :limit => 10, :expand_results => false )
    @movie.each do |movie|
      @moviesFound << { :id => movie.id, :title => movie.title, :released => movie.release_date, }
    end
  end

  # show results
  def show
    @moviesFound.each_with_index do|movie, i|
      puts "#{i+1}) #{movie[:title]} (#{movie[:released]})"
    end
  end

  # ask what movie to show
  def choose
    @choice = ''
    loop do
      puts "Which movie you want to check out? ( 1-10 , q to abort)\n"
      @choice = $stdin.gets.chomp # bit.ly/pcHDYJ
      abort("Pressed q, so aborting ...")   if @choice.match(/q|Q/)
      break                                 if (1..10).to_a.include? @choice.to_i 
    end
  end

  # open browser window, for now on mac, to be extended to support other OSs, maybe lynx as well? 
  def open
    @index = @choice.to_i-1
    @url = "http://sharemovi.es/movie/#{@moviesFound[@index][:id]}-#{@moviesFound[@index][:title].downcase.gsub(' ', '-')}"
    system("open #{@url}")
  end

end



# cli args 
abort("Please provide a movie string to search for") if ARGV.empty? 
searchTerm = ARGV.join(' ')

require '/Users/bbelderbos/Documents/key.rb' # sets $apikey variable 
movie = FindMovie.new($apikey, searchTerm)
movie.search()

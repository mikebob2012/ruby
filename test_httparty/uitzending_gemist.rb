require 'rubygems'
require 'httparty'
require 'pp'
#require 'JSON'

module UitzendingGemist
  #= RtlGemist Api Documentation
  #
  #== This is a heading
  #
  #
  class Api
    include HTTParty
    base_uri 'http://iphone-api.uitzendinggemist.nl'
    http_proxy '10.10.10.54', 8888
    #default_params :output => 'json'
    format :json
    headers 'Accept' => '*/*'
    headers 'Connection' => 'keep-alive'
    headers 'Content-Type' => 'application/json; charset=utf-8'
    headers 'Accept-Encoding' => 'gzip'
    headers 'User-Agent' => 'NPOxUG/2.1 OS/6.0.1 iPhone4,1'

    def initialize(token=nil)
    end

    def get_tips()
      if(@local_tips==nil)
        @local_tips = self.class.get("/v1/episodes/tips.json", :body => {})
      end
      @local_tips
    end

    def get_tip(id)
      get_tips().detect { |e| e["position"] == id }
    end

  end
end

#Global Var: Reference to UitzendingGemistApi
$api = UitzendingGemist::Api.new

def show_tips()
  $api.get_tips().each do |o| 
    show_tip_short(o)
  end
  print "\n"
end

def show_tip_short(o)
  print "#{o["position"]}. "
  print "#{o["title"]} "
  print "#{o["episode"]["title"]} (#{o["episode"]["broadcasters"].join(",")})\n"
end

def show_tip_full(o)

  episode = o["episode"]
  tijdstip = Time.at( episode["date_posix"]) 
  duur = episode["duration"].to_int() / 60

  print "\n-------------\n"
  print "#{o["title"]}\n"
  print "#{episode["title"]} (#{episode["broadcasters"].join(",")})\n"
  print "\n"

  print "Uitgezonden:\t#{tijdstip.strftime("%a %d %b")} - #{duur} min.\n"
  print "Omschrijving:\t#{o["description"]}\n"
  print "\n"
  print "Meer over #{episode["title"]}\n"
  print "Genre: \t\t#{episode["genres"].join(", ")}\n"
  print "Omschrijving: \t#{episode["description"]}\n"
  print "\n"
end

def get_tip_by_id(id)
  $api.get_tip(id)
end


input = nil
show_tips()

while true
  
  print "Enter Your Magic Number? "
  input = gets.chomp

  if (input =~ /^[-+]?[0-9]+$/)
    item = get_tip_by_id(Integer(input))
    show_tip_full(item) unless item==nil
  else
    show_tips() if input==""
    break if ["q","quit"].any? { |e| e == input  } 
  end


end


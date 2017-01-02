#!/usr/bin/env ruby
# Daniel Ethridge

require 'uri'
require 'open-uri'
require 'json'
require 'yaml'
require 'io/console'

module Wik
  # Do a get request and, by default, return the response as parsed json
  def get(endpoint, parse=true)
    ua = "Wik-RubyGem (https://github.com/wlib/wik; danielethridge@icloud.com) Command Line Wikipedia"
    body = open(endpoint, "User-Agent" => ua).read
    if parse
      return JSON.parse(body)
    else
      return body
    end
  end

  # Do a search by phrase, returns a hash with full search data, but first prints the parsed search data
  def find(phrase, limit=15, snippet=false, display=true)
    search = phrase.sub( " ", "_" )
    if snippet
      endpoint = "https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=#{search}&srlimit=#{limit}"
    else
      endpoint = "https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=#{search}&srlimit=#{limit}&srprop"
    end
    hash = get(endpoint)
    info = hash["query"]["searchinfo"]
    results = hash["query"]["search"]
    if display
      puts "Total hits : #{ info["totalhits"] }"
      if info["suggestion"]
        puts "Suggestion : #{ info["suggestion"] }"
      end
      puts "Displaying #{results.length} results:"
      results.each do |result|
        # https://stackoverflow.com/a/1732454
        if snippet
          snip = result["snippet"].gsub( /<.*?>/, "" ).gsub( /&\w+;/, "" ).split.join(" ")
          puts "\n'#{result["title"]}' : #{snip}..."
        else
          puts "\n'#{result["title"]}'"
        end
      end
    end
    return hash
  end

  # Open Search is a different way to search Wikipedia
  # It returns descriptions automatically and has a more consistent typo-correct
  def search(phrase, limit=5, description=true, display=true)
    search = phrase.sub( " ", "_" )
    endpoint = "https://en.wikipedia.org/w/api.php?action=opensearch&format=json&search=#{search}&limit=#{limit}"
    hash = get(endpoint)
    results = hash[1]
    descriptions = hash[2]
    if display
      puts "Displaying #{results.length} results:"
      for i in 0...results.length
        if description
          if ! descriptions[i].empty?
            puts "\n'#{results[i]}' : #{descriptions[i]}"
          else
            puts "\n'#{results[i]}' : No Immediate Description Available. Try `wik -d #{results[i]}`"
          end
        else
          puts "\n'#{results[i]}'"
        end
      end
    end
    return hash
  end

  # Get info for titles
  def info(titles=nil, ids=nil, display=true)
    if titles
      if titles.is_a?(Array)
        encoded = titles.join("|").sub( " ", "_" )
      elsif titles.is_a?(String)
        encoded = titles
      else
        puts "Titles should be a string or array"
        return false
      end
      endpoint = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=info&inprop=url&titles=#{encoded}&redirects"
    elsif ids
      if ids.is_a?(Array)
        encoded = ids.join("|").sub( " ", "_" )
      elsif ids.is_a?(String)
        encoded = ids
      else
        puts "ID's should be a string or array"
        return false
      end
      endpoint = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=info&inprop=url&pageids=#{encoded}&redirects"
    end
    hash = get(endpoint)
    pages = hash["query"]["pages"]
    redirects = hash["query"]["redirects"]
    if display
      if redirects
        redirects.each do |redirect|
          puts "Redirected from '#{redirect["from"]}' to '#{redirect["to"]}'"
        end
      end
      pages.keys.each do |id|
        page = pages[id]
        if page["missing"]
          puts "The page '#{page["title"]}' is missing"
        else
          puts "The page '#{page["title"]}' has the ID: #{page["pageid"]}, and is written in #{page["pagelanguage"]}"
        end
      end
    end
    return hash
  end

  # Get the entire page of an entry
  def view(title=nil, id=nil)
    if title
      endpoint = "https://en.wikipedia.org/w/api.php?action=parse&format=json&prop=wikitext&page=#{title}&redirects"
    elsif id
      endpoint = "https://en.wikipedia.org/w/api.php?action=parse&format=json&prop=wikitext&pageid=#{id}"
    end
    hash = get(endpoint)
    content = hash["parse"]["wikitext"].to_s.gsub( '\n', "\n" )
    system "echo #{content} | less"
  end

  # Just give a description of an entry
  def describe(title=nil, id=nil)

  end

  # Automatically handle the process of searching, redirecting, and viewing
  def handle()
  end
end
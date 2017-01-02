# Wik's Ruby API

## Getting Started

### Install
Getting started is simple, first install the gem:

+ `sudo gem install wik`

### Trying it out
Now that we have Wik installed, lets play around with it in `irb`:

```
daniel@pancake:~/wik$ irb
irb(main):001:0> require "wik" # Get the modules from the wik gem
=> true
irb(main):002:0> include Wik # Load in the module "Wik"
=> Object
irb(main):003:0> find("api", 2) # Query Wikipedia for the first two results under "api"
Total hits : 11280
Displaying 2 results:

'Application programming interface'

'API gravity'
=> {"batchcomplete"=>"", "continue"=>{"sroffset"=>2, "continue"=>"-||"}, "query"=>{"searchinfo"=>...
```

Great, we just ran a simple find function for "api", we limited the output, and the function
returned to us a hash with all the raw data we could ever want, straight from Wikipedia.

### Simple scripting
Now lets see how we can script our own little search tool.

```
# wiki_search.rb

# Load all the good stuff
require "wik"
include Wik

# Ask the user what to do
puts "Should we [1] Find based on topic, [2] Search for a page, [3] Describe a page, or [4] View by page title?"
print "[1/2/3] > "
choice = gets.chomp.to_i

# Run the magic
case choice
  when 1
    print "Find what? > "
    find(gets.chomp)
  when 2
    print "Search what? > "
    search(gets.chomp)
  when 3
    print "View what? > "
    view(gets.chomp)
  else
    puts "Did't get that..."
    exit
end
```

Nice, now we have a simple search tool we can run on our own.

## search(phrase, limit=5, description=true, display=true)

### Usage
Searching Wikipedia is done easily with `search()`, for example, running
`search("page")` will search for "page" and return a hash with raw data,
but also print the useful data to console.

### Arguments
+ `phrase`
  - A string to search for, don't worry, whitespace is delt with automatically
+ `limit`
  - An integer telling the maximum number of results allowed back, default 5
+ `description`
  - A boolean deciding if a short description should be printed out or not, default true
+ `display`
  - A boolean that decides if any output should be put to the console, default true

### Output

```
irb> search("ruby!", 1)
Displaying 1 results:

'Ruby (programming language)' : Ruby is a dynamic, reflective, object-oriented, general-purpose programming language. It was designed and developed in the mid-1990s by Yukihiro "Matz" Matsumoto in Japan.
=> ["ruby!", ["Ruby (programming language)"], ["Ruby is a dynamic, reflective, object-oriented, general-purpose programming language. It was designed and developed in the mid-1990s by Yukihiro \"Matz\" Matsumoto in Japan."], ["https://en.wikipedia.org/wiki/Ruby_(programming_language)"]]
```

## find(phrase, limit=15, snippet=false, display=true)

### Usage

### Arguments

### Output

## info(titles=nil, ids=nil, display=true)

### Usage

### Arguments

### Output

## view(title=nil, id=nil)

### Usage

### Arguments

### Output

## describe(title=nil, id=nil)

### Usage

### Arguments

### Output
# Wik's Ruby API

## Getting Started

Getting started is simple, first install the gem:

+ `sudo gem install wik`

Now that we have Wik installed, lets play around with it in `irb`!

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
Now lets see how we can script our own little search tool!

```
# wiki_search.rb

# Load all the good stuff
require "wik"
include Wik

# Ask the user what to do
puts "Should we [1] Find based on topic [2] Search for a page [3] View by page title?"
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
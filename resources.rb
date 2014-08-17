require 'FileUtils'
require "open-uri"
require 'random-word'
require 'mechanize'
require 'watir-webdriver'
require './flow.rb'

@a = Watir::Browser.new
page_markup = File.read('./page_markup.txt')

class Animation

end

def get_gifs_from_giphy(query,limit)
   url = "http://api.giphy.com/v1/gifs/search?q=#{query}&api_key=dc6zaTOxFJmzC&limit=#{limit}"
   resp = Net::HTTP.get_response(URI.parse(url))
   buffer = resp.body
   result = JSON.parse(buffer)

   print "I'm fetching nice pictures for you :D"

   divider_100 = 100/limit
   puts "\n"
   result["data"].each_with_index do |img,index|
      multiplier = divider_100*index
      print "Downloading the picture #{index} , we're at #{multiplier}% done"
      print "\r"

      download_pic(img["images"]["fixed_height"]["url"],query)

   end 
end

def download_pic(url,query)
   open(url) {|f|
      random_name = RandomWord.nouns.next
   File.open("animations/#{query}_#{random_name}.gif","wb") do |file|
     file.puts f.read
   end
}
end

def extract_asciis()

   #build_page
   page_markup = File.read('./page_markup.txt')
   correct_page = page_markup.gsub("images/test.jpg","images/" + image_name)
   File.open './index.html','w' do |f|
      f.write correct_page
   end

   @a.goto "file:///home/leonardo/Dropbox/asciifier/index.html"

   sanitized_name = image_name.gsub(/(jpg|png)/,"txt")

   File.open './asciified/' + sanitized_name ,'w' do |f|
      f.write @a.text
   end

end



def clear_animations!
   @animation_db = []
   array = %x[ls animations].split"\n"
   array.each do |a|
      FileUtils.rm("animations/" + a)
   end

   array2 = %x[ls asciified].split"\n"
   array2.each do |a|
      FileUtils.rm("asciified/" + a)
   end

   array3 = %x[ls images].split"\n"
   array3.each do |a|
      FileUtils.rm("images/" + a)
   end

end

def show_me_a_film_of(argument,limit)
   clear_animations!
   #sanitize argument
   argument = argument.gsub(" ","+")
   get_gifs_from_giphy(argument,limit)
   extract_all_animations
   puts "I'm ready to run the movie, are you? (Press enter to continue)"
   a = gets.chomp
   read_all_animations

end
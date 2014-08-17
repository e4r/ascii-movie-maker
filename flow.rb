class Animation
    attr_accessor :name, :frames

    def initialize(name,frames)
        @name = name
        @frames = frames
    end
end

def flow(animations)
	animations.each do |animation|
		#randomize
		#play_animation()
	end
end

@animation_db = []

def extract_ascii_from_gif(gif_name,n_frames)

   #build_page
   page_markup = File.read('./page_markup.txt')

   0.upto(n_frames).each do |i|
      %x[gifsicle animations/#{gif_name} '\##{i}' > images/animation_#{gif_name}#{i}.gif]
      correct_page = page_markup.gsub("images/test.jpg","images/animation_#{gif_name}#{i}.gif")
   
      File.open './index.html','w' do |f|
         f.write correct_page
      end
      path = %x[pwd]
      path.gsub!("\n",'')
      @a.goto "file://#{path}/index.html"

      sanitized_name = gif_name.gsub(/(jpg|png|gif)/,"txt")

      File.open './asciified/' + "animation_#{gif_name}#{i}.txt" ,'w' do |f|
         f.write @a.text
      end

   end

end

def extract_all_animations
   local_db = []
   local_db.push %x[ls animations].split"\n"
   local_db.flatten!
   local_db.each do |entry|
   	#determine animation frames
    n_images = %x[gifsicle --info animations/#{entry} |grep  "\d* images"]
    n_images = n_images.scan(/\d*\simages/)[0]
    n_images = n_images.scan(/\d*/)[0].to_i

    animation = Animation.new(entry,n_images)
    @animation_db.push animation

    extract_ascii_from_gif(entry,n_images - 1)
   end
end

def read_animation(animation,frames)
   
   0.upto(frames).each do |i|
    
      g = File.read("./asciified/animation_#{animation}#{i}.txt")
      puts g
      sleep 0.1

   end

end

def read_all_animations

    @animation_db.each do |entry|
        read_animation(entry.name,entry.frames-1)
    end

end
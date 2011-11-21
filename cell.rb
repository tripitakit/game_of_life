class Cell 
  
  include Sprites::Sprite
  include EventHandler::HasEventHandler
  
  attr_accessor :neighbours, :alive, :survivor, :image, :rect
  
  
  @@survivor_color = [95,0,190]
  @@newborn_color = [190,0,95] 
  @@living_now = 0
  @@deads = 0
  @@born = 0
  
  
  def initialize
    @image=Surface.new([$CELL_SIZE,$CELL_SIZE])     
  end
   
  def self.count
    return { living_now: @@living_now, deads: @@deads, born: @@born }
  end

  def die
    @alive = false
    @survivor = false  
    @@living_now -= 1  
    @@deads += 1
      
  end 

  def survive 
    @survivor = true
  end

  def birth
    @alive = true 
    @survivor = false  
    @@living_now += 1  
    @@born += 1
  end

  def set_sprite
      if @survivor # red survivor cell 
        @image.fill(@@survivor_color)
      else #  magenta new cell
        @image.fill(@@newborn_color)
      end
    @rect = image.make_rect   
  end

end
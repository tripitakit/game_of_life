class Cell 
  
  include Sprites::Sprite
  include EventHandler::HasEventHandler
  
  attr_accessor :neighbours, :alive, :survivor, :image, :rect
  
  
  @@survivor_color = [[255,255,0],[205,205,50],[155,155,100],[105,105,150],[55,55,200],[05,05,250]]
  @@newborn_color = :white 
  @@living_now = 0
  @@deads = 0
  @@born = 0
  
  
  def initialize
    @image=Surface.new([$CELL_SIZE,$CELL_SIZE]) 
    @age=0     
  end
   
  def self.count
    return { living_now: @@living_now, deads: @@deads, born: @@born }
  end

  def die
    @alive = false
    @survivor = false  
    @@living_now -= 1  
    @@deads += 1 
    @age = 0
      
  end 

  def survive 
    @survivor = true 
    @age += 1
  end

  def birth
    @alive = true 
    @survivor = false  
    @@living_now += 1  
    @@born += 1
  end

  def set_sprite
      if @survivor # red survivor cell   
        @age = @age > 5 ? 5 : @age
        @image.fill(@@survivor_color[@age-1])
      else #  magenta new cell
        @image.fill(@@newborn_color)
      end
    @rect = image.make_rect   
  end

end
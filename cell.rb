class Cell 
  
  include Sprites::Sprite
  include EventHandler::HasEventHandler
  
  
  attr_accessor :neighbours, :alive, :survivor, :image, :rect

  @@now = 0
  @@deads = 0
  @@born = 0
  
  def initialize
    @image=Surface.new([$CELL_SIZE,$CELL_SIZE])     
  end
   
  def self.count
    return { now: @@now, deads: @@deads, born: @@born}
  end

  def die
    @alive = false
    @survivor = false  
    @@now -= 1  
    @@deads += 1
      
  end 

  def survive 
    @survivor = true
  end

  def birth
    @alive = true 
    @survivor = false  
    @@now += 1  
    @@born += 1
  end

  def set_sprite    
    if @alive # survivor white cell 
      @image.fill(:red)
      @rect = image.make_rect   
    else # new yellow cell
      @image.fill(:yellow)
      @rect = image.make_rect
    end
  end

end
require 'rainbow'
class Cell
  attr_accessor :neighbours, :alive, :survivor, :body  
  @@now = 0
  @@deads = 0
  @@born = 0
  
  def initialize (body = "o")
    @body = body
    @empty = ' ' * body.size
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

  def to_s
    @alive ? living_cell : @empty
  end

  def living_cell
    @survivor ? @body.color(:red) : @body.color(:magenta)  
  end
end
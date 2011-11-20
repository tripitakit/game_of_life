module Patterns   
  
# blueprints for common patterns

  def block  
  ['11',
   '11']
  end

  def beehive 
  ['0110',
   '1001',
   '0110']
  end

  def loaf
  ['0110',
   '1001', 
   '0101',
   '0010']
  end

  def boat
  ['110',
   '101',
   '010']
  end

  # oscillators
  def blinker 
  ['111']
  end 

  def toad 
  ['0111',
   '1000']
  end

  def beacon
  ['1100',
   '1000',
   '0001',
   '0011']
  end
  # @spaceships
  def glider
  ['010',
   '001',
   '111']
  end                 

  def lightweight_spaceship
  ['01111',
   '10001',
   '00001',
   '10010']                      
  end

  # methuselahs
  def f_pentomino
  ['011',
   '110',
   '010']
  end

  # guns
  def gosper_glider_gun 
  ['000000000000000000000000100000000000',
   '000000000000000000000010100000000000',
   '000000000000110000001100000000000011',
   '000000000001000100001100000000000011',
   '110000000010000010001100000000000000',
   '110000000010001011000010100000000000',
   '000000000010000010000000100000000000',
   '000000000001000100000000000000000000',
   '000000000000110000000000000000000000'  
  ]        
  end  
  
  # breeders
  def butterfly
    ['111111110111110001110000001111111011111'] 
  end
  
  # pattern size methods
  def width 
    self[0].size
  end
  
  def height
    self.size
  end
  
  # pattern mirroring methods
  
  def y_mirror(pattern)
    mirrored = []
    pattern.each do |row|
      mirrored << row.reverse
    end
    return mirrored
  end  
  
  def x_mirror(pattern)
    pattern.reverse
  end
  
  def xy_mirror(pattern)
    x_mirror(y_mirror(pattern))
  end
  
end
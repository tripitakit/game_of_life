class World 
  attr_accessor :y, :x, :grid, :generation

  
    def initialize(y, x)
      @grid = Array.new(y) { Array.new(x) { Cell.new }  }
      @y = y-1 
      @x = x-1
      @generation = 0
    end 

    def random_sow(coverage_ratio)
      population_map = []
      ((@y*@x)*coverage_ratio).to_i.times do
         is_an_empty_place = false
         until is_an_empty_place
             y = Random.new.rand(@y) 
             x = Random.new.rand(@x)
             is_an_empty_place = true unless population_map.include? [y,x]   
         end
         sow(y, x)  
         population_map << [y,x]
        end                   
    end 

    def plot(pattern, world_y, world_x)
      pattern.each_with_index do |rows, pattern_y|
        rows.split('').each_with_index do |cell, pattern_x|        
          sow (pattern_y + world_y), (pattern_x + world_x) if cell == '1'       
        end
      end
    end
       
    def run!
        while true         
          tick!
          sleep 0.04 
      end  
    end
  
  
  private
   
    def sow(y,x) 
      return false if y > @y || x > @x
      @grid[y][x].birth
    end 
 
    def tick! 
      @generation += 1
      map_neighbours
      apply_selection_rules
      display_grid 
    end

    def map_neighbours
      @grid.each_with_index do |row,y|
        row.each_with_index do |cell, x| 
          cell.neighbours = count_neighbours(y,x)  
        end
      end
    end  

    def count_neighbours(y,x)
      counter = 0 

      # relative search choordinates    
      n = y-1
      s = y+1
      w = x-1
      e = x+1

      # make world toroidal
      n = @y if y == 0 
      s = 0 if y == @y
      w = @x if x == 0
      e = 0 if x == @x 

      counter +=1 if @grid[n][x].alive
      counter +=1 if @grid[s][x].alive
      counter +=1 if @grid[y][e].alive
      counter +=1 if @grid[y][w].alive
      counter +=1 if @grid[n][e].alive
      counter +=1 if @grid[n][w].alive
      counter +=1 if @grid[s][w].alive
      counter +=1 if @grid[s][e].alive

      return counter
    end  

    def apply_selection_rules
      @grid.flatten.each do |cell|
        if cell.alive
          cell.die if cell.neighbours < 2 || cell.neighbours > 3
          cell.survive if cell.neighbours == 2 || cell.neighbours == 3
        else
          cell.birth if cell.neighbours == 3
        end      
      end
    end    

    def display_grid 
      screen = ""
      system 'clear'
      @grid.each do |row|
        row.each do |cell|
          screen << cell.to_s
        end
        screen << "\n"
      end 
      puts screen  
      puts
      print "[Generation ##{@generation}".color(:green) +" :: " +
            "Cells count #{Cell.count[:now]}".color(:yellow) +" :: " +
            "Deads tot. ##{Cell.count[:deads]}".color(:blue) + " :: " +
            "Born tot. ##{Cell.count[:born]}".color(:magenta)  + "]"
    end
end
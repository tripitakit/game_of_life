class World
   
  attr_accessor :y, :x, :grid, :generation
  
    def initialize(y, x, screen)
      @grid = Array.new(y) { Array.new(x) { Cell.new }  }
      @y = y-1 
      @x = x-1
      @generation = 0 
      @screen = screen
    end 

    def random_sow(coverage_ratio=0.1)
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
        pupulation_map = nil                   
    end 

    def place(pattern, world_y, world_x)
      pattern.each_with_index do |rows, pattern_y|
        rows.split('').each_with_index do |cell, pattern_x|        
          sow (pattern_y + world_y), (pattern_x + world_x) if cell == '1'       
        end
      end
    end

    def tick! 
      @generation += 1
      map_neighbours
      apply_selection_rules
      update_grid 
    end
    
    
    def toggle_life(row,col)
      cell = @grid[row][col]
         cell.alive ? cell.die : cell.birth 
         update_grid
    end
    
    def clear
      @grid = Array.new(@y+1) { Array.new(@x+1) { Cell.new }  } 
      @generation = 0 
    end
    
    
    private
   
      def sow(y,x) 
        return false if y > @y || x > @x
        @grid[y][x].birth
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

      def update_grid 
        @grid.each_with_index do |row, y|
          row.each_with_index do |cell, x|     
            screen_x = (x+1)*$CELL_SIZE + x - $CELL_SIZE
            screen_y = (y+1)*$CELL_SIZE + y - $CELL_SIZE
            if cell.alive   
              cell.set_sprite 
              cell.rect.x = screen_x
              cell.rect.y = screen_y
              cell.draw (@screen)
            end
          end
        end 
      end
end
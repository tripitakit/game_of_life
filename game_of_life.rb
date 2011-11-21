require 'rubygame'

include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers  

require File.join(File.dirname(__FILE__),'world.rb')
require File.join(File.dirname(__FILE__),'cell')
require File.join(File.dirname(__FILE__),'patterns.rb')

include Patterns        
 
$world_rows = 45
$world_cols = 70
$CELL_SIZE = 15
$SCREEN_X = $world_cols * ($CELL_SIZE+1)
$SCREEN_Y = $world_rows * ($CELL_SIZE+1)

 
class GameOfLife  
  include EventHandler::HasEventHandler
  
  def initialize(*presets)
    make_screen
    make_clock
    make_hud
    make_queue
    make_event_hooks
    make_world
    presets.each { |preset| send ( preset ) }
  end   
  
  # main loop with infinite loop 
  def run! 
    @running = true
    catch([:quit]) do
      loop do
        step
      end
    end
  end


  private 

  def make_event_hooks
    hooks = {
      :space => :toggle_run,
      :a => :hi_framerate, 
      :z => :low_framerate,
      :b => :breeder,
      :c => :clear,
      :r => :random,
      :g => :glider_gun,
      :m => :metuselah,
      :l => :lw_spaceship,
      :f => :four_glider_crash,        
      :mouse_left => :toggle_life,
      :escape => :quit,
      :q => :quit,
      QuitRequested => :quit
    }
 
    make_magic_hooks( hooks )
  end
       

       
  
  def make_screen
     @screen = Screen.open( [$SCREEN_X, $SCREEN_Y] )
     @screen.title = "3PI::RubyGameOfLife"
  end 
  
  def make_clock
     @clock = Clock.new()
     @clock.target_framerate = 15
     @clock.calibrate
     @clock.enable_tick_events
   end

  def make_hud
    @hud = Hud.new (@screen)
  end
  
  def make_queue
    @queue = EventQueue.new()
    @queue.enable_new_style_events
    @queue.ignore = [MouseMoved, MousePressed]
  end
  
  def make_world 
   @world = World.new($world_rows, $world_cols, @screen)
  end 
  
  def hi_framerate  
    @clock.target_framerate = 30
    @clock.calibrate   
  end
 
  def low_framerate  
    @clock.target_framerate = 3
    @clock.calibrate   
  end
  
  def toggle_run
   if @running 
     @hud.status_bar = "GAME PAUSED :: EDIT MODE"  
     @hud.draw
     @running = false
     @queue.ignore -= [MouseMoved, MousePressed]
   else
     @running = true 
     @queue.ignore = [MouseMoved, MousePressed]
   end
  end 
  
  def toggle_life (event)
      col = screen2world event.pos[0] 
      row = screen2world event.pos[1]   
      
      puts "r #{row}, c #{col}"
      @world.toggle_life(row,col)       
      @screen.update()
  end  
  
  def screen2world(screen_pos)
    world_pos = screen_pos / ($CELL_SIZE + 1)    
  end
      
  def quit
    throw :quit
  end
  
  def resume
    @running = true
  end
     
  
  
  # main game step
  def step
    @screen.fill([12,24,36])
    
    @queue.each do |event|
      handle(event)
    end
    
    if @running
        @world.tick!
        @queue << @clock.tick
        @hud.update @world.generation
        @hud.draw
        @screen.update() 
    end 
    
  end 
  
   # preset pattern builders
   def lw_spaceship
      @world.place lightweight_spaceship, $world_rows/2, 0
   end  

   def metuselah 
      @world.place f_pentomino, $world_rows/2, ($world_cols - f_pentomino.width)/2
   end

   def glider_gun
     @world.place gosper_glider_gun, $world_rows/2, ($world_cols - gosper_glider_gun.width)/2
   end

   def clear
     @world.clear
   end

   def random
     @world.random_sow
   end   

   def four_glider_crash
     @world.place glider,1,1
     @world.place y_mirror(glider), 1,  $world_cols - glider.width - 1
     @world.place x_mirror(glider), $world_rows - glider.height, 1
     @world.place xy_mirror(glider), $world_rows - glider.height - 1, $world_cols - glider.width - 1 
  end  
  
  def breeder
    @world.place butterfly, $world_rows/2, ($world_cols - butterfly.width)/2
  end   
end 


class Hud 
  attr_accessor :status_bar
  def initialize (screen)
    TTF.setup
    filename = File.join(File.dirname(__FILE__), 'AndaleMono.ttf')
    @font_size = 16
    @font = TTF.new filename, @font_size
    @status_bar = ""
    @screen = screen
  end
  
  def update (generations)  
      @status_bar = "Generation ##{format_number(generations)}" 
  end
  
  def format_number (num)
      "0" * (6-num.to_s.size) + num.to_s
  end
  
  def draw(color=:yellow)
    status_bar = @font.render @status_bar, true, color
    status_bar.blit @screen, [($SCREEN_X - status_bar.w)/2 ,3]
  end

end

# Start main loop 
GameOfLife.new(:glider_gun).run!

# Clean up
Rubygame.quit() 


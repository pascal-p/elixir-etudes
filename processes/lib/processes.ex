defmodule Processes do

  require Game
  require Cards
  require Players
  # call Game, which calls Cards and Players ...

  def launch do
    Game.init
  end
  
end

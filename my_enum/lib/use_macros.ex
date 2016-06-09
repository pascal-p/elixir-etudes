defmodule UseMacros do
  require MyMacros

  def fun1 do
    MyMacros.unless 1 == 2 do
      IO.puts " 1 != 2"
    end
  end

  def fun2 do
    MyMacros.unless_alt 1 == 2 do
      IO.puts " 1 != 2"
    end
  end
  
end

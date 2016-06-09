defmodule Expect do

  defmacro expect(name, options) do
    quote do
      test("expect #{unquote name}", unquote(options))
    end
  end
  
end

ExUnit.start()

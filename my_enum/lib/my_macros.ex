defmodule MyMacros do

  defmacro unless(my_cond, my_clause) do
    do_clause = Keyword.get(my_clause, :do, nil)
    quote do
      if not(unquote(my_cond)), do: unquote(do_clause)
    end
  end

  defmacro unless_alt(my_cond, my_clause) do
    quote do
      if not(unquote(my_cond)), do: unquote(my_clause)
    end
  end

  defmacro on(kw, val, filt) do
    quote do
      if unquote(kw == val) do
        unquote(filt)
      else
        not(unquote(filt))
      end
    end
  end

  # NO DOES NOT WORK and it is a bit more complicated
  # defmacro gen_defp(fname, func, flag) do
  #   quote do
  #     defp unquote(fname)([], lr), do: lr
  #
  #     defp unquote(fname)([h | t], lr, func) do
  #       case unquote(func.(h)) do
  #         val when val in [false, nil] -> unquote(fname)(t, lr, func)
  #         _ -> unquote("#{fname}_#{way}")(t, [h | lr], func)
  #       end
  #     end
  #   end
  # end

end

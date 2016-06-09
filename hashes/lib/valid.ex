defprotocol Valid do
  @doc "Returns true if data is considered valid"
  
  def valid?(data)
end

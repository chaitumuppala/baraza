module ListValues
  def values
    constants.collect { |c| const_get(c) }
  end
end

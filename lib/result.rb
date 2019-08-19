Result = Struct.new(:value, :error)

class Result::Success < Result
  def success?
    true
  end
end

class Result::Failure < Result
  def success?
    false
  end
end

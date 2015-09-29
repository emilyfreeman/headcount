class UnknownDataError < StandardError

  def message
    "This is not the data you are looking for..."
  end

end

class UnknownRaceError < StandardError

  def message
    "Oops! It looks like you entered an invalid race."
  end

end

class InsufficientInformationError < StandardError

  def message
    "A grade must be provided to answer this question"
  end

end

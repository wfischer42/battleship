module Coordinates

  def full_coordinates(c_1, c_2)
    return nil if (c_1[0] != c_2[0]) && (c_1[1] != c_2[1])
    letters = (c_1[0]..c_2[0]).to_a
    numbers = (c_1[1]..c_2[1]).to_a
    all_coordinates(letters, numbers)
  end

  def all_coordinates(letters, numbers)
    coordinates = letters.product(numbers)
    coordinates.map! do |coord|
      coord.join
    end.sort
  end
end

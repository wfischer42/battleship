module Coordinates

  def full_coordinates(c_1, c_2)
    return nil if (c_1[0] != c_2[0]) && (c_1[1] != c_2[1])
    letters = (c_1[0]..c_2[0]).to_a
    numbers = (c_1[1]..c_2[1]).to_a
    all_coordinates(letters, numbers)
  end

  

  def unpack_coordinate(coord)
    letter = coord[0]
    number = coord[1].to_i
    return [letter, number]
  end
end

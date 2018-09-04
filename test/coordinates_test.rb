require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require './lib/coordinates'

class CoordinatesTest < Minitest::Test
  include Coordinates

  def test_it_calculates_coordinates_from_start_and_end_positions
    skip
    coords_1 = full_coordinates("C1", "C4")
    coords_2 = full_coordinates("A3", "D3")
    assert_equal ["C1", "C2", "C3", "C4"], coords_1
    assert_equal ["A3", "B3", "C3", "D3"], coords_2
  end

  def test_it_returns_nil_coordinates_for_invalid_positions
    coords_1 = full_coordinates("C1", "E4")
    coords_2 = full_coordinates("F7", "B9")

    binding.pry
    assert_nil coords_1
    assert_nil coords_2
  end

  def test_it_returns_all_coordinates_with_letter_number_combo
    letters = ["A", "B", "C"]
    numbers = ["1", "2"]
    coords = all_coordinates(letters, numbers)
    p coords
  end

end

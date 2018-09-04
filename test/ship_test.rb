require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require './lib/ship'

class ShipTest < Minitest::Test
  def test_it_exists
    ship = Ship.new("A1", "A3")
    assert_instance_of Ship, ship
  end

  def test_ship_class_calculates_coordinates_from_start_and_end_positions
    coords_1 = Ship.coordinates("C1", "C4")
    coords_2 = Ship.coordinates("A3", "D3")
    assert_equal ["C1", "C2", "C3", "C4"], coords_1
    assert_equal ["A3", "B3", "C3", "D3"], coords_2
  end

  def test_ship_class_returns_nil_coordinates_for_invalid_positions
    coords_1 = Ship.coordinates("C1", "E4")
    coores_2 = Ship.coordinates("F7", "B9")
  end

  def test_ship_has_coordinates
    ship = Ship.new("A1", "A3")
    assert_equal ["A1", "A2", "A3"], ship.coordinates
  end

  def test_it_can_be_oriented_vertically
    ship = Ship.new("B2", "D2")
    assert_equal ["B2", "C2", "D2"], ship.coordinates
  end

  def test_it_checks_if_a_coordinate_set_will_overlap_with_its_own
    ship = Ship.new("B2", "D2")
    refute ship.overlap?("A3", "B3")
    assert ship.overlap?("C1", "C5")
    assert ship.overlap?("A2", "C2")
  end

  def test_it_is_seaworthy_by_default
    ship = Ship.new("A1", "A4")
    assert_equal [], ship.hits
    assert ship.floating?
  end

  def test_it_can_be_hit_by_a_shot
    ship = Ship.new("A1", "A4")
    shot_1 = "A2"
    shot_2 = "A4"
    assert_equal :hit, ship.resolve_shot(shot_1)
    assert_equal :hit, ship.resolve_shot(shot_2)
  end

  def test_it_isnt_hit_by_bad_shot
    ship = Ship.new("B2", "D2")
    assert_equal :miss, ship.resolve_shot("A1")
    assert_equal :miss, ship.resolve_shot("C4")
  end

  def test_it_keeps_track_of_hits
    ship = Ship.new("A1", "A4")
    assert_equal [], ship.hits
    ship.resolve_shot("A1")
    ship.resolve_shot("A3")
    assert_equal ["A1", "A3"], ship.hits
  end

  def test_it_can_be_sunk
    ship = Ship.new("A1", "A3")

    ship.resolve_shot("A1")
    ship.resolve_shot("A2")
    assert ship.floating?

    ship.resolve_shot("A3")
    refute ship.floating?
  end
end

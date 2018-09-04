require 'minitest/autorun'
require 'minitest/pride'

require './lib/battle_grid'

class BattleGridTest < Minitest::Test
  def test_it_exits
    p1_grid = BattleGrid.new(10)
    assert_instance_of BattleGrid, p1_grid
  end

  def test_it_has_cells
    skip
    p1_grid = BattleGrid.new(2)
    assert_equal ["A1", "A2", "B1", "B2"], p1.cell_list
  end

  def test_it_determines_if_coordinates_are_in_bounds
    skip
    p1_grid = BattleGrid.new(5)
    assert p1_grid.in_bounds?("A3", "A5")
    refute p1_grid.in_bounds?("A1", "M1")
  end

  def test_cells_are_empty_by_default
    skip
    p1_grid = BattleGrid.new(2)
    assert_equal :water, p1_grid.cells["A"]["1"]
    assert_equal :water, p1_grid.cells["B"]["2"]
  end

  def test_it_has_no_ships_in_fleet_by_default
    skip
    p1_grid = BattleGrid.new(5)
    assert_equal [], p1_grid.fleet
  end

  def test_it_can_place_ships
    skip
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A4")
    ship_2 = Ship.new("B3", "C3")

    p1_grid.place_ship(ship_1)
    p1_grid.place_ship(ship_2)

    assert_equal [ship_1, ship_2], p1_grid.fleet
  end

  def test_it_can_determine_if_a_shot_hits
    skip
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A4")

    hit_1 = p1_grid.resolve_shot("B2")
    hit_2 = p1_grid.resolve_shot("A2")

    refute hit_1
    assert hit_2
  end

  def test_cells_store_ship_locations
    skip
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A4")

    assert_equal :unhit, p1_grid.cells["A"]["2"]
    assert_equal :unhit, p1_grid.cells["A"]["4"]
    assert_equal :water, p1_grid.cells["B"]["4"]
  end

  def test_cells_store_hit_locations
    skip
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A3")
    p1_grid.resolve_shot("A2")

    assert_equal :hit, p1_grid.cells["A"]["2"]
    assert_equal :unhit, p1_grid.cells["A"]["3"]
    assert_equal :water, p1_grid.cells["B"]["4"]
  end

  def test_cells_store_miss_locations
    skip
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A3")
    p1_grid.resolve_shot("B4")

    assert_equal :unhit, p1_grid.cells["A"]["2"]
    assert_equal :miss, p1_grid.cells["B"]["4"]
  end

  def test_it_can_count_remaining_ships
    skip
    p1_grid = BattleGrid.new(5)
    ship_1 = Ship.new("A1", "A3")
    assert_equal 1, p1_grid.fleet_size

    p1_grid.resolve_shot("A1")
    p1_grid.resolve_shot("A2")
    p1_grid.resolve_shot("A3")

    assert_equal 1, p1_grid.fleet_size
  end
end

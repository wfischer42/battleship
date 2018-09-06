# TODO: Move to modules

=begin
# XXX: Update to "grid", move some stuff from battlegrid, and add other griddish methods?

If this was "grid", it could return grid from lists of numbers & letters,
determine overlap of "grids", return masked & unmasked grids, store & update
grid states.

No need to overthink it. The ship class already handles things well, so try to
avoid changing it except to move dual-purpose methods over.

Mostly, I want to be able to find a "valid targets" list from a masked grid.
That way, the same info can be used to print a board for the user, find a list
of valid targets for input authentication, and find a list of valid targets for
computer actions.

Then, after the shot resolution, game will get a hash for the masked grid of the
opponent and the unmasked grid for self, and update the respective "interface."

The computer and human interfaces (subclassed from player) will have these
grids stored, and will use the module (included in the player superclass) to
get a valid moves list.
=end

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

# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = [
    [[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
    rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
    [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
    [[0, 0], [0, -1], [0, 1], [0, 2]]],
    rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
    rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
    rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
    rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
    rotations([[0, 0], [-1, 0], [-1, 1], [0, 1], [1, 1]]), # 5-block L
    [[[-1, 0], [-2, 0], [0, 0], [1, 0], [2, 0]], # 5-block long (only needs two)
    [[0, -1], [0, -2], [0, 0], [0, 1], [0, 2]]],
    rotations([[0, 0], [0, 1], [1, 1]]) # 3-block L
  ]

  # your enhancements here
  Cheat_Piece = [[[0, 0]]]
  # class method to choose the next piece
  def self.next_piece (board, use_cheat=false)
    if use_cheat
      MyPiece.new(Cheat_Piece, board)
    else
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end
end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @use_cheat = false
  end

  # gets the next piece
  def next_piece 
    if @use_cheat
      @current_block = MyPiece.next_piece(self, true)
    else
      @current_block = MyPiece.next_piece(self)
    end
    @use_cheat = false
    @current_pos = nil
  end

  # gets the information from the current piece about where it is and uses this
  # to store the piece on the board itself.  Then calls remove_filled.
  def store_current
    locations = @current_block.current_rotation  # current orientation of block
    displacement = @current_block.position  # steps that block has moved from initial base position
    # grid is 2d array of rows by columns i.e. for coord (x, y)
    # we should index into the grid as grid[y][x] 
    locations.each_with_index{|coord, index| 
    @grid[coord[1]+displacement[1]][coord[0]+displacement[0]] = @current_pos[index]}
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  # do 180 clockwise rotation of falling piece 
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def cheat
    if @use_cheat
      return
    elsif score >= 100 and !game_over? and @game.is_running?
      @score = @score - 100
      @game.update_score
      @use_cheat = true
    end
  end

end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 3, 24, 80)
    @board.draw
  end

  def key_bindings  
    super # call method in parent class
    @root.bind('u', proc {@board.rotate_180})
    @root.bind('c', proc {@board.cheat})
  end

end



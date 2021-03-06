class Game

  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
   [0,1,2],
   [3,4,5],
   [6,7,8],
   [0,3,6],
   [1,4,7],
   [2,5,8],
   [0,4,8],
   [2,4,6]
  ]

  def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    # binding.pry
    self.board = board
    self.player_1 = player_1
    self.player_2 = player_2
    # player_1.board = self.board
    # player_2.board = self.board
    # binding.pry
  end

  def current_player
    x_moves = self.board.cells.select {|moves| moves == "X"}
    o_moves = self.board.cells.select {|moves| moves == "O"}
    x_moves.size == o_moves.size ? self.player_1 : self.player_2
  end

  def over?
    # binding.pry
    draw? || won?
  end



  def won?
  # binding.pry
    WIN_COMBINATIONS.find do |win_combination|
      # binding.pry
      win_index_1 = win_combination[0]
      win_index_2 = win_combination[1]
      win_index_3 = win_combination[2]

      position_1 = self.board.cells[win_index_1]
      position_2 = self.board.cells[win_index_2]
      position_3 = self.board.cells[win_index_3]

      # (position_1 == "X" || position_1 == "O") &&
      # binding.pry
      position_1 == position_2 && position_2 == position_3 && position_1 != " "
    end
  end

  def draw?
    board.full? && won? == nil
  end

  def winner
    # binding.pry
    if won? != nil
      winning_position = won?
      winning_index = winning_position[0]
      # binding.pry
      self.board.cells[winning_index]
    else
      nil
    end
  end

  def turn
    if board.turn_count.even?
      puts "Player 1:"
      board.display
      move = self.player_1.move(self.board)
      if board.valid_move?(move)
        board.update(move, self.player_1)
      else
        puts "Invalid move"
        turn
      end
    else
      puts "Player 2:"
      board.display
      move = self.player_2.move(self.board)
      if board.valid_move?(move)
        board.update(move, self.player_2)
      else
        puts "Invalid move"
        turn
      end
    end
  end

  def play
    while !over?
      puts "Player, please enter 1 - 9"
      turn
    end

    if won?
      puts "Winning board:"
      board.display
      puts "Congratulations #{winner}!"
    else draw?
      board.display
      puts "Cat's Game!"
    end
  end

  def self.start
    puts "Welcome to TicTacToe"
    puts "Please choose 0, 1, or 2 players"
    input = gets.strip
    if input == "0"
      game = Game.new(Players::Computer.new("X"), Players::Computer.new("O"))
      game.play
    elsif input == "1"
      puts "Choose token: X or O:"
      token = gets.strip.upcase
      if token == "X"
        game = Game.new(Players::Human.new(token), Players::Computer.new("O"))
        game.play
      elsif token == "O"
        game = Game.new(Players::Human.new(token), Players::Computer.new("X"))
        game.play
      else
        puts "Please choose an X or O token only."
        start
      end
    elsif input == "2"
      puts "Choose token: X or O for player 1:"
      token - gets.strip.upcase
      if token == "X"
        game = Game.new(Players::Human.new(token), Players::Human.new("O"))
        game.play
      elsif token == "O"
        game = Game.new(Players::Human.new(token), Players::Human.new("X"))
        game.play
      else
        puts "Please choose an X or O token only."
        start
      end
    else
      puts "Invalid input"
      start
    end
  end

  def play_again
    puts "Play again? y/n:"
    input = gets.strip.upcase
    if input == "Y"
      self.start
    elsif input == "N"
      exit
    else
      play_again
    end
  end
end

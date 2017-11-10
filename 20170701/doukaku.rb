require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'activesupport', require: 'active_support/all'

  gem 'minitest', require: 'minitest/autorun'
  gem 'minitest-reporters'

  gem 'awesome_print'
  gem 'tapp'

  gem 'pry'
  gem 'pry-rescue', require: 'pry-rescue/minitest'
  gem 'pry-stack_explorer'
end

class Board
  def initialize
    @board = [
      [0, 1],
      [2, nil]
    ]
    @count = 3
  end

  def increment!
    size = board.size

    size.times do |y|
      size.times do |x|
        if col = board[y][x]
          board[y][size + x] = col + self.count
          board[size + y] ||= []
          board[size + y][x] = col + (self.count * 2)
        end
      end
    end

    self.count *= 3
  end

  def find_index(num)
    board.each.with_index do |row, y|
      row.each.with_index do |col, x|
        return [x, y] if col == num
      end
    end

    raise
  end

  def [](x, y)
    return nil if x < 0 || y < 0

    board.dig(y, x)
  end

  attr_reader :board
  attr_accessor :count

  delegate :size, to: :board
end

$board = Board.new

def solve(input)
  input = input.to_i

  $board.increment! while input >= $board.count

  x, y = $board.find_index(input)
  $board.increment! if x + 1 == $board.size || y + 1 == $board.size

  [
    $board[x, y - 1],
    $board[x, y + 1],
    $board[x - 1, y],
    $board[x + 1, y]
  ].compact.sort.join(?,)
end

TEST_DATA = <<~EOS
/*0*/ test( "21", "19,22,23" );
/*1*/ test( "0", "1,2" );
/*2*/ test( "1", "0,3" );
/*3*/ test( "2", "0,6" );
/*4*/ test( "3", "1,4,5" );
/*5*/ test( "4", "3,9" );
/*6*/ test( "9", "4,10,11" );
/*7*/ test( "15", "11,16,17" );
/*8*/ test( "27", "13,28,29" );
/*9*/ test( "32", "30" );
/*10*/ test( "47", "45,51" );
/*11*/ test( "65", "63,69" );
/*12*/ test( "80", "78,162" );
/*13*/ test( "199", "198,201" );
/*14*/ test( "204", "200,205,206" );
/*15*/ test( "243", "121,244,245" );
/*16*/ test( "493", "492" );
/*17*/ test( "508", "507" );
/*18*/ test( "728", "726,1458" );
/*19*/ test( "793", "792,795" );
/*20*/ test( "902", "900,906" );
/*21*/ test( "981", "976,982,983" );
/*22*/ test( "1093", "1092,2187" );
/*23*/ test( "1202", "1200" );
/*24*/ test( "1300", "1299,1305" );
/*25*/ test( "1962", "1952,1963,1964" );
/*26*/ test( "2188", "2187,2190" );
/*27*/ test( "2405", "2403,2409" );
/*28*/ test( "3326", "3324" );
/*29*/ test( "6561", "3280,6562,6563" );
/*30*/ test( "6612", "6608,6613,6614" );
/*31*/ test( "7058", "7056,7062" );
/*32*/ test( "8444", "8442,8448" );
/*33*/ test( "9841", "9840,19683" );
/*34*/ test( "15243", "15239,15244,15245" );
/*35*/ test( "19946", "19944,19950" );
/*36*/ test( "21148", "21147" );
/*37*/ test( "39365", "39363" );
/*38*/ test( "39366", "19682,39367,39368" );
/*39*/ test( "55694", "55692,55698" );
/*40*/ test( "57245", "57243" );
/*41*/ test( "66430", "66429,66432" );
/*42*/ test( "92740", "92739" );
/*43*/ test( "115250", "115248" );
/*44*/ test( "163031", "163029" );
/*45*/ test( "221143", "221142,221157" );
/*46*/ test( "410353", "410352" );
/*47*/ test( "412649", "412647,412659" );
/*48*/ test( "550391", "550389" );
/*49*/ test( "699921", "699880,699922,699923" );
/*50*/ test( "797161", "797160,1594323" );
/*51*/ test( "1000000", "999999,1000002" );
EOS

Minitest::Reporters.use!(Minitest::Reporters::ProgressReporter.new)

# docker-compose run --rm -w /app/YYYYmmdd bundle exec ruby doukaku.rb -n /#1$/
describe 'Doukaku' do
  def self.test_order; :sorted; end

  TEST_DATA.each_line do |test|
    number, input, expected = test.scan(/(\d+).*"(.*)", "(.*)"/)[0]

    it "##{number}" do
      assert_equal expected, solve(input)
    end
  end
end
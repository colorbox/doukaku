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

def parse(input)
  input.scan(/\w{2}/)
end

def solve(input)
  board = [
    {},
    {},
    {},
    {},
    {},
    {}
  ]

  areas = parse(input)

  if areas.include?('00')
    (?a..?t).each do |k|
      board[0][k] = true
    end
    areas.delete('00')
  end

  areas.each do |c|
    num, x = c.chars
    board[num.to_i][x] = true
  end

  sum = 0
  board.each.with_index do |line, i|
    line.keys.each do |k|
      puts "#{i}#{k}"
      puts ?- * 20
      # 左上
      p('LT') && sum += 1 unless board[i].key?(prev_key(k)) || board[i - 1].key?(k) || i.zero?
      # 左
      p('L') && sum += 1 unless board[i - 1].key?(next_key(k)) || board[i - 1].key?(k) || i.zero?
      # 左下
      p('LB') && sum += 1 unless board[i - 1].key?(next_key(k)) || board[i].key?(next_key(k)) || i.zero?
      # 右下
      p('RB') && sum += 1 unless board[i + 1].key?(k) || board[i].key?(next_key(k))
      # 右
      p('R') && sum += 1 unless board[i + 1].key?(prev_key(k)) || board[i + 1].key?(k)
      # 右上
      p('RT') && sum += 1 unless board[i].key?(prev_key(k)) || board[i + 1].key?(prev_key(k))
    end
  end
  sum.to_s
end

def prev_key(key)
  if key == 'a'
    't'
  else
    (key.ord - 1).chr
  end
end

def next_key(key)
  if key == 't'
    'a'
  else
    (key.ord + 1).chr
  end
end

TEST_DATA = <<~EOS
/*0*/ test( "1a2t3s2s", "11" );
/*1*/ test( "1a1c1d00", "22" );
/*2*/ test( "00", "20" );
/*3*/ test( "3q", "6" );
/*4*/ test( "3t2a", "8" );
/*5*/ test( "3t3a", "8" );
/*6*/ test( "3t4a", "12" );
/*7*/ test( "004q2g", "32" );
/*8*/ test( "4c2g2k4i", "24" );
/*9*/ test( "1o1a4f4i1t", "26" );
/*10*/ test( "4t3a4g2a2o2p", "24" );
/*11*/ test( "4i4o3i3c3n3h2c", "30" );
/*12*/ test( "4m3n3m002b1b3a", "34" );
/*13*/ test( "001b2a3t4s3s2s1s", "27" );
/*14*/ test( "1n1j3o4o1h2n2r1k", "36" );
/*15*/ test( "4o2a2j1m2e4l2l3m3o", "42" );
/*16*/ test( "1j2p1a4r4b1i3h4e3i2i", "42" );
/*17*/ test( "001a1c1e1g1i1k1m1o1q1s", "30" );
/*18*/ test( "3n2j3e3a2n1f1p2q3t4t3h", "53" );
/*19*/ test( "4a4b4c3d2e1e1d1c3a2a1b", "22" );
/*20*/ test( "3n3e3t4i3m2d2g3i1j4o2i4t", "52" );
/*21*/ test( "3t2m4n2l4g4h1a1n2t4m2h3a1m", "44" );
/*22*/ test( "1p1i2n3q1d2o2c1q3m3f003k3l2s", "53" );
/*23*/ test( "3r1q3p2d4k4n1r3o4l2j2c1a4o3q4f", "56" );
/*24*/ test( "4d2f4r3f2p4t1j1p4g1q4f1k2j2s4i4j", "62" );
/*25*/ test( "002c2d1f2f3e4d4c4b4a3a1b2t1t2a2g1h", "40" );
/*26*/ test( "3r2i2j3d2t3j3g2s1p2o2p1n1m2d1k1r3i", "59" );
/*27*/ test( "4o4s1i4p3p3s3b4n3r1k4a3t4g3n1o2m3i2o", "66" );
/*28*/ test( "3k2j1i2p2n3l2f2s3f1n4s2h3s1l1m4n4k4q2k", "65" );
/*29*/ test( "1a1b1c1d1e1f1g1h1i1j1k1l1m1n1o1p1q1r1s1t", "40" );
/*30*/ test( "4n3f1c1a3o2s1h2p2k3g3n2e4s2t1j1b3h2a1n3k", "73" );
/*31*/ test( "1a1b1c1d1e1f1g1h1i1j1k1l1m1n1o1p1q1r1s1t00", "20" );
/*32*/ test( "2a2b2c2d2e2f2g2h2i2j2k2l2m2n2o2p2q2r2s2t00", "60" );
/*33*/ test( "2m1p2c2o2n4n002s1m3i2t4l2b3r2h1j4q1c4t1s1a", "65" );
/*34*/ test( "4m2t4r4h3b4b2e3g3n2i4e3m1q4i2q2b2m3i2a1b2s1h", "77" );
/*35*/ test( "1c004g1k4o3p3l3h1r4d2t2c2d1n4t2e1s1j2p1d4j1h1f", "74" );
/*36*/ test( "1s3j4a4h3h3q3n3b3f2m3o3c4i3r2r1f1c2p4s1e3a2j2o3e", "80" );
/*37*/ test( "2c1b3b3k2f1e4q1d1m4n3t4b4s3h3d3g3n1f4p4j2e4f4c3e1k", "78" );
/*38*/ test( "2p4k3t1h4e1n3g4p2j1a1k1p4f1o3a4s4q4i3p2t4l3k2k3s2r4h", "77" );
/*39*/ test( "1d1p4o3n3m4d1m2f3c1o3f3g3a2o1f4n2c4e2j4p4f1b1j1i1k1h2m", "74" );
/*40*/ test( "3m4d4e1i3t4f1f3n2p2g1q4g2c2m1s2r2i3f3o1h3g2e1o3a4r3h3r4o", "75" );
EOS

Minitest::Reporters.use!(Minitest::Reporters::ProgressReporter.new)

describe 'Doukaku' do
  TEST_DATA.each_line do |test|
    input, expected = test.scan(/"(.*)", "(.*)"/)[0]

    it input do
      assert_equal expected, solve(input)
    end
  end
end

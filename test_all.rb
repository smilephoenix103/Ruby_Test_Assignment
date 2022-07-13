require './test_class.rb'

test = {}

test[:a] = TestClass.new("Marugo", 29, "marugo@gmail.com")
test[:b] = TestClass.new("Marugo", "29", "marugo@gmail.com")
test[:c] = TestClass.new("Marugo", 29, "M@R$G&@gmail.com")
test[:d] = TestClass.new("Marugo29", 29, "marugo@gmail.com")
test[:e] = TestClass.new("Marugo29", "29", "marugo@gmail.com")
test[:f] = TestClass.new("Marugo29", "29", "M@R$G&@gmail.com")
test[:g] = TestClass.new(nil, 29, "marugo@gmail.com")
test[:h] = TestClass.new("Marugo", nil, "marugo@gmail.com")
test[:i] = TestClass.new("Marugo", 29, nil)
test[:j] = TestClass.new("Marugo", 29, 456)

test.each_pair do |k, v|
  begin
    v.validate!
  rescue StandardError => e
    puts "test[#{k}] ==> #{e.to_s}"
  end
end

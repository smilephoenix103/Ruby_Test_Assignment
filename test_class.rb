require "./validation"

class TestClass
  include Validation
  @name, @age, @email = nil
  attr_accessor :name, :age, :email

  validate :name, presence: true
  validate :age, presence: true
  validate :email, presence: true

  validate :email, type: String
  validate :age, type: Integer
  validate :email, format: /\A([a-z@.])+\z/
  validate :name, format: /\A([a-zA-z])+\z/

  def initialize name, age, email
    @name, @age, @email = name, age, email
  end

end

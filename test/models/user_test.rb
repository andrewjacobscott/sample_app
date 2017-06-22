require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example user", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = 'a' * 50
    assert @user.valid?
  end

  test "name should be too long" do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a' * 245 + "@email.com"
    assert @user.valid?
  end

  test "email should be too long" do
    @user.email = 'a' * 246 + "@email.com"
    assert_not @user.valid?
  end

  test "email validation shoud accept vaild addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end


  test "email validation shoud reject invalid addresses" do
    valid_addresses = %w[user@example,com USER_at_foo.COM user.name@example.
                         foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_not @user.valid?, "#{valid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    dulicate_user = @user.dup
    @user.save
    assert_not dulicate_user.valid?
  end

  test "email address should be unique case insensitive" do
    dulicate_user = @user.dup
    dulicate_user.email = @user.email.upcase
    @user.save
    assert_not dulicate_user.valid?
  end

  test "password should be present" do
    @user.password = ' ' * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = 'a' * 5
    assert_not @user.valid?
  end


end

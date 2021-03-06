require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@ignitemedia.com",
    				password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@ignitemedia.com USER@ignitemedia.com A_US-ER@ignitemedia.com
                         first.last@ignitemedia.com alice+bob@ignitemedia.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com user@gmail.com user@yahoo.com
                           user@outlook.com user@example.com user@me.com user@icloud.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "admin_key should be equal to secret key" do
    @user.admin_key = "secret"
    assert @user.valid?
  end

  test "admin_key validation should reject invalid keys" do
    invalid_keys = %w[test pass champ secre]
    invalid_keys.each do |invalid_key|
      @user.admin_key = invalid_key
      assert_not @user.valid?
    end
  end
end
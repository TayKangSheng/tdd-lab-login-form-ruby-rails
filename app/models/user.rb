# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :password_confirm

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validate :matching_password_confirmation, on: :signup
  validate :password_length, on: :signup

  validates :password, presence: { on: :create }

  def self.signup(new_user)
    new_user.valid?(:signup)
    new_user.save if new_user.errors.empty?

    new_user
  end

  private

  def matching_password_confirmation
    return unless password_confirm && password != password_confirm

    errors.add(:base, :mismatch_password, message: 'Passwords do not match')
  end

  def password_length
    return if password.length >= 12

    errors.add(:base, :password_length, message: 'Password should be longer than 12 characters')
  end
end

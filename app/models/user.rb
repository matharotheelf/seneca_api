# frozen_string_literal: true

# model to represent user data
class User < ApplicationRecord
  has_many :sessions
end

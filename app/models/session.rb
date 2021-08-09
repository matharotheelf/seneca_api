# frozen_string_literal: true

# model to represent session data
class Session < ApplicationRecord
  belongs_to :course
  belongs_to :user
end

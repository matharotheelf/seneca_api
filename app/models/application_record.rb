# frozen_string_literal: true

# application wide model functionality
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

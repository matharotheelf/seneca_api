class Course < ApplicationRecord
  has_many :sessions

  def total_modules_by_user(user)
    sessions.where(user: user).sum(:totalModulesStudied)
  end

  def average_score_by_user(user)
    sessions.where(user: user).average(:averageScore).to_f
  end

  def time_studied_by_user(user)
    sessions.where(user: user).sum(:timeStudied)
  end
end

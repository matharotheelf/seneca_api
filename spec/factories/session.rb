FactoryBot.define do
  factory :session do
    totalModulesStudied { Random.new(10) }
    sessionId { Faker::Internet.uuid }
    averageScore { Random.new(100) }
    timeStudied { Random.new(1000) }
    association :course
    association :user
  end
end

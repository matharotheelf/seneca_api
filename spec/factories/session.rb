FactoryBot.define do
  factory :session do
    totalModulesStudied { rand(10) }
    sessionId { Faker::Internet.uuid }
    averageScore { rand(100) }
    timeStudied { rand(1000) }
    association :course
    association :user
  end
end

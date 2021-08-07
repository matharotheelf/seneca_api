Rails.application.routes.draw do
  post '/courses/:course_id', to: 'sessions#create'
end

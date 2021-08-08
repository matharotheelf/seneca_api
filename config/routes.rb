Rails.application.routes.draw do
  post '/courses/:course_id', to: 'sessions#create'
  resources :courses, only: [:show]
end

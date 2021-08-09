# frozen_string_literal: true

Rails.application.routes.draw do
  post '/courses/:course_id', to: 'sessions#create'
  get '/courses/:course_id/sessions/:id', to: 'sessions#show'
  resources :courses, only: [:show]
end

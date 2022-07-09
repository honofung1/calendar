Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resource :calendar, only: [:show], controller: :calendar
  root to: 'calendar#show'
end

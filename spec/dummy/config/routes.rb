Rails.application.routes.draw do
  resources :patients, only: [:index]
end

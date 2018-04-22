Rails.application.routes.draw do
  devise_for :users
  resources :project
  post '/project/webhook/:id', to: 'changelog#webhook'
  get '/project/changelog/:id/edit', to: 'changelog#edit'
  patch '/project/changelog/:id/update', to: 'changelog#update', as: 'changelog_update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

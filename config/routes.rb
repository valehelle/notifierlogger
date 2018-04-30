Rails.application.routes.draw do
  root :to => "front#index"
  devise_for :users
  resources :project
  post '/project/webhook/github/:id', to: 'changelog#github_webhook', as: 'github_webhook'
  post '/project/webhook/gitlab/:id', to: 'changelog#gitlab_webhook', as: 'gitlab_webhook'

  get '/project/:id/settings', to: 'project#settings', as: 'project_settings'
  get '/project/changelog/:id/edit', to: 'changelog#edit', as: 'changelog_edit'
  patch '/project/changelog/:id/update', to: 'changelog#update', as: 'changelog_update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

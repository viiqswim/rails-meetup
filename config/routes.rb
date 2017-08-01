Rails.application.routes.draw do
  resources :groups, except: [:show, :index]
    
  get 'groups/', to: 'groups#all_groups', as: "group_index"
  get 'groups/:id/index', to: 'groups#index', as: "group_organizers"
  get 'groups/:id/', to: 'groups#show', as: "group_members"
  
  root 'groups#all_groups'
end

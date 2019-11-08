Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :movies, only: [:index, :show, :create]
  get "/movies/:id/current", to: "movies#current", as: "movie_current"
  get "/movies/:id/history", to: "movies#history", as: "movie_hx"
  
  resources :customers, only: [:index]
  get "/customers/:id/current", to: "customers#current", as: "customer_current"
  get "/customers/:id/history", to: "customers#history", as: "customer_hx"
  
  post "/rentals/check-out", to: "rentals#check_out", as: "check_out"
  post "/rentals/check-in", to: "rentals#check_in", as: "check_in"
  get "/rentals/overdue", to: "rentals#overdue", as: "overdue"
end

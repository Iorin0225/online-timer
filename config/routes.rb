Rails.application.routes.draw do
  root 'timers#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'timers/index'
  get 'timers/:token',       to: 'timers#show',  as: 'timers_show'
  get 'timers/:token/json',  to: 'timers#json',  as: 'times_json'
  put 'timers/:token/reset', to: 'timers#reset', as: 'times_reset'
end

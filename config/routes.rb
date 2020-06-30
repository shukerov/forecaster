Rails.application.routes.draw do
  get 'forecast/index'
  get 'locations/index'
  root 'forecast#index'
end

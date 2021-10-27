Rails.application.routes.draw do
  resource :password_reset, only: [:show, :create]
end

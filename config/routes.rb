Rails.application.routes.draw do
  resource :password_reset, only: [:create, :show, :update]
end

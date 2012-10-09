Rails.application.routes.draw do

  root :to => "pages#index"
  mount Jail::Engine => "/jail" if  !Rails.env.production?

end

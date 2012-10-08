Rails.application.routes.draw do

  mount Jail::Engine => "/jail" if  !Rails.env.production?
end

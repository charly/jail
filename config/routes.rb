Jail::Engine.routes.draw do

  root :to => "githubs#index"
  match ":name/:repo" => "githubs#show"
  match ":name/:repo/install" => "githubs#install"
  match ":name/:repo/*path" => "githubs#show"
end

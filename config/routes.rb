Jail::Engine.routes.draw do

  root :to => "githubs#index"
  with_options(:repo => /[^\/]+/ ) do |opt|
    opt.match ":name/:repo" => "githubs#show"
    opt.match ":name/:repo/install" => "githubs#install"
    opt.match ":name/:repo/remove" => "githubs#remove"
    opt.match ":name/:repo/*path" => "githubs#show"
  end
end

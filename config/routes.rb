Jail::Engine.routes.draw do

  root :to => "githubs#index"
  match "/cdnjs" => "cdnjs#index"
  with_options(:name => /[^\/]+/ ) do |opt|
    opt.match "/cdnjs/:name"  => "cdnjs#show",    :via => :get
    opt.match "/cdnjs/:name"  => "cdnjs#install", :via => :post
    #opt.match "/cdnjs/:name/remove"   => "cdnjs#remove"
    #opt.match "/cdnjs/:name/*path"    => "cdnjs#show"
  end

  with_options(:repo => /[^\/]+/ ) do |opt|
    opt.match ":name/:repo" => "githubs#show"
    opt.match ":name/:repo/install" => "githubs#install"
    opt.match ":name/:repo/remove" => "githubs#remove"
    opt.match ":name/:repo/*path" => "githubs#show"
  end


end

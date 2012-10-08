module Jail
  #LOGIN = 'name:secret'
  Jail::Github.add_githublist(Rails.root.join("config/jail.inmates.yml"))
end
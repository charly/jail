module Jail
  class Engine < ::Rails::Engine
    isolate_namespace Jail
  end
end

####
#### This is the engine. 
#### ..Choo choo..
####
module Railgun
  class Engine < ::Rails::Engine
    isolate_namespace Railgun
    engine_name 'railgun'
    
    config.autoload_paths += %W(#{config.root}/lib)
    
  end
end

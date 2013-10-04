####
#### This is the engine. 
#### ..Choo choo..
####
module Railgun
  class Engine < ::Rails::Engine
    isolate_namespace Railgun
    engine_name 'railgun'
    
    config.before_eager_load { |app| app.reload_routes! }
    
  end
end

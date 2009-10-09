RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"

  config.gem 'RedCloth'
  config.gem 'mislav-will_paginate', :version => '~> 2.3.11', :lib => 'will_paginate', :source => 'http://gems.github.com'

  config.action_controller.session = {
    :session_key => '_bbot_session',
    :secret      => "****************<YOUR SECRET HERE>****************"
  }
end

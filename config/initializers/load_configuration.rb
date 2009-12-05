APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/configuration.yml")[RAILS_ENV] || Hash.new

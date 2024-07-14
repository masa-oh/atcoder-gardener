require 'fileutils'
require 'json'

module AtcoderGardener
  class Config
    APP_NAME = 'atcoder-gardener'

    def initialize
      @config_path = File.join(Dir.home, ".#{APP_NAME}", 'config.json')
      load_config
    end

    def load_config
      unless File.exist?(@config_path)
        init_config
      end
      @config = JSON.parse(File.read(@config_path), symbolize_names: true)
    end

    def init_config
      config_dir = File.dirname(@config_path)
      FileUtils.mkdir_p(config_dir) unless Dir.exist?(config_dir)

      @config = {
        atcoder: {
          repository_path: '',
          user_id: '',
          user_email: ''
        }
      }
      File.write(@config_path, JSON.pretty_generate(@config))
    end

    def config
      @config
    end

    def save
      File.write(@config_path, JSON.pretty_generate(@config))
    end
  end
end

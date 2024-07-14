require 'thor'

module AtcoderGardener
  class CLI < Thor
    desc "init", "Initialize the configuration file"
    def init
      config = Config.new
      config.init_config
      puts "Initialized configuration file."
    end

    desc "edit", "Edit the configuration file"
    def edit
      config_path = File.join(Dir.home, ".#{Config::APP_NAME}", 'config.json')
      editor = ENV['EDITOR'] || 'vi'
      system("#{editor} #{config_path}")
    end

    desc "archive", "Archive your AC submissions"
    def archive
      config = Config.new.config
      Archiver.new(config).archive
      puts "Archived AC submissions."
    end
  end
end

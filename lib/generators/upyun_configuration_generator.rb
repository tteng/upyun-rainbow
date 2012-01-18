#coding: utf-8
require 'fileutils'
require 'rails/generators'

class UpyunConfigurationGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def generate_configuration
    copy_file "upyun_settings.rb", "config/initializers/upyun_settings.rb"
  end

end

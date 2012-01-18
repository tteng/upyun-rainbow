#coding: utf-8
require 'configatron'

module UpyunRainbow
  class Railtie < Rails::Railtie

    generators do
      require "generators/upyun_configuration_generator.rb"
    end

  end
end

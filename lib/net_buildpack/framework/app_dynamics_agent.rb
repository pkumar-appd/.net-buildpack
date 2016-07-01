require 'net_buildpack/framework'
require 'fileutils'
require 'net_buildpack/base_component'
require 'net_buildpack/runtime'
require 'net_buildpack/runtime/stack'
require 'net_buildpack/repository/configured_item'
require 'net_buildpack/util/application_cache'
require 'net_buildpack/util/format_duration'
require 'net_buildpack/util/tokenized_version'
require 'net_buildpack/util/memory_size'



module NETBuildpack::Framework

    # Encapsulates the functionality for enabling zero-touch AppDynamics support.
    class AppDynamicsAgent < NETBuildpack::BaseComponent

      def initialize(context)
        super('AppSettings Auto-reconfiguration', context)
        
         #defaults
      context[:start_script] ||= { :init => [], :run => "" }
      context[:runtime_home] ||= ''
      context[:runtime_command] ||= ''
      context[:config_vars] ||= {}
      
      @version, @uri = Mono.find_mono(@configuration)

      #concat seems to be the way to change the param
      context[:runtime_home].concat MONO_HOME
      context[:runtime_command].concat runtime_command
      
      
      end
      
      def detect
       config_files.any? ? "app_settings_auto_reconfiguration" : nil
      end

      def compile
        download(false, @droplet.sandbox, 'AppDynamics Agent')
        @droplet.copy_resources
      end
  end
end

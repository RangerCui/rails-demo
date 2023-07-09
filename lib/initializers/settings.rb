# frozen_string_literal: true

#
# Environment profile
#
class Settings < Settingslogic
  source Rails.root.join('config/settings/application.yml')
  namespace Rails.env

  #
  # Whether it is a real production environment
  # Based on the rails_production field in the configuration file, this field will be set to true only for real production environments
  #
  # @author hubery.cui
  #
  # @return [Boolean] Indicates the result
  #
  def self.production?
    Settings.rails_production
  end
end

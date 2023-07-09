# frozen_string_literal: true

#
# Apply model base classes
#
# @author hubery.cui
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  establish_connection :rails_demo_db

  # ────────────────────────────────────────────────────────────────────────────────
end

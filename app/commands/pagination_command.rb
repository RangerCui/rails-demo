# frozen_string_literal: true

#
# Paging query command
#
# @author hubery.cui
#
class PaginationCommand < ApplicationCommand
  attribute :page, required: true
  attribute :per_page, required: true

  validate :validate_page_info

  #
  # Verify the list paging parameter
  #
  # @author hubery.cui
  #
  def validate_page_info
    errors.add(:page, I18n.t('commands.invalidate_page')) if page.present? && page < 1

    errors.add(:page, I18n.t('commands.invalidate_per_page')) if per_page.present? && per_page < 1
  end
end

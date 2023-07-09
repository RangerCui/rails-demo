# frozen_string_literal: true

#
# email base class
#
# @author hubery.cui
#
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end

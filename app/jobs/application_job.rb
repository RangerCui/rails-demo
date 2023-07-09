# frozen_string_literal: true

#
# 任务基类
#
# @author hubery.cui
#
class ApplicationJob < ActiveJob::Base
  extend ActiveModel::Naming
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  #
  # Log recorder: job directly invokes the log_info method and automatically generates log files with the job name
  #
  # @author hubery.cui
  #
  #
  # @param [String] content log content
  #
  def log_info(content = '')
    @_logger ||= Logger.new("log/#{self.class.model_name.param_key}.log")
    @_uuid ||= UUID.new.generate
    @_logger.info("[#{@_uuid}] [#{content}]")
  end
end

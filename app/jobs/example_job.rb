# frozen_string_literal: true

#
# 示例功能job, 假设我是文件上传
#
class ExampleJob < ApplicationJob
  queue_as :low

  #
  # 主方法
  #
  def perform
    logger = Logger.new('log/example_job.log')
    sleep(10)
    logger.info '12345'
  end
end

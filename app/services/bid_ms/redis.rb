# frozen_string_literal: true

module BidMs
  #
  # redis服务
  #
  #
  class Redis
    # ------------------------------------ 类方法 ----------------------------------- #

    #
    # 返回redis实例
    #
    # @return [Redis] redis实例
    #
    def self.client
      @client ||= ::Redis.new(::Settings.redis.default.deep_symbolize_keys)
      @client
    end
  end
end

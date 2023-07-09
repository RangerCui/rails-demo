# frozen_string_literal: true

logger = Logger.new 'log/20220223191654573_init_province_type.rb.log'
logger.info(p('处理开始'))

Base::Province.where(name: %w[北京 上海 天津 重庆]).update(province_type: 2)
Base::Province.where(name: %w[内蒙古 广西省 宁夏省 新疆 西藏]).update(province_type: 3)
Base::Province.where(name: %w[香港 澳门]).update(province_type: 4)

logger.info(p('处理结束'))

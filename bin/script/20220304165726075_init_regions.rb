# frozen_string_literal: true

logger = Logger.new 'log/20220304165726075_init_regions.rb.log'
logger.info(p('处理开始'))

data = [
  { id: 13, name: 'Northern China', region_details: 'Beijing,Hebei,Henan,Heilongjiang,Jilin,Liaoning,Inner Mongolia,Shanxi,Tianjin', abbv: 'GC1', name_cn: '华北区', country_id: 8 },
  { id: 15, name: 'Southern China', region_details: 'Fujian,Guangdong,Guangxi,Hainan,Hubei,Hunan,Jiangxi', abbv: 'GC3', name_cn: '华南区', country_id: 8 },
  { id: 16, name: 'Eastern China', region_details: 'Anhui,Jiangsu,Shandong,Shanghai,Zhejiang', abbv: 'GC4', name_cn: '华东区', country_id: 8 },
  { id: 26, name: 'Western China', region_details: 'Gansu,Guizhou,Ningxia,Qinghai,Shaanxi,Sichuan,Tibet,Xinjiang,Yunnan,Chongqing', abbv: 'GC5-W_China', name_cn: '华西区', country_id: 8 },
  { id: 66, name: 'overseas', region_details: 'overseas', abbv: 'GC6', name_cn: '港澳台及海外', country_id: 9 },
]

Base::Region.create!(data)

logger.info(p('处理结束'))

# frozen_string_literal: true

source 'https://gems.ruby-china.com/'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# --------------------------------- ruby version -----------------------------
ruby '2.7.3'

# --------------------------------- Rails --------------------------------
gem 'bootsnap', '~> 1.7.5', require: false # 快速启动rails
gem 'rails', '~> 6.1.4' # rails
gem 'rails-i18n', '~> 6.0.0' # rails I18n

# ---------------------------------- 配置文件 ----------------------------------
gem 'settingslogic', '~> 2.0.9' # yaml配置文件

# ---------------------------------- 服务器 ---------------------------------
gem 'puma', '~> 5.3', '>= 5.3.2' # puma服务器
gem 'rack', '~> 2.2.2' # 服务协议对接
gem 'rack-cors', '~> 1.1.1' # 服务跨域

# ---------------------------------- 接口服务 ----------------------------------
gem 'grape', '~> 1.5.3' # Restful 接口
gem 'grape-entity', '~> 0.9.0' # grape接口的对象封装
gem 'grape-middleware-logger', '~> 1.12.0' # grape日志中间件
gem 'grape-swagger', '~> 1.4.0' # grape接口文档整合
gem 'grape-swagger-entity', '~> 0.5.1' # grape-entity接口文档整合

# ----------------------------------- 逻辑层 ----------------------------------
gem 'act_form', '~> 0.4.0' # command对象封装
gem 'request_store', '~> 1.5' # 全局存储
gem 'request_store-sidekiq', '~> 0.1.0' # 全局存储sidekiq版本

# ------------------------------ 模型层 ----------------------------------
gem 'kaminari', '~> 1.2', '>= 1.2.2' # 分页插件

# ----------------------------------- 存储服务 ----------------------------------
gem 'hiredis', '~> 0.6.3' # NoSQL内存数据库(Redis)
gem 'mysql2', '~> 0.5.3' # SQL持久层数据库(Mysql)
gem 'redis', '~> 4.3' # NoSQL内存数据库(Redis)
gem 'sqlite3', '~> 1.4.2' # SQL持久层数据库(Sqlite)

# ---------------------------------- 队列服务 ----------------------------------
gem 'sidekiq', '~> 6.2' # sidekiq队列服务
gem 'sidekiq-cron', '~> 1.2' # sidekiq队列服务的定时执行插件

# ---------------------------------- 网络请求 ---------------------------------
gem 'rest-client', '~> 2.1' # A simple HTTP and REST client for Ruby

group :development, :test do
  # -------------------------------- 调试&Debug --------------------------------
  gem 'factory_bot_rails', '~> 6.2' # 部署测试数据
  gem 'pry-byebug', '~> 3.9' # Debug
  gem 'pry-rails', '~> 0.3.9' # rails runtime
  gem 'rspec-rails', '~> 5.0' # 单体测试
  gem 'shoulda-matchers', '~> 5.0' # 关联关系单元测试
  gem 'simplecov', '~> 0.21.2' # 覆盖率可视化Gem
  gem 'webmock', '~> 3.14' # WebMock
end

group :development do
  # ----------------------------------- 优化 -----------------------------------
  gem 'spring', '~> 2.1.1' # 预加载应用, 提高速度
  gem 'spring-watcher-listen', '~> 2.0.1' # 变化监听

  # ---------------------------------- 文档&注释 ---------------------------------
  gem 'annotate', '~> 3.1.1' # model注释生成
  gem 'redcarpet', '~> 3.5.1' # markdown解析器，yard中使用
  gem 'yard', '~> 0.9' # 方法文档

  # ---------------------------------- 代码规范 ----------------------------------
  gem 'overcommit', '~> 0.58' # 配置git hooks
  gem 'rubocop', '~> 1.18' # 代码静态检查
  gem 'rubocop-rails', '~> 2.11', require: false # 代码静态检查-rails
  gem 'rubocop-rspec', '~> 2.4', require: false # 代码静态检查-rspec
  gem 'rufo', '~> 0.13' # 代码格式规范

  # ----------------------------------- 依赖 -----------------------------------
  gem 'listen', '~> 3.5' # 监听文件变化(bootsnap 开发环境依赖)
end

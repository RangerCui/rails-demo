# https://rubydoc.info/gems/rspec-expectations/frames
# 这里整合了一些感觉会常用的api方法， 希望其他开发人员在开发中遇到新的api可以补充进来

describe "expectations api" do
  it '比较 测试组' do
    expect(3).to be 3
    expect(3).not_to be 4
    expect(3).to be > 2 # < <= >= 就不作示例了
    expect([1, 2, 3]).to include(1)
    expect([1, 2, 3]).to start_with(1, 2)
    expect("www.baidu.com").to start_with('www')
    expect("www.baidu.com").to end_with('com')
    expect(28.274363576453).to be_within(0.1).of(28.3)
    # be_winhin用于比较浮点数 0.1代表小数点后保留两位 of 是你的期望值， 下面是保留两位数示例
    expect(28.274363576453).to be_within(0.2).of(28.27)
  end

  it '类型/类 测试组' do
    expect('String').to be_a(String)
    expect('String').not_to be_a(Hash)
  end

  it '错误类型 测试组' do
    # 这里是方括号
    expect { 1+'xx' }.to raise_error(TypeError)
    expect { 1+'xx' }.to raise_error("String can't be coerced into Integer")
    expect { 1+'xx' }.to raise_error(TypeError, "String can't be coerced into Integer")

  end

end
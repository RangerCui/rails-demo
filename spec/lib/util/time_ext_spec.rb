require 'rails_helper'

RSpec.describe ::Util::TimeExt do
  describe "format_date 方法测试" do
    it 'Time 格式化' do
      t = ::Time.zone.local(2022, 02, 10, 23, 38, 10)
      expect(::Util::TimeExt.format_date(t)).to eq('2022-02-10')
      expect(::Util::TimeExt.format_date(t, :full)).to eq('2022-02-10 23:38:10')
      expect(::Util::TimeExt.format_date(t, :min)).to eq('2022-02-10 23:38')
      expect(::Util::TimeExt.format_date(t, :date)).to eq('2022-02-10')
      expect(::Util::TimeExt.format_date(t, :year)).to eq('2022')
      expect(::Util::TimeExt.format_date(t, :other)).to eq(nil)
    end

    it 'Date 格式化' do
      t = ::Date.new(2022, 02, 10)
      expect(::Util::TimeExt.format_date(t)).to eq('2022-02-10')
      expect(::Util::TimeExt.format_date(t, :full)).to eq('2022-02-10 00:00:00')
      expect(::Util::TimeExt.format_date(t, :min)).to eq('2022-02-10 00:00')
      expect(::Util::TimeExt.format_date(t, :date)).to eq('2022-02-10')
      expect(::Util::TimeExt.format_date(t,:year)).to eq('2022')
      expect(::Util::TimeExt.format_date(t,:other)).to eq(nil)
    end

    it 'DateTime 格式化' do
      t = ::DateTime.new(2022, 02, 10, 23, 38, 10)
      expect(::Util::TimeExt.format_date(t)).to eq('2022-02-10')
      expect(::Util::TimeExt.format_date(t, :full)).to eq('2022-02-10 23:38:10')
      expect(::Util::TimeExt.format_date(t, :min)).to eq('2022-02-10 23:38')
      expect(::Util::TimeExt.format_date(t, :date)).to eq('2022-02-10')
      expect(::Util::TimeExt.format_date(t, :year)).to eq('2022')
      expect(::Util::TimeExt.format_date(t, :other)).to eq(nil)
    end
  end
end

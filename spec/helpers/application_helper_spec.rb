require 'rails_helper'

RSpec.describe ApplicationHelper do
  include ApplicationHelper
  describe "full_title" do
    context 'page_titleが存在する場合' do
      it 'page_title-base_titleが表示される' do
        expect(full_title('Testtitle')).to eq('Testtitle - w/Dog')
      end
    end

    context 'page_titleがemptyの場合' do
      it 'base_titleのみが表示される' do
        expect(full_title('')).to eq('w/Dog')
      end
    end

    context 'page_titleがnillの場合' do
      it 'base_titleのみが表示される' do
        expect(full_title(nil)).to eq('w/Dog')
      end
    end

    context '引数が存在しない場合' do
      it 'base_titleが表示される' do
        expect(full_title).to eq('w/Dog')
      end
    end
  end
end

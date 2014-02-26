require 'spec_helper'

describe Message do
  describe 'validations' do
  	it { should validate_presence_of(:conversation_id) }
  	it { should validate_presence_of(:author_id) }
  	it { should validate_presence_of(:body) }
  end

  describe 'associations' do
  	it { should belong_to(:author).class_name('User') }
  	it { should belong_to(:conversation) }
  	it { should have_many(:subscriptions).through(:conversation) }
  end

  describe '#find_all_subscription_ids_except' do
    it 'should return the array of proper ids' do
      message = FactoryGirl.create(:message, :with_subscriptions)
      expect(lambda {
        message.send(:find_all_subscription_ids_except).with(message.author_id)
      }).to include(message.subscriptions.pluck(:id).reject{ |id| id == message.author_id })
    end
  end

  describe '#inc_unread_messages' do
    it 'should increment unread messages counter of each subscription in conversation except author\'s one' do
      message = FactoryGirl.create(:message, :with_subscriptions)
      expect(lambda {
        message.send(:inc_unread_messages) 
      }).to message.subscriptions.each { |sub| change{sub}.by(1) }
    end
  end

  describe 'subscription unread message counter incremention' do
    it { should callback(:inc_unread_messages).after(:create) }
  end
end

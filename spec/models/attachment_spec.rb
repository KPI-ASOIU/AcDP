require 'spec_helper'
include ActionDispatch::TestProcess
describe Attachment do
  describe 'associations' do
  	it { should have_one(:file) }
  	it { should have_many(:users).through(:user_has_attachments) }
  end
end
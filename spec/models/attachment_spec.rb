require 'spec_helper'

describe Attachment do
  describe 'associations' do
  	it { should have_many(:users).through(:user_has_attachments) }
  end
end
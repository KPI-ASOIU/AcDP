require 'spec_helper'

describe UserHasAccess do
  describe 'associations' do
  	it {should belong_to(:user)}
  	it {should belong_to(:document)}
  end
end

require 'spec_helper'

describe UserHasAccess do
  describe 'associations' do
  	it {should belong_to(:user).dependent(:destroy)}
  	it {should belong_to(:document).dependent(:destroy)}
  end
end

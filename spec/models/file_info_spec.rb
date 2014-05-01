require 'spec_helper'

describe FileInfo do
  describe 'associations' do
  	it {should belong_to(:document)}
  end
end

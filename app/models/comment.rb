class Comment < ActiveRecord::Base
  after_create :update_companions

  opinio

  private
  def update_companions
  	fgdf
  end
end

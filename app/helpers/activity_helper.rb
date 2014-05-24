module ActivityHelper
	def trackable_type(a)
    if !a.trackable.nil?
      t('activity.trackable.' << a.trackable_type.downcase)
    else 
      t('activity.trackable.' << a.trackable_type.downcase)
    end
  end

  def trackable_commentable_type(a)
    if !a.trackable.nil?
      t('activity.trackable.' << a.trackable.commentable_type.downcase)
    else
      t('activity.trackable.' << a.parameters[:commentable].downcase)
    end
  end

  def trackable(a)
    if !a.trackable.nil?
      a.trackable
    else
      begin
        a.trackable_type.constantize.find(a.parameters[:trackable_id])
      rescue
        nil
      end
    end
  end

  def trackable_commentable(a)
    if !a.trackable.nil?
      a.trackable.commentable
    else
      begin
        a.parameters[:commentable].constantize.find(a.parameters[:trackable_id]) 
      rescue
        nil
      end
    end
  end

  def activity_information(a)
    if !a.trackable.nil?
      a.trackable_type == 'Comment' ? a.trackable.body : a.trackable.name
    else
      a.parameters[:summary]
    end
  end

  def icon(a)
    case
    when a.key == 'comment.create'
      a.trackable_type.downcase
    when ['task.create', 'event.create'].include?(a.key)
      'plus'
    when a.key.include?('update')
      'refresh'
    when a.key.include?('destroy')
      'trash'
    end
  end
end

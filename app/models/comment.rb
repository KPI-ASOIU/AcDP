class Comment < ActiveRecord::Base
  opinio
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user },
    			params: {
            summary: Proc.new {|controller, model| model.body.truncate(30)},
            commentable: Proc.new {|controller, model| model.commentable_type },
            trackable_id: Proc.new {|controller, model| model.commentable_id },
            connected_to_users: Proc.new { |controller, model|
              target = model.commentable
              [model.author.id].concat(target.executors.nil? ? [] : target.executors.map { |e| e.id }.uniq)
                .concat(target.guests.nil? ? [] : target.guests.map { |e| e.id }.uniq)
            }
          }
end

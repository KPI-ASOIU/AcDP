module ApplicationHelper
  def semantic_class_for flash_type
    case flash_type.to_sym
      when :success
        "ui green message" # Green
      when :error
        "ui red message" # Red
      when :alert
        "ui yellow message" # Yellow
      when :notice
        "ui blue message" # Blue
      else
        flash_type.to_s
    end
  end
end

module NewsPostsHelper
  def post_roles
    if current_user.has_role?('admin') or current_user.has_role?('teacher')
      NewsPost::CATEGORIES.map { |category| [t('news.for_category.' + category), category] }
    else
      NewsPost::CATEGORIES_STUDENT.map { |category| [t('news.for_category.' + category), category] }
    end
  end
end

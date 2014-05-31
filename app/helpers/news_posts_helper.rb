module NewsPostsHelper
  def post_roles
    NewsPost::CATEGORIES.map { |category| [t('news.for_category.' + category), category] }
  end
end

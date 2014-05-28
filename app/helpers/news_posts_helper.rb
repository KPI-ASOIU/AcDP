module NewsPostsHelper
  def post_roles
    roles = User::ROLES.map { |role| [t('roles.plural.' + role), role] }
    roles.insert(0, [t('news.for_group'), 'group'])
    roles.insert(0, [t('news.global'), 'global'])
    roles
  end

  def parse_post_roles(roles)
    if roles == 0
      'group'
    elsif roles == -1
      'global'
    else
      'lol'
    end
  end
end

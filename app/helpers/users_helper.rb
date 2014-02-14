module UsersHelper
	def translate_roles(roles)
		roles.map { |role| [t('roles.' + role), role] } 
	end

	def format_roles(roles, delimteter)
		translate_roles(roles).map { |role| role[0] }.join(delimteter)
	end
end

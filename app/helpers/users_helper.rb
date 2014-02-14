module UsersHelper
	def translate_roles(roles)
		roles.map { |role| [t('roles.' + role), role] } 
	end

	def format_roles(roles, delimeter)
		translate_roles(roles).map { |role| role[0] }.join(delimeter)
	end
end

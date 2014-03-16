module Admin::GroupsHelper
	def translate_degree(degrees)
		degrees.map { |e|  [t('degree.' + e), Group::DEGREE.index(e)+1]}
	end

	def translate_forms(forms)
		forms.map { |e| [t('activerecord.attributes.group.' + e), Group::FORMS.index(e).zero?] }
	end

	def create_button (group, f)
		if group.new_record?
			f.submit :value => t('util.create_group'), :class => "btn btn-success"
		else
			f.submit :class => "btn btn-success"
		end
	end
end

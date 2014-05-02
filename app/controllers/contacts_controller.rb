class ContactsController < ApplicationController
  def create
    contact_user = User.find(params[:id])
    current_user.contacts << contact_user unless current_user.contacts.exists?(params[:id])
    redirect_to :back, notice: t('contacts.notices.add_success')
  end

  def destroy
    contact_user = User.find(params[:id])
    current_user.contacts.destroy(contact_user)
    redirect_to :back, notice: t('contacts.notices.remove_success')
  end
end

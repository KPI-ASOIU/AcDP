module Admin
  class GroupsController < AdminController
    before_action :set_group, only: [:show, :edit, :destroy, :update]

    def index
      @groups = Group.order("name").page(params[:page])
    end

    def edit
    end

    def show
    end

    def update
      if @group.update(group_params)
        redirect_to admin_groups_path, notice: t('groups.notice.updated')
      else
        render action: 'edit'
      end
    end

    def create
      @group = Group.new(group_params)
      if @group.save
        redirect_to admin_groups_path, notice: t('groups.notice.created')
      else
        render action: 'new'
      end
    end

    def new
      @group = Group.new
    end

    def destroy
      @group.destroy
      redirect_to admin_groups_path
    end

    def set_group
      @group = Group.find(params[:id])
    end

    private
    def group_params
      params.require(:group)
         .permit(:name, :start_year, :graduation_year, :speciality, :speciality_code, :full_time, :degree)
    end
  end
end

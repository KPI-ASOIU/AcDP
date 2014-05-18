module Admin
	class DoctypesController < AdminController
		before_action :set_doctype, only: [:edit, :destroy, :update]
		def index
			@doctypes=DocumentType.order("title").page(params[:page])
		end

		def show
		end

		def new
  		@doctype = DocumentType.new
		end

		def create
			@doctype=DocumentType.create(doctype_params)
			redirect_to admin_doctypes_path
		end

		def destroy
      @doctype.destroy
      redirect_to admin_doctypes_path
    end

    def update
    	if @doctype.update(title: params[:value])
        status = msg = 'ok' 
      else
        status = 'error'
        msg = @doctype.errors.full_messages.join(',')
      end

      if request.xhr?
        render :json => {
        :status => status,
        :msg => msg
      }
    end
  end

    def edit	
    end

    def set_doctype
        @doctype = DocumentType.find(params[:id])
      end

		private
      def doctype_params
      params.require(:document_type).permit(:id,:title)
    	end
	end
end
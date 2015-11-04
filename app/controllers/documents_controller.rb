class DocumentsController < ApplicationController
  def index
    if params[:id].blank?
      @docs = Document.where(parent_directory: nil, owner_id: current_user.id).page(params[:page])
      @current_folder = nil
    else
      @docs = Document.where(parent_directory: params[:id], owner_id: current_user.id).page(params[:page])
      @current_folder = Document.find_by_id_and_doc_type(params[:id], 0)
      not_found if @current_folder.nil?
    end

    @folders = @docs.select { |doc| doc.doc_type == 0 }
    @files = @docs.select { |doc| doc.doc_type == 1 }
    @shared = false
  end

  def shared
    @shared = true
    if params[:user_id].blank?
      @users = User.joins('LEFT OUTER JOIN documents ON documents.owner_id = users.id LEFT OUTER JOIN user_has_accesses ON documents.id = user_has_accesses.document_id').
               where("user_has_accesses.user_id = #{current_user.id}").
               where.not(id: current_user.id).
               uniq.
               page(params[:page])
    elsif params[:id].blank?
      @docs = Document.includes('user_has_accesses').where(parent_directory: nil, owner_id: params[:user_id], user_has_accesses: { user_id: current_user.id }).page(params[:page])
    else
      @docs = Document.includes('user_has_accesses').where(parent_directory: params[:id], user_has_accesses: { user_id: current_user.id }).page(params[:page])
      @can_edit_current_folder = UserHasAccess.where(user_id: current_user.id, document_id: params[:id]).first.access_type
      @current_folder = Document.where(id: params[:id]).first
    end

    @formats = FileInfo.uniq.pluck(:file_content_type)
    @types = DocumentType.pluck(:title)

    unless @docs.nil?
      @folders = @docs.select { |doc| doc.doc_type == 0 }
      @files = @docs.select { |doc| doc.doc_type == 1 }
      render 'index'
    end
    @types=DocumentType.pluck(:title)
    @formats=FileInfo.uniq.pluck(:file_content_type)
  end

  def new
    if params[:documents][:doctype] == 'folder'
      if create_document(0).save
        flash[:notice] = t('documents.folder_creation_success')
      else
        flash[:error] = t('documents.error_create')
      end
    elsif params[:documents][:new_file].blank?
      doc = create_document(1)
      if doc.save!
        flash[:notice] = t('documents.file_add_success')
      else
        flash[:error] = t('documents.error_create')
      end
    else
      doc = create_document(1)
      if save_file(doc)
        flash[:notice] = t('documents.file_add_success')
      else
        flash[:error] = t('documents.error_create')
      end
    end
    # TODO (dkalpakchi): change this to appropriate index handling
    Document.import force:true
    if request.referer.split('/')[3] == 'conversations'
      render json: {id: doc.id}
    else
      redirect_to action: 'index'
    end
  end

  def save_file(doc)
    file = FileInfo.new
    file.document_id = doc.id
    file.file = params[:documents][:new_file]
    doc.save_with_parameter(file)
  end

  def create_document(type)
    doc = Document.new
    doc.title = params[:documents][:new_doc_title]
    doc.description = params[:documents][:description] if params[:documents][:description]
    doc.doc_type = type
    doc.parent_directory = params[:id]
    doc.owner_id = current_user.id

    owner_access = UserHasAccess.new
    owner_access.user_id = current_user.id
    owner_access.access_type = 1
    doc.save_with_parameter(owner_access)

    doc
  end

  def update
    @doc = Document.find(params[:id])
    if params[:document_types].present?
      @doc.document_types = params[:document_types].map {|t| DocumentType.find_or_create_by(title: t) }
    end
    if params[:document][:for_roles]
      params[:document][:for_roles] = User.roles_to_int(params[:document][:for_roles])
    end

    if @doc.update_attributes(document_params)
      redirect_to documents_path
    else
      render json: {
        :error => "Wrong params!"
      }
    end
  end

  def delete
    doc = Document.find(params[:delete_id])
    if !doc.nil? and doc.destroy
      flash[:notice] = t('documents.flash_removed_item')
    end
    redirect_to action: 'index'
  end

  def delete_file
    stat = 'error'

    if !params[:delete_id].blank?
      doc = Document.find(params[:delete_id])
      stat = 'ok' if doc.file_info.destroy
    end

    respond_to do |format|
      format.json { render json: { status: stat, doc: doc ? doc.id : 0 } }
    end
  end

  def change_file
    stat = 'error'
    if !params[:document][:doc_id].blank? and !params[:document][:new_file].blank?
      doc = Document.find(params[:document][:doc_id])
      if doc.file_info
        doc.file_info.file = params[:document][:new_file]
      else
        doc.file_info = FileInfo.new(document_id: params[:document][:doc_id], file: params[:document][:new_file])
      end
      stat = 'ok' if doc.file_info.save
    end

    respond_to do |format|
      format.json { render json: { status: stat, doc: doc ? doc.id : 0, title: doc.file_info.file_file_name, url: doc.file_info.file.url(:original, false) } }
    end
  end

  def search
    d = Document.__elasticsearch__
    r = d.search(params[:query])
    doc_ids = r.results.response.map {|r| r.id }
    @files = Document.where(id: doc_ids)
    respond_to do |format|
      format.js
      format.json { render json: @files.to_json.html_safe }
    end
  end

  def elastic_search
  end

  def extended_search
  end

  def get_file_doc_id
    @file = FileInfo.find_by(file_file_name: params[:file_name], file_file_size: params[:file_size])
    respond_to do |format|
      format.json { render json: { doc_id: @file.document_id } }
    end
  end

  def sidebar_info
    @doc = Document.find(params[:id])
    respond_to do |format|
      format.js {}
    end
  end

  private
  def document_params
    params.require(:document)
      .permit(:title, :description, :for_roles)
  end
end

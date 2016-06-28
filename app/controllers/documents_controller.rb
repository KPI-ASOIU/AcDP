##
# This class represents a controller for all document related tasks.

class DocumentsController < ApplicationController
  def index
    if params[:id].blank?
      @docs = Document.where(parent_directory: nil, owner_id: current_user.id)
      @current_folder = nil
    else
      @docs = Document.where(parent_directory: params[:id], owner_id: current_user.id)
      @current_folder = Document.find_by_id_and_doc_type(params[:id], 0)
      not_found if @current_folder.nil?
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def shared
    @docs_personal_shared = current_user.personal_shared_documents

    # TODO (dkalpakchi): maybe this can be done via db query
    @docs_for_roles = current_user.role_shared_documents

    @docs = @docs_personal_shared.push(*@docs_for_roles).uniq

    unless @docs.nil?
      @folders = @docs.select { |doc| doc.doc_type == 0 }
      @files = @docs.select { |doc| doc.doc_type == 1 }
    end

    respond_to do |format|
      format.js
    end
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
    params[:document][:for_roles] = User.roles_to_int(params[:document][:for_roles] || [])

    UserHasAccess.where(document: @doc).update_all(access_type: 0)

    if params[:personal_shared].present?
      # TODO: as create_or_update is deprecated, this method seems to be the only suitable,
      #       find out how to fix this to one DB query easily
      User.where(id: params[:personal_shared]).map { |u|
        UserHasAccess.find_or_create_by(document: @doc, user: u)
      }.each{|uha|
        uha.update_attributes(access_type: 2)
      }

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
    doc = Document.find(params[:id])
    current = doc.parent_directory
    puts current
    if !doc.nil? and doc.destroy
      flash[:notice] = t('documents.flash_removed_item')
    end
    redirect_to action: 'index', id: current
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
    @files = nil

    if params[:query].present?
      @files = elastic_search
    end

    if params[:extended_search].present?
      extended_search(@files)
    end

    respond_to do |format|
      format.js
      format.json { render json: @files.to_json.html_safe }
    end
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
  def elastic_search
    d = Document.__elasticsearch__
    r = d.search(params[:query])
    doc_ids = r.results.response.map {|r| r.id }
    if params[:current].present?
      @files = Document.where(id: doc_ids, parent_directory: params[:current])
    else
      @files = Document.where(id: doc_ids)
    end
    @files
  end

  def extended_search(files)
    ext_params = params[:extended_search]
  end

  def document_params
    params.require(:document)
      .permit(:title, :description, :for_roles)
  end
end

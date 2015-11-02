class DocumentsController < ApplicationController
  def index
    if !params[:q].blank?
      params[:search_by] = 'title' unless ['title', 'tags', 'title tags', 'description'].include?(params[:search_by])
      @docs = Document.where(owner_id: current_user.id).page(params[:page]).with_matched_field(params[:q], params[:search_by])
    else
      if params[:id].blank?
        @docs = Document.where(parent_directory: nil, owner_id: current_user.id).page(params[:page])
      else
        @docs = Document.where(parent_directory: params[:id], owner_id: current_user.id).page(params[:page])
      end
    end

    if params[:id].blank?
      @current_folder = nil
    else
      @current_folder = Document.where(id: params[:id]).first
    end

    params[:search_by] ||= 'title'
    @folders = @docs.select { |doc| doc.doc_type == 0 }
    @files = @docs.select { |doc| doc.doc_type == 1 }
    @shared = false
    @formats = FileInfo.uniq.pluck(:file_content_type)
    @types = DocumentType.pluck(:title)
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

  def jstree
    @docs = Document.where(params[:docdir] == 'dir' ? { doc_type: 0 } : {}).
      where(parent_directory: (!params[:id].blank? && params[:id] != '#') ? params[:id] : nil)
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
        doc.__elasticsearch__.index_document
        flash[:notice] = t('documents.file_add_success')
      else
        flash[:error] = t('documents.error_create')
      end
    else
      doc = create_document(1)
      if save_file(doc)
        doc.__elasticsearch__.index_document
        flash[:notice] = t('documents.file_add_success')
      else
        flash[:error] = t('documents.error_create')
      end
    end
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
    doc.date_created = Time.now
    doc.date_updated = Time.now

    owner_access = UserHasAccess.new
    owner_access.user_id = current_user.id
    owner_access.access_type = 1
    doc.save_with_parameter(owner_access)

    doc
  end

  def update
    doc = Document.find(params[:pk])

    if doc.nil?
      stat = 'error'
      msg = t('documents.error_document_not_found')
    else
      if params[:name] == 'tags'
        doc.tags = params[:value].blank? ? '' : params[:value].join(',')
      elsif params[:name] == 'desc'
        doc.description = params[:value]
      elsif params[:name] == 'title'
        doc.title = params[:value]
      elsif !params[:target_pk].blank?
        doc.parent_directory = params[:target_pk] == 'root' ? nil : params[:target_pk]
      end

      doc.date_updated = Time.now

      if doc.save
        stat = msg = 'ok'
      else
        stat = 'error'
        msg = doc.errors.full_messages.join(',')
      end
    end

    if request.xhr?
      render :json => {
          :status => stat,
          :msg => msg,
          :doc_id => doc.nil? ? -1 : doc.id
      }
    else
      redirect_to action: 'index', id: params[:folder_id]
    end
  end

  def update_lists
    stat = msg = 'ok'
    @doc = nil

    if params[:pk].blank?
      stat = 'error'
      msg = t('documents.error_not_recognized')
    else
      @doc = Document.find(params[:pk])

      if @doc.nil?
        stat = 'error'
        msg = t('documents.error_document_not_found')
      elsif !params[:access_type].blank? and !params[:receiver_ids].blank? and params[:receiver_ids].length > 0
        params[:receiver_ids].each do |user|
          access = UserHasAccess.new(document_id: @doc.id, user_id: user, access_type: params[:access_type])
          unless access.save
            stat = 'error'
            msg = access.errors.full_messages.join(',')
          end
        end
      elsif !params[:access_id].blank?
        unless UserHasAccess.destroy(params[:access_id])
          stat = 'error'
          msg = t('documents.error_not_recognized')
        end

      elsif !params[:type_id].blank?
        unless DocumentHasType.destroy(params[:type_id])
          stat = 'error'
          msg = t('documents.error_not_recognized')
        end
      elsif !params[:types_ids].blank? and params[:types_ids].length > 0
        params[:types_ids].each do |type|
          doc_type = DocumentHasType.new(document_id: @doc.id, document_type_id: type)
          unless doc_type.save
            stat = 'error'
            msg = doc_type.errors.full_messages.join(',')
          end
        end
      end
    end

    if stat != 'error'
      @doc.update_attribute(:date_updated, Time.now)
    end

    @access_type = params[:access_type]
    respond_to do |format|
      format.js   {}
      format.json { render json: { :status => stat,
          :msg => msg
        }
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

  def get_file_doc_id
    @file = FileInfo.find_by(file_file_name: params[:file_name], file_file_size: params[:file_size])
    respond_to do |format|
      format.json { render json: { doc_id: @file.document_id } }
    end
  end

  def sidebar_info
    @doc = Document.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
end

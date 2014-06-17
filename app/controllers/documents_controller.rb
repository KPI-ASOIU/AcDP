class DocumentsController < ApplicationController
  def index
    if !params[:q].blank?
      params[:search_by] = 'title' unless ['title', 'tags', 'title tags', 'description'].include?(params[:search_by])
      @docs = Document.page(params[:page]).with_matched_field(params[:q], params[:search_by]).are_owned_or_shared(params[:are_owned], params[:are_shared], current_user.id).before_date(params[:before_date]).after_date(params[:after_date]).with_types(params[:type_ids])
    else
      params[:a_file]=params[:a_folder]=params[:are_owned]=params[:are_shared]=true
      if params[:id].blank?
        @docs = Document.where(parent_directory: nil, owner_id: current_user.id).page(params[:page])
      else
        @docs = Document.where(parent_directory: params[:id], owner_id: current_user.id)
      end
    end

    if params[:id].blank?
      @current_folder = nil
    else
      @current_folder = Document.where(id: params[:id]).first
    end

    params[:search_by] ||= 'title'
    @folders = @docs.select { |doc| doc.doc_type == 0 } if params[:a_folder]
    @files = @docs.select { |doc| doc.doc_type == 1 } if params[:a_file]
    @shared = false
    @formats=Document.select { |doc| doc.doc_type == 1 }
    @types=DocumentType.all
  end

  def shared
    @shared = true
    if params[:user_id].blank?
      @users = User.where.not(id: current_user.id).page(params[:page])
    elsif params[:id].blank?
      @docs = Document.includes('user_has_accesses').where(parent_directory: nil, owner_id: params[:user_id], user_has_accesses: { user_id: current_user.id }).page(params[:page])
    else
      @docs = Document.includes('user_has_accesses').where(parent_directory: params[:id], user_has_accesses: { user_id: current_user.id }).page(params[:page])
      @can_edit_current_folder = UserHasAccess.where(user_id: current_user.id, document_id: params[:id]).first.access_type
      @current_folder = Document.where(id: params[:id]).first
    end

    unless @docs.nil?
      @folders = @docs.select { |doc| doc.doc_type == 0 }
      @files = @docs.select { |doc| doc.doc_type == 1 }
      render 'index'
    end
  end

  def jstree
    if params[:id] and params[:id] != '#'
      @docs = Document.where(parent_directory: params[:id])
    else
      @docs = Document.where(parent_directory: nil)
    end
  end

  def new
    if params[:documents][:new_file].blank?
      if create_document(0).save
        flash[:notice] = t('documents.folder_creation_success')
      end
    else
      if save_file create_document 1
        flash[:notice] = t('documents.file_add_success')
      end
    end
    redirect_to action: 'index'
  end

  def save_file(doc)
    file = FileInfo.new
    file.document_id = doc.id
    file.file = params[:documents][:new_file]
    doc.save_with_file file
  end

  def create_document(type)
    doc = Document.new
    doc.title = params[:documents][:new_doc_title]
    doc.doc_type = type
    doc.parent_directory = params[:id]
    doc.owner_id = current_user.id
    doc.date_created = Time.now
    doc.date_updated = Time.now

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
      end

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
end
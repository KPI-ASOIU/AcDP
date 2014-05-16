class DocumentsController < ApplicationController
  def index
    if params[:id].nil?
      @docs = Document.where(parent_directory: nil, owner_id: current_user.id).page(params[:page])
      @current_folder = nil
    else
      @docs = Document.where(parent_directory: params[:id], owner_id: current_user.id).page(params[:page])
      @current_folder = Document.where(id: params[:id]).first
    end

    @folders = @docs.select { |doc| doc.doc_type == 0 }
    @files = @docs.select { |doc| doc.doc_type == 1 }
    @shared = false
  end

  def shared
    @shared = true
    if params[:user_id].nil?
      @users = User.where.not(id: current_user.id).page(params[:page])
    elsif params[:id].nil?
      @docs = Document.includes('user_has_accesses').where(parent_directory: nil, owner_id: params[:user_id], user_has_accesses: { user_id: current_user.id }).page(params[:page])
    else
      @docs = Document.includes('user_has_accesses').where(parent_directory: params[:id], user_has_accesses: { user_id: current_user.id }).page(params[:page])
    end

    if !@docs.nil?
      @folders = @docs.select { |doc| doc.doc_type == 0 }
      @files = @docs.select { |doc| doc.doc_type == 1 }
      render 'index'
    end
  end

  def new
    if params[:documents][:new_file].nil?
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
        doc.tags = params[:value].join(',')
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

  def update_access
    stat = msg = 'ok'

    if params[:pk].nil?
      stat = 'error'
      msg = t('documents.error_not_recognized')
    else
      @doc = Document.find(params[:pk])

      if @doc.nil?
        stat = 'error'
        msg = t('documents.error_document_not_found')
      elsif !params[:access_type].nil? && !params[:receiver_ids].nil? && params[:receiver_ids].length > 0
        params[:receiver_ids].each do |user|
          access = UserHasAccess.new(document_id: @doc.id, user_id: user, access_type: params[:access_type])
          if !access.save
            stat = 'error'
            msg = access.errors.full_messages.join(',')
          end
        end

      elsif !params[:access_id].nil?
        if !UserHasAccess.destroy(params[:access_id])
          stat = 'error'
          msg = t('documents.error_not_recognized')
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
class DocumentsController < ApplicationController
  def index
    @folders = Document.where(doc_type: 0)
    @files = FileInfo.all
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
    doc.owner_id = current_user.id
    doc.date_created = Time.now
    doc.date_updated = Time.now

    doc
  end

  def delete

  end
end

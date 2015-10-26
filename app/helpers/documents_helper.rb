module DocumentsHelper
  def doc_format_icon(file)
    if file.file_info.present?
      case File.extname(file.file_info.file.path)
      when '.docx', '.doc'
        'file blue word outline icon'
      when '.xls', '.xlsx'
        'file green excel outline icon'
      when '.ppt', '.pptx'
        'file orange powerpoint outline icon'
      when '.pdf'
        'file red pdf outline icon'
      else
        'file outline icon'
      end
    else
      'file outline icon'
    end
  end
end

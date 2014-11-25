module DocumentsHelper
  def doc_format_icon(file)
    case File.extname(file.file_info.file.path)
    when '.docx'
      'file teal icon'
    when '.doc'
      'file blue icon'
    when '.xls', '.xlsx'
      'file green icon'
    when '.ppt', '.pptx'
      'file orange icon'
    when '.pdf'
      'file red icon'
    else
      'file icon'
    end
  end
end

#!/usr/bin/ruby
# @Author: Dmitriy Kalpakchi
# @Date:   2016-06-28 18:18:16
# @Last Modified by:   Dmitriy Kalpakchi
# @Last Modified time: 2016-06-28 18:18:18

module Paperclip
  class Attachment
    def save
      flush_deletes unless @options[:keep_old_files]
      flush_writes
      @dirty = false
      true
    end
  end
end
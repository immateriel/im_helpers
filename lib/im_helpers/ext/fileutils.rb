require 'fileutils'
module FileUtils
  def self.mkdir_p_with_proc(dir,proc=nil)
    parent=File.expand_path("..", dir)

    unless File.exist?(parent)
      mkdir_p_with_proc(parent,proc)
    end

    unless File.exist?(dir)
      FileUtils.mkdir(dir)
      if proc
        proc.call(dir)
      end
    end
    dir
  end

end
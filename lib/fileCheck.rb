class FileCheck

 @@filepath = nil

  def self.filepath=(path=nil)
      @@filepath = File.join(APP_ROOT, path)
  end

  def self.file_exist?
       if @@filepath && File.exists?(@@filepath)
          return true
       else
          return false
       end
  end

  def self.file_usable?
      return false unless @@filepath
      return false unless File.exists?(@@filepath)
      return false unless File.readable?(@@filepath)
      return false unless File.writable?(@@filepath)
      return true
  end

  def self.create_file
      file = File.open('output.agp', 'a') 
      return file
  end

  def self.read_file
      file = IO.readlines('mira_output_contiguator_scaffold.fasta') unless file_exist?
      return file
  end


end

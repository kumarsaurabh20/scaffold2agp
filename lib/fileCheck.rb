class FileCheck

 def self.file_exist?
       if @@file_fasta && File.exists?(@@file_fasta) 
          return true
       else
          return false
       end
  end

  def self.file_usable?
      return false unless @@file_fasta
      return false unless File.exists?(@@file_fasta)
      return false unless File.readable?(@@file_fasta)
      return false unless File.writable?(@@file_fasta)
      return true
  end

  def self.create_file
      File.open('output.agp', 'a') unless file_exist?
      return file_usuable?      
  end

  def self.read_fasta_file
      file_fasta = File.basename(Dir[File.join(File.expand_path(APP_ROOT), "*.fasta")].to_s)
      file = IO.readlines(file_fasta)
      return file
  end

  def self.read_mapped_file
      file_mapped = File.basename(Dir[File.join(File.expand_path(APP_ROOT), "*.txt") ].to_s)
      file = IO.readlines(file_mapped)
      return file
  end

end

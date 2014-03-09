require 'fileCheck'
require 'date'
class Convert

     class Config
           @@actions = ['convert','help','quit']
           def self.actions; @@actions; end  
     end

 VERSION = "agp-version	2.0"
 ASSEMBLY_DATE = Date.new(2013,10,13)
 COMPONENT_BEG = "1"
 COMPONENT_TYPE_CONTIG = "D"
 COMPONENT_TYPE_GAP = "N"
 GAP_TYPE = "scaffold"
 LINKAGE = "yes"

 attr_accessor :contig_id, :contig_beg, :contig_end, :gap_start, :gap_end, :gap_diff, :organism, :tax_id, 
               :assembly_name, :genome_center, :description, :scaffold_id, :orientation, :label


  def initialize
         @contig_id   = []
         @contig_beg  = []
         @contig_end  = []  
         @gap_start   = []
         @gap_end     = []
         @gap_diff    = [] 
         @orientation = []
  end

  def agp_defaults(args={})
       @organism      = args[:organism]      || ""
       @tax_id        = args[:tax_id]        || ""
       @assembly_name = args[:assembly_name] || ""
       @genome_center = args[:genome_center] || ""
       @description   = args[:description]   || ""
       @scaffold_id   = args[:scaffold_id]   || ""
  end

  def start!
     intro       
	     result = nil
	     until result == :quit 
                  action = get_action
                  result = do_action(action)                                                                
             end
     conclusion
  end

  def get_action
      action = nil
	 until Convert::Config.actions.include?(action)
	      puts "Actions: " + Convert::Config.actions.join(", ") if action
	      print "scaffold2agp->> "
	      user_input = gets.chomp
	      action = user_input.downcase.strip
	 end
    return action      
  end

  def user_input
      args = {}

      print "Name the organism?(agp constant): "
      args[:organism] = gets.chomp

      print "Taxonomy id of the organism?(agp constant): "
      args[:tax_id] = gets.chomp

      print "Assembly name?(agp constant): "
      args[:assembly_name] = gets.chomp

      print "Genome center?(agp constant): "
      args[:genome_center] = gets.chomp

      print "Any description?(agp constant): "
      args[:description] = gets.chomp

      print "Scaffold ID?(Object_id e.g. Scaffold_HALO_1): "
      args[:scaffold_id] = gets.chomp

      return args
  end

  def do_action(actions)

      case actions
   
      when "convert"
            conversion

      when "help"
           help

      when "quit"
           return :quit

      else
         puts "undefined action. Check again!!"
      end


  end

  def conversion
      args = user_input
      agp_defaults(args)
      output = break_scaffold
      @label = output.shift
      contigs = output.shift
      contig_string = output.shift.to_s
      contigs_string_downcase = output.to_s
      print_file(contigs, contig_string, contigs_string_downcase) 
  end

  def get_orientation
        orientation = []

	     #file = IO.readlines('contiguator_orientation_output_sample.txt') 
	     file = FileCheck.read_mapped_file
             file.each do |element|     
		     if element.include?("rep")
			orientation << "-" 
		     else  
			orientation << "+"
		     end
	     end
	return orientation
   end

  def break_scaffold

      #file = FileCheck.read_fasta_file
      file = FileCheck.read_fasta_file
      label = file.shift
      join_file_elements = file.join()
      contig_string = join_file_elements.delete "\n"
      contigs = contig_string.split(/[N]+/)
      contigs_string_downcase = contig_string.downcase
      
      return label, contigs, contig_string, contigs_string_downcase
  end

  def print_file(contigs, contig_string, contigs_string_downcase)
      gap_start = []

      #gaps = q.scan(/nnnnnnnnnn+/)  #creates array of string that matches the pattern
      contigs_string_downcase.scan(/nnnnnnnnnn+/) do |gap|
         @gap_start << contigs_string_downcase.index(gap) 
	 @gap_end << "#{contigs_string_downcase.index(gap)}".to_i + "#{gap}".length.to_i - 1
         contigs_string_downcase = contigs_string_downcase.sub(gap, "N" * gap.length)
      end

      contigs.each do |con|    
	        @contig_beg << contigs_string_downcase.index(con.downcase)
      end

      for i in 1..contigs.length 
         @contig_id << "#{@assembly_name}#{@tax_id}"+"_" +"#{i}"     
      end

      for i in 0..contigs.length
          @contig_end << @contig_beg[i].to_i + "#{contigs[i]}".length.to_i - 1
      end

      
      File.open('halochloris.agp', 'a') do |file|

         file.puts "##" + "#{VERSION}"
         file.puts "# ORGANISM: "      + "#{@organism}"
         file.puts "# TAX ID: "        + "#{@tax_id}"
         file.puts "# ASSEMBLY NAME: " + "#{@assembly_name}"
         file.puts "# ASSEMBLY DATE: " + "#{ASSEMBLY_DATE}"
         file.puts "# GENOME CENTER: " + "#{@genome_center}"
         file.puts "# DESCRIPTION: "   + "#{@description}"
	  
          n = 0    
          for i in 0..contigs.length - 1
         
          orientation = get_orientation 
         
          @gap_diff << "#{@gap_end[i]}".to_i - "#{@gap_start[i]}".to_i + 1
          component_end = "#{contigs[i]}".length.to_i      
          
          n = n + 1          
 
	  file.puts "#{[scaffold_id,contig_beg[i],contig_end[i], n, COMPONENT_TYPE_CONTIG, contig_id[i], COMPONENT_BEG, component_end, orientation[i] ].join("\t")}" 
          
          file.puts "#{[@scaffold_id, @gap_start[i], @gap_end[i], n+1, COMPONENT_TYPE_GAP, @gap_diff[i], GAP_TYPE, LINKAGE, 'align_genus'].join("\t")}" unless contigs[i] == contigs.last
                    
          n = n + 1
   
          end
	      
      end
    
     conclude

  end


private

  def help
      puts "Coming Soon!!"
  end


  def intro
      puts  " "
      puts  " "
      print "  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \n"
      puts  "*                                                                              *"
      print "*                       Welcome to scaffold2agp program                        *\n"
      print "* An interactive Ruby program to convert scaffold file in fasta in to .agp file*\n"
      puts  "*                                                                              *"
      puts  "*                                                                              *"
      print "  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * \n"
      puts  " "
      puts  " "
 end

 def conclusion
     puts "\n\n      ### Goodbye and Thank you for using scaffold2agp ###\n\n"
     puts  "                      Kumar Saurabh Singh                        "
     puts  "                     kumarsaurabh20@gmail.com                    "
     puts  "                   ############################                  "
 end

 def conclude
     puts "File has been successfully written. Check the root folder!!!"
 end

end

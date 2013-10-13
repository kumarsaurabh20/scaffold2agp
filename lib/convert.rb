require 'fileCheck'
class Convert


 def file_read
     
     # variables
    version = "agp-version	2.0"
    organism = "Halochloris"
    tax_id = "2505"
    assembly_name = "HALO"
    assembly_date = Date.new(2013,10,13)
    genome_center = "NCBI"
    description = "extremophile gamma proteobacterium"
    scaffold_id = "HALO_scaffold1"


    object = "" #identifier for object being assembled
    object_beg = "" #starting corrdinates of the component/gap on the object in column one
    object_end = "" #ending corrdinates of the component/gap on the object in column one
    part_number = "" #line count for the component/gaps that make up the object in column one
    component_type = "" #Sequencing status of the component[A=Active finishing, D=draft HTG, F=finished HTG]
                        #[G=whole genome finishing, N=gap with specified size, O=other sequence, P=predraft]
                        #[U=gap of unknown size, W=WGS contig]
    component_id = "" #if comp_type is !=N, this is a unique identifier for the sequence component
                      #contributing in the object in col one. 
    gap_length = "" #If comp_type is = N. The length of gap
    component_beg = "" #if col_type != N, represents beg of part of the component seq that contributes to the object
                          
    gap_type = "" #if col_type=N The combination of gap type and linkage indicates weather the gap is captured or not
                  #In some cases gaps types are assigned biological values
                  #fragment:gap btn two contigs, clone:gap btn two clone that do not overlap, contig:gap btn clone 
                  #cotig also called "layout gap", centromere:a gap inserted for centromere, short_arm:gap 
                  #inserted at the start of an acrocentric chromosome.
                  #Hetrochromatin:a gap inserted for an especially large region of heterochromatic sequence(may also)
                  #include centromere. Telomere:a gap inserted for telomere, repeat:an unresolve repeat 

     component_end = "" #if col_type!=N end part of component contributing in object in col one

     linkage = "" #if col_type=N, indicates if there is evidence of linkage betn the adjacent lines values:yes or No

     orientation = "" #if col_type!= N, specifies orientation of component relative to object on col one +/-



        x = IO.readlines('mira_output_contiguator_scaffold.fasta')
	    #x.class #Array
	label = x.shift
	

        y = x.join()
	    #y.class #String
	w = y.delete "\n"
	contigs = w.split(/[N]+/)
	#contigs.class #array
	#contigs.length # total number of contigs(elements)
	#get individual contig length from here
	 q = w.downcase
         n_count = 0
	 gaps = []
	 scaffold_base_count = 0
         contig_id = []
         contig_beg = []
         contig_end = []

         gaps = q.scan(/[n]+/)  #creates array of string that matches the pattern

         posn = []
         gaps.each do |gap|

         posn << q.index(gap)
         q = q.sub(gap, "*")
         end

         contigs.each do |con|
         contig_beg << w.index(con)
         end

      
      for i in 1..contigs.length 

         contig_id << "#{assembly_name}#{tax_id}"+"_" +"#{i}"
         n = i - 1
         contig_end << contig_beg[n].to_i + "#{contigs[n]}".length.to_i
          
      end

      
      File.open("test.agp", "a") do |file|
         file.puts "##" + "#{version}"
         file.puts "# ORGANISM: "      + "#{organism}"
         file.puts "# TAX ID: "        + "#{tax_id}"
         file.puts "# ASSEMBLY NAME: " + "#{assembly_name}"
         file.puts "# ASSEMBLY DATE: " + "#{assembly_date}"
         file.puts "# GENOME CENTER: " + "#{genome_center}"
         file.puts "# DESCRIPTION: "   + "#{description}"
	      for i in 0..contigs.length + gaps.length    
	      file.puts "#{[scaffold_id,contig_beg[i],contig_end[i]].join("\t")}"
	      end
      end
 
      puts contig_id
      #puts contigs
      #puts contig_beg.inspect
      #puts contig_end.inspect
      #puts "The scaffold ID is: #{label}"
      #puts "The scaffold size is: #{w.length}"   
      #puts "#{scaffold_base_count}"
      #puts "#{n_count}"
      
      #puts contigs[0].length
      #puts gaps[0].length
      #puts posn.inspect
      

      #puts "length of 1st gap: " + "#{posn[0]}" + " - " + "#{posn[0] + gaps[0].length - 1}"
      #puts "length of 2nd gap: " + "#{posn[1]}" + " - " + "#{posn[1] + gaps[1].length - 1}"
      #puts "length of 3rd gap: " + "#{posn[2]}" + " - " + "#{posn[2] + gaps[2].length - 1}"
      #puts "length of 4th gap: " + "#{posn[3]}" + " - " + "#{posn[3] + gaps[3].length - 1}"
      #puts "length of 5th gap: " + "#{posn[4]}" + " - " + "#{posn[4] + gaps[4].length - 1}"


     
      
 end






end

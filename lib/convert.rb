require 'fileCheck'
class Convert


 def file_read
     
    x = IO.readlines('test_file.fasta')
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

         gaps = q.scan(/[n]+/)  #creates array of string that matches the pattern

         posn = []
         gaps.each do |gap|

         posn << q.index(gap)
         q = q.sub(gap, "*")

         end


      puts "The scaffold ID is: #{label}"
      puts "The scaffold size is: #{w.length}"   
      #puts "#{scaffold_base_count}"
      #puts "#{n_count}"
      
      #puts contigs
      #puts gaps
      #puts posn.inspect
      

      puts "length of 1st gap: " + "#{posn[0]}" + " - " + "#{posn[0] + gaps[0].length - 1}"
      puts "length of 2nd gap: " + "#{posn[1]}" + " - " + "#{posn[1] + gaps[1].length - 1}"
      puts "length of 3rd gap: " + "#{posn[2]}" + " - " + "#{posn[2] + gaps[2].length - 1}"
      puts "length of 4th gap: " + "#{posn[3]}" + " - " + "#{posn[3] + gaps[3].length - 1}"
      puts "length of 5th gap: " + "#{posn[4]}" + " - " + "#{posn[4] + gaps[4].length - 1}"
   
    


 end






end

require 'fileCheck'
class Convert


 def file_read
     
    x = IO.readlines('test_file.fasta')
    x.class #String
    x.shift
    y = x.join()
    y.class #String
    w = y.delete "\n"
    contigs = w.split(/[N]+/)
    contigs.class #array
    contigs.length # total number of contigs(elements)
    #get individual contig length from here
   
    


 end






end

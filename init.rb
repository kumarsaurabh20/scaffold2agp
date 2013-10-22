#A ruby interactive program to convert scaffold fasta formatted file in to .agp specification file
#under construction

#File.expand_path('../.')

APP_ROOT = File.dirname(__FILE__)
$:.unshift(File.join(APP_ROOT, 'lib'))

require 'convert'

convert = Convert.new
convert.start!



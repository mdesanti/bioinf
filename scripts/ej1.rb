require 'bio'
require 'pry'

INPUT_FILE_PATH = ARGV.first
OUTPUT_FILE_PATH = ARGV.last

ff = Bio::GenBank.open(INPUT_FILE_PATH)

# iterates over each GenBank entry
File.open(OUTPUT_FILE_PATH, 'w') do |f|
  ff.each_entry do |gb|
    f.write(gb.to_biosequence.output_fasta)
  end
end
require 'bio'
require 'pry'

INPUT_FILE_PATH = ARGV.first
OUTPUT_FILE_PATH = ARGV.last

# To run an actual BLAST analysis:
#   1. create a BLAST factory
remote_blast_factory = Bio::Blast.remote('blastp', 'swissprot', '-e 0.0001', 'genomenet')

ff = Bio::FlatFile.open(Bio::FastaFormat, INPUT_FILE_PATH)

# iterates over each GenBank entry
File.open(OUTPUT_FILE_PATH, 'w') do |f|
  ff.each_entry do |gb|
    puts "Querying remote server..."
    report = remote_blast_factory.query(gb.seq)
    binding.pry
    puts "Got response... Saving to file..."
    report.hits.each_with_index do |hit, hit_index|
      f.puts '------------------------------------------------'
      f.puts "Hit #{hit_index}"
      f.puts hit.accession  
      f.puts hit.definition
      f.puts " - Query length: #{hit.len}"
      f.puts " - Number of identities: #{hit.identity}"
      f.puts " - Length of Overlapping region: #{hit.overlap}"
      binding.pry
      f.puts " - % Overlapping: #{hit.percent_identity}"
      f.puts " - Query sequence: #{hit.query_seq}"
      f.puts " - Subject sequence: #{hit.target_seq}"
      hit.hsps.each_with_index do |hsps, hsps_index|
        f.puts " - Bit score: #{hsps.bit_score}"
        f.puts " - Gaps: #{hsps.gaps}"
      end
    end
  end
end
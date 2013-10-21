require 'bio'
require 'pry'


INPUT_FILE_PATH = ARGV[0]
OUTPUT_FILE_PATH = ARGV[1]
SEARCH_FOR = ARGV[2]

Bio::NCBI.default_email = "something@gmail.com"

ncbi = Bio::NCBI::REST::EFetch.new
File.open(OUTPUT_FILE_PATH, 'w') do |f|
  Bio::Blast.reports(File.new(INPUT_FILE_PATH)) do |report|
    report.iterations.each do |itr|
      itr.hits.each do |hit|
        if hit.definition.downcase.index(SEARCH_FOR)
          f.puts "Accession: #{hit.accession} \nDefintion: #{hit.definition}"
          f.puts "Fasta ->"
          f.puts ncbi.nucleotide(hit.accession, "fasta")
          f.puts "----------------------------------------------------------------"
        end
      end
    end
  end
end
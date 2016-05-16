require 'pry'
require 'table_print'

class AnalisadorLexico
  attr_reader :letters, :reserved_words, :numbers, :symbols, :compost_symbols, :tokens
  
  def initialize
    @reserved_words = ['auto','break','case','char','const','continue','default','do','double','else',
                      'enum','extern','float','for','goto','if','int','long','register','return',
                      'short','signed','sizeof','static','struct','switch','typedef','union','unsigned',
                      'void','volatile','while']
    @tokens = []
  end

  def is_number?(string)
    true if Integer(string) rescue false
  end

  def analyze_line(line, nline)
    words = line.scan(/\w+/)
    compost_symbols = line.scan(/\+\+|\-\-|>=|<=|\+=|\-=|\*=|\/=|%=|!=/)
    words.each { |w| tokens << Token.new(nline,w,'Palavra Reservada') if reserved_words.include?(w) }
    words.delete_if { |w| reserved_words.include?(w) }
    words.each { |w| tokens << Token.new(nline,w,'Identificador') unless is_number?(w) }
    words.each { |w| tokens << Token.new(nline,w,'Constante inteira') if is_number?(w) }
    compost_symbols.each { |sc| tokens << Token.new(nline,sc,'Simbolo Composto') }
    symbol_line = line.gsub(/\+\+|\-\-|>=|<=|\+=|\-=|\*=|\/=|%=|!=/, "")
    symbols = symbol_line.scan(/\.|;|,|\(|\)|:|\+|<|>|\-|\*|%|=/)
    symbols.each { |s| tokens << Token.new(nline,s,'Simbolo') }
  end

end

class Token
  attr_accessor :line, :token, :symbol

  def initialize(line,token,symbol)
    @line = line
    @token = token
    @symbol = symbol
  end
end

al = AnalisadorLexico.new
File.open("arquivo.txt", "r") do |f|
  f.each_line.with_index(1) do |line,nline|
    line = line.delete("\n").downcase
    line = line.delete("\t")
    al.analyze_line(line,nline)
    puts line
  end
end

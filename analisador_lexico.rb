require 'pry'

class AnalisadorLexico
  attr_reader :words, :reserved_words, :numbers, :symbols, :compost_symbols, :tokens
  
  def initialize
    @words = ('a'..'z').to_a
    @reserved_words = ['auto','break','case','char','const','continue','default','do','double','else',
                      'enum','extern','float','for','goto','if','int','long','register','return',
                      'short','signed','sizeof','static','struct','switch','typedef','union','unsigned',
                      'void','volatile','while']
    @numbers = ('0'..'9').to_a
    @symbols = ['.',';',',','(',')',':','+','<','>','-','*','%']
    @compost_symbols = ['++','--','>=','<=','+=','-=','*=','/=','%=']
    @tokens = []
  end

  def analyze_line(line, nline)
    pos = 0
    while pos <= line.size
      pos2 = 0
      if line[pos] == ' '
        pos += 1
        next
      end
      if words.include? line[pos] #line[pos] é uma letra?
        pos2 = pos
        !!!!!!!if line[pos+1] == ' ' || line[pos+1].nil?
          @tokens << Token.new(nline,line[pos],'Letra')
        els!!!!!if reserved_words.any?{|rw| rw.include? line[pos]}
          while reserved_words.any?{|rw| rw.include? line[pos..pos2]}
            if reserved_words.any?{reserved_words.include? line[pos..pos2]}
              @tokens << Token.new(nline,line[pos..pos2],'Palavra Reservada')
              pos = pos2
              break
            end
            pos2 += 1
          end
          @tokens << Token.new(nline, line[pos], 'Letra') if words.include? line[pos]
        end
      elsif symbols.include? line[pos]
        pos += 1
        next
      elsif numbers.include? line[pos]
        pos += 1
        next
      end
      pos += 1
    end
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
binding.pry

# pos = 0
# line = "testando os bagulho"
# (pos..line.size).each do |n|
#   binding.pry
# end
require 'pry'

class AnalisadorLexico
  attr_reader :letters, :reserved_words, :numbers, :symbols, :compost_symbols, :tokens
  
  def initialize
    @letters = ('a'..'z').to_a
    @reserved_words = ['auto','break','case','char','const','continue','default','do','double','else',
                      'enum','extern','float','for','goto','if','int','long','register','return',
                      'short','signed','sizeof','static','struct','switch','typedef','union','unsigned',
                      'void','volatile','while']
    @numbers = ('0'..'9').to_a
    @symbols = ['.',';',',','(',')',':','+','<','>','-','*','%','=']
    @compost_symbols = ['++','--','>=','<=','+=','-=','*=','/=','%=']
    @tokens = []
  end

  # def valid_letter(pos,line)
  #   valid = letters + numbers + symbols + compost_symbols + [' ']
  #   valid.any?{|v| v.include?line[pos-1]}
  # end

  def valid_word(pos,pos2,line)
    valid = symbols + compost_symbols + [' ']
    valid.any?{|v| v.include?line[pos-1]} && valid.any?{|v| v.include?line[pos2+1]}
  end

  def analyze_line(line, nline)
    pos = 0
    while pos <= line.size
      pos2 = 0
      if line[pos] == ' '
        pos += 1
        next
      end
      if letters.include? line[pos] #line[pos] é uma letra?
        pos2 = pos
        if reserved_words.any?{|rw| rw.include? line[pos]}
          while reserved_words.any?{|rw| rw.include? line[pos..pos2]} && !line[pos2].nil?
            if reserved_words.any?{reserved_words.include? line[pos..pos2]} && valid_word(pos,pos2,line)
              @tokens << Token.new(nline,line[pos..pos2],'Palavra Reservada')
              pos = pos2 + 1
              break
            end
            pos2 += 1
          end
          @tokens << Token.new(nline, line[pos], 'Letra') if letters.include? line[pos]
        else
          @tokens << Token.new(nline, line[pos], 'Letra') if letters.include? line[pos]
        end
      elsif symbols.include? line[pos]
        pos2 = pos
        if compost_symbols.any?{|cs| cs.include? line[pos]}
          while compost_symbols.any?{|cs| cs.include? line[pos..pos2]} && !line[pos2].nil?
            if compost_symbols.any?{compost_symbols.include? line[pos..pos2]}
              @tokens << Token.new(nline,line[pos..pos2],'Simbolo Composto')
              pos = pos2 + 1
              break
            end
            pos2 += 1
          end
          @tokens << Token.new(nline,line[pos],'Simbolo') if symbols.include? line[pos]
        else
          @tokens << Token.new(nline,line[pos],'Simbolo') if symbols.include? line[pos]
        end
      elsif numbers.include? line[pos]
        @tokens << Token.new(nline,line[pos],'Simbolo')
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
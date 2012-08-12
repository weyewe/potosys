# http://stackoverflow.com/questions/6288445/how-can-i-extend-activerecord-from-app-modules
module NumberValidator
  
  def valid_price_string?(price_string)
    not self.parse_price(price_string).nil? 
    
    parsed_price = self.parse_price(price_string)
    if parsed_price.nil?
      return false
    else
      return true 
    end
  end
  
  def parse_price(price_string )
    begin
      Float(price_string)
    rescue
      return nil 
    end
    zero_value = BigDecimal("0")
    price = BigDecimal(price_string)
    
    if price >= zero_value 
      return price
    else
      return nil
    end
  end
  
  def is_numeric?(obj) 
     obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
  
  
end
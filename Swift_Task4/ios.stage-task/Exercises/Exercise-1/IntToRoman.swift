import Foundation

public extension Int {
    
    var roman: String? {
        
        var result:String = ""
        
        var a:Int = self/1000
        result = result + getM(t: a)
        var b:Int = self%1000
        
        
        var m:Int = b/500
        result = result + getD(d: m)
        var m2 = b%500
        
        var c:Int = m2/100
        result = result + getC(c: c)
        var c2:Int = m2%100
        
        var l:Int = c2/50
        result = result + getL(l: l)
        var l2 = c2%50
        
        var x:Int = l2/10
        result = result + getX(x:x)
        var x2:Int = l2%10
        
        result = result + String(x2);
        
       return nil
    }
    
    func getM(t:Int) -> String {
        
        var str: String = "";
        var i:Int = 0;
                while (i < t) {
                    str = str + "M"
                    i+=1;
                }
        return str;
    }
    
    func getC(c:Int) -> String {
        var str: String = "";
        if c == 4 {return "CD"}
        else if (c != 0 && c < 4) {
           var i:Int = 0
            while (i < c) {
                str = str + "C"
                i+=1;
            }
            return str
        } else {return ""}
    }
    
    func getX(x:Int) -> String {
        var str: String = "";
        if x == 4 { return "XL"}
        else if (x != 0) && (x < 4) {
            var i:Int = 0;
            while (i < x) {
                str = str + "X"
                i+=1;
            }
            return str
        } else {return ""};
    }
    
    func getD(d:Int) -> String {
        if (d == 4) {return "CM"} // если 900, то 1000-100
        else  {return "D"}
    }
    
    func getL(l:Int) -> String {
        if (l == 4) {return "XC"};
                     return "L"
                }
                // От 1 до 9, то что осталось
    func basic(i:Int) -> String{
        
        var a:[String] = ["",
                        "I",
                        "II",
                        "III",
                        "IV",
                        "V",
                        "VI",
                        "VII",
                        "VIII",
                        "IX"]
                   
        return a[i];

    }
    
}

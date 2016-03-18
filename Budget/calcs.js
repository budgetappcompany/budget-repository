
pi=Math.PI;
e=Math.E;
ln2=Math.LN2;
ln10=Math.LN10;
sqrt2=Math.SQRT2;

abs=Math.abs;
pow=Math.pow;
exp=Math.exp;
sqrt=Math.sqrt;
ln=Math.log;
sin=Math.sin;
sen=Math.sin;
cos=Math.cos;
tan=Math.tan;
asin=Math.asin;
asen=Math.asin;
acos=Math.acos;
atan=Math.atan;
atan2=Math.atan2;
floor=Math.floor;
ceil=Math.ceil;
random=Math.random;

function universalcalc(expression_input,expression_decs) {
    var expr_orig = remove_acentos(expression_input);
    var expression_result = "VAZIO";
    try {
        var expr = prepare_expression(expr_orig);
        //alert("expr="+expr);
        if (is_expression_empty(expr)) {
            return expression_result;
        } else if (!is_expression_safe(expr)) {
            expression_result = "Invalid Symbol";
            if (expr.indexOf("!") != -1) expression_result = "Use fact(x) instead of x!";
            if (expr.indexOf("^") != -1) expression_result = "Use pow(x,y) instead of x^y";
            return expression_result;
        } else if (commaMisuse(expr)) {
            expression_result = "ERRO -> Use , ao invés de .";
            return expression_result;
        } else {
            //alert("expr "+expr);
            var result = eval(expr);
            // alert("result="+result);
            if (isNaN(result) && typeof(result) != "string") {
                expression_result = "Invalid Function Call";
                return expression_result;
            }
            //alert("result="+result+" result2="+roundPadding(result,expression_decs));
            result = roundPadding(result,expression_decs);
            expression_result = result;
            return expression_result;
        }
    } catch (err) {
        //alert("err "+err);
        expression_result = "INVÁLIDO";
        return expression_result;
    }
    
}

function commaMisuse(expr) {
    var i=0, parens = [];
    for (i=0;i<expr.length;i++) {
        if (expr.charAt(i) == "(") {
            if (gettingInsideFunc(expr,i)) parens.push("F");
            else parens.push("P");
        } else if (expr.charAt(i) == ")") {
            parens.pop();
        } else if (expr.charAt(i)=="," && !isInsideFunc(parens)) return true;
    }
    return false;
}
function gettingInsideFunc(expr, i) {
    var j=i-1;
    for (j=i-1; j>=0; j--) {
        if (expr.charAt(j) == " ") continue;
        if (expr.charCodeAt(j) >= 0x61 && expr.charCodeAt(j) <= 0x7A) return true;
        else return false;
    }
    return false;
}
function isInsideFunc(parens) {
    if (parens.length == 0) return false;
    if (parens[parens.length-1] == "F") return true;
    return false;
}

function roundPadding(n, d) {
    if (d==5 || typeof(n) == "string") { // unbounded decimals or is String
        return n;
    } else if (d==6) { // force scientific notation
        var num = new Number(n);
        return num.toExponential(10);
    } else {
        var nr = n+"", suffix=null;
        if (nr.indexOf("e") != -1) {
            var toks = nr.split("e");
            nr = toks[0];
            suffix = toks[1];
        }
        var nr = round(parseFloat(nr), d)+"";
        if (d > 0) {
            var indexPt = nr.lastIndexOf(".");
            if (indexPt == -1) nr = paddingZeros(nr+".", d);
            else nr = paddingZeros(nr, d-(nr.length-indexPt-1));
        }
        if (suffix != null) {
            nr = nr+"e"+suffix;
        }
        return nr;
    }
}

function paddingZeros(str, p) {
    var ip = 0;
    for (ip=0;ip<p;ip++){
        str += "0";
    }
    return str;
}

function round(n, d) {
    if (d==null) d=0;
    n = n*pow(10,d);
    n = Math.round(n);
    return n/pow(10,d);
}

function prepare_expression(expr) {
    
    expr = expr.toLowerCase().replace(/[%]/g, '/100').replace(/mod/g, '%');
    
    if (expr.indexOf("conv") != -1) {
        expr = prepare_convs(expr); // dependency of conv.js
    }
    
    return expr;
}

var torepl = null;
function remove_acentos(w) {
    var i;
    if (torepl == null) {
        torepl = {};
        var chars = ["áàãââéêíóõôúüç\n\r","aaaaaeeiooouuc  "];
        for (i=0;i<chars[0].length;i++) torepl[chars[0].charAt(i)]=trim(chars[1].charAt(i));
    }
    var rw = "";
    for(i=0;i<w.length;i++) {
        var c = torepl[w.charAt(i)];
        if (c == null) c = w.charAt(i);
        rw += c;
    }
    return rw;
}

var allowed_array = [
                     // funcs
                     'pv','fv','pmt','nper','rate','radianos','graus','mmc',
                     'mdc','combinacao','arranjo','dias','diadasemana','media',
                     'mediageo','variancia','desviopadrao', 'projetadata', 'conv',
                     'npv', 'payback', 'irr', 'sum',
                     // translations
                     'permutation','combination','rad','deg','lcm',
                     'mcd','days','weekday','mean','geomean','stdev','variance','dateprojection',
                     // orinal funcs
                     'abs','acos','asin','asen','atan','atan2','cos','exp','log','ln',
                     'pow','random','sin','sen','sqrt','tan','round','ceil','floor',
                     // adv funcs
                     'gamma','cot','sec','csc','acot','asec','acsc','sinh','cosh','tanh',
                     'coth','sech','csch','asinh','acosh','atanh','acoth','asech','acsch',
                     'fact','chisq','norm','gauss','erf','studt','fishf','statcom','anorm',
                     'agauss','aerf','achisq','astudt','afishf',
                     'bin2dec', 'tohex', 'tobin', 'tooct', 'dec2radix', 'radix2dec',
                     'ascii',
                     // constants
                     'pi','e','ln10','sqrt2','ln2',
                     // symbols
                     "+", "-", "*", "/", "%", "(", ")", "&", "|", ","," "];
var allowed = null, allowedUnits = null;

function initialize_allowed() {
    allowed = {};
    var j=0;
    for (;j<allowed_array.length;j++) {
        allowed[allowed_array[j]] = "ok";
    }
    
    // dependency of conv.js
    var unit;
    allowedUnits = {};
    for (unit in alluns) {
        if (unit != "END") allowedUnits[unit] = "ok";
    }
    for (j=0;j<(convtbs.length-1);j++) {
        for (unit in convtbs[j]) {
            if (unit != "END" && unit != "UNIT") allowedUnits[unit] = "ok";
        }
    }
}
initialize_allowed();

function is_expression_safe(expr) {
    return true; // FIXME
    var i=0;
    var word = "", pword = "";
    var isNum = false;
    for (;i<expr.length; i++) {
        word += expr.charAt(i);
        if (!isNaN(word+"1")) { // is a number
            isNum = true;
        } else if (isNum) { // was a number
            isNum = false;
            word = expr.charAt(i);
            if (allowed[word] == "ok") {
                pword = word;
                word = "";
            }
        } else if (isAllowed(word) || allowed[pword+word] == "ok") {
            if (allowed[pword+word] == "ok") {
                pword = pword+word;
            } else {
                pword = word;
            }
            word = "";
        }
    }
    
    return (word.length == 0 || isNum);
    
}

/*
 Separate functions, operators, numbers and strings
	function - any alfanum_ preceding a (
	number - any !isNaN(word+"1")
	operator - any non alfanum_
	string - any alfanum_ non-function
 */
function is_expression_safe2(expr) {
    var toks = [], word = "", pword = "";
    var previous = "NONE"; // NONE, ALFANUM, FUNC, OPER, STR
    var insideStr = false;
    for (var i=0;i<expr.length;i++) {
        if (word != "") pword = word;
        var c = expr.charAt(i);
        word += c;
        if (is_number(word)) {
            previous = "NUMBER";
        } else if (is_alfanum_(word)) {
            previous = "ALFANUM";
            if (is_function(i+1,expr)) {
                if (!validFunction(word)) return false;
                previous = "FUNC";
                word = "";
            }
        } else {
            if (previous == "ALFANUM") word = c;
            
        }
    }
}

function is_alfanum_(numaric) {
    if (numaric.length == 0) return false;
    for(var j=0; j<numaric.length; j++){
        var alphaa = numaric.charAt(j);
        var hh = alphaa.charCodeAt(0);
        if((hh > 47 && hh<58) || (hh > 64 && hh<91) || (hh > 96 && hh<123) || alphaa=="_"){
        } else {
            return false;
        }
    }
    return true;
}
function is_number(word) {
    return !isNaN(word+"1");
}
function is_function(index, text) {
    for (var i=index;i<text.length;i++) {
        if (text.charAt(i) == "(") return true;
        if (text.charAt(i) != " ") return false;
    }
    return false;
}

function isAllowed(w) {
    if (w.indexOf("'") == -1) {
        return allowed[w] == "ok";
    } else {
        if (w.length > 1 && w.indexOf("'") == 0 && w.lastIndexOf("'") == (w.length-1)) {
            w = w.replace(/'*/g, "");
                          return allowedUnits[w] == "ok";
                          }
                          }
                          return false;
                          }
                          
                          function is_expression_empty(expr) {
                          return expr == null || trim(expr).length == 0;
                          }
                          
                          function trim(str){
                          return str.replace(/^\s+|\s+$/g,"");
                          }
                          String.prototype.endsWith = function(str) {return (this.match(str+"$")==str)}
                          
                          //
                          // Funcoes financeiras
                          //
                          
                          function fv(rate,nper,pmt,pv,pb) {
                          if (isNaN(pv)) pv = 0;
                          if (isNaN(pb)) pb = 0;
                          return comp_fv(nper,rate,pmt,pv,pb);
                          }
                          
                          function pv(rate,nper,pmt,fv,pb) {
                          if (isNaN(fv)) fv = 0;
                          if (isNaN(pb)) pb = 0;
                          return comp_pv(nper,rate,pmt,fv,pb);
                          }
                          
                          function nper(rate,pmt,pv,fv,pb) {
                          if (isNaN(fv)) fv = 0;
                          if (isNaN(pb)) pb = 0;
                          return comp_np(rate,pmt,fv,pv,pb);
                          }
                          
                          function pmt(rate,nper,pv,fv,pb) {
                          if (isNaN(fv)) fv = 0;
                          if (isNaN(pb)) pb = 0;
                          return comp_pmt(nper,rate,fv,pv,pb);
                          }
                          
                          function rate(nper,pmt,pv,fv,pb) {
                          if (isNaN(fv)) fv = 0;
                          if (isNaN(pb)) pb = 0;
                          
                          return comp_ir(nper, pmt, pv, fv, pb);
                          }
                          
                          function npv(ir,payments) {
                          if (isNaN(ir)) ir = 0;
                          return comp_npv(ir,payments);
                          }
                          function payback(ir,payments, decimais) {
                          if (isNaN(ir)) ir = 0;
                          if (isNaN(decimais)) decimais = 0;
                          return comp_payback(ir,payments, decimais);
                          }
                          
                          function sum(payments) {
                          return comp_sum(payments);
                          }
                          
                          function irr(values,guess) {
                          if (isNaN(guess)) guess = null;
                          return comp_irr(values, guess);
                          }
                          
                          function comp_pv(np,ir,pmt,fv,pb)
                          {
                          var pv;
                          if(ir == 0.0) {
                          pv = - fv - np * pmt;
                          }
                          else {
                          var qa = Math.pow(1 + ir,-np);
                          var qb = Math.pow(1 + ir,np);
                          pv = - qa * (fv + ((-1 + qb) * pmt * (1 + ir * pb))/ir);
                          }
                          return pv;
                          }
                          
                          function comp_fv(np, ir, pmt, pv,pb)
                          {
                          var fv;
                          if(ir == 0.0) {
                          fv = - np * pmt - pv;
                          }
                          else {
                          var q = Math.pow(1+ir,np);
                          fv = - q * pv - (((-1 + q) * pmt * (1 + ir * pb))/ir);
                          }
                          return fv;
                          }
                          
                          function comp_fvf(np, ir, pmt, pv,pb)
                          {
                          var q = Math.pow(1+ir,np);
                          fv = pv*q;
                          return fv;
                          }
                          function comp_mir(np, ir, air)
                          {
                          var q = Math.pow(1+air,1.0/np);
                          ir = q - 1;
                          return ir;
                          }
                          function comp_air(np, ir, air)
                          {
                          var q = Math.pow(1+ir,np);
                          air = q - 1;
                          return air;
                          }
                          
                          function comp_pmt( np,  ir, fv,  pv,pb)
                          {
                          var pmt = 0;
                          if(ir == 0.0) {
                          if(np != 0.0) {
                          pmt = - (fv + pv)/np;
                          }
                          }
                          else {
                          var q = Math.pow(1+ir,np);
                          pmt = - (ir * (fv + (q * pv)))/((-1 + q) * (1 + ir * pb));
                          }
                          return pmt;
                          }
                          
                          function comp_np( ir,  pmt,  fv,  pv,pb)
                          {
                          var np = 0;
                          if(ir == 0.0) {
                          if(pmt != 0.0) {
                          np = - (fv + pv)/pmt;
                          }
                          }
                          else { // ir != 0
                          var terma = -fv * ir + pmt + ir * pmt * pb;
                          var termb = pmt + ir * pv + ir * pmt * pb;
                          np = Math.log(terma/termb)/Math.log(1 + ir);
                          }
                          return np;
                          }
                          
                          function comp_ir(nper, pmt, pv, fv, type, guess) {
                          //function comp_ir(np,ir,pmt,pv,fv,pb)
                          if (guess == null) guess = 0.01;
                          if (fv == null) fv = 0;
                          if (type == null) type = 0;
                          
                          //FROM MS http://office.microsoft.com/en-us/excel-help/rate-HP005209232.aspx
                          var FINANCIAL_MAX_ITERATIONS = 128;//Bet accuracy with 128
                          var FINANCIAL_PRECISION = 0.0000001;//1.0e-8
                          
                          var y, y0, y1, x0, x1 = 0, f = 0, i = 0;
                          var rate = guess;
                          if (Math.abs(rate) < FINANCIAL_PRECISION) {
                          y = pv * (1 + nper * rate) + pmt * (1 + rate * type) * nper + fv;
                          } else {
                          f = Math.exp(nper * Math.log(1 + rate));
                          y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
                          }
                          y0 = pv + pmt * nper + fv;
                          y1 = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
                          
                          // find root by Newton secant method
                          i = x0 = 0.0;
                          x1 = rate;
                          while ((Math.abs(y0 - y1) > FINANCIAL_PRECISION) && (i < FINANCIAL_MAX_ITERATIONS)) {
                          rate = (y1 * x0 - y0 * x1) / (y1 - y0);
                          x0 = x1;
                          x1 = rate;
                          
                          if (Math.abs(rate) < FINANCIAL_PRECISION) {
                          y = pv * (1 + nper * rate) + pmt * (1 + rate * type) * nper + fv;
                          } else {
                          f = Math.exp(nper * Math.log(1 + rate));
                          y = pv * f + pmt * (1 / rate + type) * (f - 1) + fv;
                          }
                          
                          y0 = y1;
                          y1 = y;
                          ++i;
                          }
                          return rate;
                          }
                          
            /*
             NPV - Net Present Value
             rate = the periodic discount rate
             example: If the discount rate is 10% enter 0.1, not 10.
             payments = an array
             example: [-100, 50.87, 60] means an initial cash outflow of 100 at time 0,
             then cash inflows of 50 at the end of the period one, and 60 at
             the end of the period two.
             */
                          function comp_npv(ir, payments) {
                          //alert("comp_npv, ir="+ir+", payments="+payments);
                          var i, npv = 0;
                          //var debug = "";
                          for (i in payments) {
                          var numpay = parseFloat(payments[i]);
                          npv += numpay / Math.pow((1 + ir), i);
                          //debug += "i="+i+" numpay="+numpay+" ir="+ir+"; ";
                          }
                          npv = npv/(1+ir);
                          //alert("comp_npv "+debug);
                          return npv;
                          }
                          
                          function comp_payback(ir, payments, decimais) {
                          //alert("comp_payback, ir="+ir+", payments="+payments);
                          var i, npv = 0, npvold = 0, result = -1;
                          //var debug = "";
                          for (i in payments) {
                          //debug += payments[i]+"["+i+"];";
                          var numpay = parseFloat(payments[i]);
                          npvold = npv;
                          npv += numpay / Math.pow((1 + ir), i);
                          //debug += "i="+i+" numpay="+numpay+" ir="+ir+"; ";
                          if (npv > 0) {
                          result = i - 1 - npvold/(npv-npvold);
                          //debug += " npv="+npv;
                          break;
                          }
                          }
                          npv = npv/(1+ir);
                          if (npv > 0 && result == -1) result = i+1; // NAO ENTENDI
                          
                          result = Math.ceil(result*Math.pow(10,decimais))/Math.pow(10,decimais);
                          return result;
                          }
                          
                          function comp_sum(payments) {
                          var i, sumv = 0;
                          for (i in payments) {
                          var numpay = parseFloat(payments[i]);
                          sumv += numpay;
                          }
                          return sumv;
                          }
                          
                          function calcs_replaceAll(str, a, b) {
                          if (str == null || a == b) return str;
                          while (str.indexOf(a) >= 0) {
                          str = str.replace(a, b);
                          }
                          return str;
                          }
                          
                          function comp_irr(values, guess) {
                          if (guess == null) guess = 0.1;
                          
                          var maxIterationCount = 20;
                          var absoluteAccuracy = 0.000001; //1E-7;
                          
                          var x0 = guess;
                          var x1;
                          
                          var i = 0;
                          while (i < maxIterationCount) {
                          
                          // the value of the function (NPV) and its derivate can be calculated in the same loop
                          var fValue = 0;
                          var fDerivative = 0;
                          for (var k = 0; k < values.length; k++) {
                          fValue += values[k] / Math.pow(1.0 + x0, k);
                          fDerivative += -k * values[k] / Math.pow(1.0 + x0, k + 1);
                          }
                          
                          // the essense of the Newton-Raphson Method
                          x1 = x0 - fValue/fDerivative;
                          
                          if (Math.abs(x1 - x0) <= absoluteAccuracy) {
                          return x1;
                          }
                          
                          x0 = x1;
                          ++i;
                          }
                          // maximum number of iterations is exceeded
                          return null;
                          }
                          
                          //
                          // funcoes matematicas
                          //
                          function arranjo(n,p) {
                          if (n < p) throw "a funcao arranjo exige n > p";
                          // n!/(n - p)!
                          return fact(n)/fact(n-p);
                          }
                          
                          function combinacao(n,p) {
                          // n!/(p!*(n-p)!)
                          return arranjo(n,p)/fact(p);
                          }
                          
                          function radianos(graus) {
                          return graus*Math.PI/180;
                          }
                          function graus(radianos) {
                          return radianos*180/Math.PI;
                          }
                          
                          function mdc() {
                          var a = eval_args(arguments);
                          
                          var r=a[0];
                          var i,c,k;
                          for(i=1;i<a.length;i++) {
                          c=a[i];
                          while(c!=0) {
                          r-=c*Math.floor(r/c);
                          k=c;
                          c=r;
                          r=k;
                          }
                          }
                          return r;
                          }
                          
                          function mmc() {
                          var a = eval_args(arguments);
                          
                          var s=a[0];
                          var j;
                          for(j=1;j<a.length;j++) {
                          s*=a[j]/mdc(s,a[j]);
                          }
                          return s;
                          }
                          
                          var months=[0,31,59,90,120,151,181,212,243,273,304,334];
                          function leap_yearQ(year) {
                          if(year>4 && ((year%4==0 && year%100!=0) || year%400==0)) return true;
                          else return false;
                          }
                          function dias(d1,m1,y1, d2,m2,y2) {
                          
                          if (d2 == null) {
                          var today = new Date();
                          d2 = today.getDate();
                          m2 = today.getMonth()+1;
                          y2 = today.getFullYear();
                          }
                          
                          var invert = 1;
                          if ( (y1*1e4+m1*1e2+d1) > (y2*1e4+m2*1e2+d2) ) {
                          var yt=y1, mt=m1, dt=d1;
                          y1=y2; m1=m2; d1=d2;
                          y2=yt; m2=mt; d2=dt;
                          invert = -1;
                          }	
                          
                          var days=365-d1-months[m1-1];
                          if(leap_yearQ(y1) && days>304) days++;
                          for(i=y1/1+1; i<y2; i++) days+=365+leap_yearQ(i);
                          days+=d2/1+months[m2-1]-365*(y1==y2);
                          
                          return days*invert+"";
                          }
                          function days(m1,d1,y1, m2,d2,y2) {
                          return dias(d1,m1,y1, d2,m2,y2);
                          }
                          
                          var weekdays = [null,"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
                          function diadasemana(d1,m1,y1) {
                          // dom=1,seg=2,...,sab=7
                          // 17/05/2009 foi domingo
                          var ds = dias(17,5,2009, d1,m1,y1);
                          
                          if (ds >= 0) {
                          return weekdays[(ds % 7)+1];
                          } else {
                          var r = (ds % 7)+8;
                          if (r==8) r=1;
                          return weekdays[r];
                          }
                          }
                          function weekday(m1,d1,y1) {
                          return diadasemana(d1,m1,y1);
                          }
                          
                          function projetadata(dias1,d2,m2,y2) {
                          var dt = new Date();
                          dt.setHours(0); dt.setMinutes(0); dt.setSeconds(1);
                          if (d2 != null) {
                          dt.setFullYear(y2);
                          dt.setMonth(m2-1);
                          dt.setDate(d2);
                          }
                          
                          dt.setTime(dt.getTime() + dias1*24*3600*1000);
                          return dt.toDateString();
                          }
                          function dateprojection(dias1,m2,d2,y2) {
                          return projetadata(dias1,d2,m2,y2);
                          }
                          
                          function media() {
                          var a = eval_args(arguments);
                          
                          var sum = 0;
                          var i=0;
                          for(;i<a.length;i++) {
                          sum += a[i];
                          }
                          return sum/a.length;
                          }
                          
                          function mediageo() {
                          var a = eval_args(arguments);
                          
                          var prod = 1;
                          var i=0;
                          for(;i<a.length;i++) {
                          prod *= a[i];
                          }
                          return pow(prod, 1/a.length);
                          }
                          
                          function variance() {
                          var a = eval_args(arguments);
                          
                          var i=0, total=0, sqrTotal=0, n=a.length;
                          for (i=0; i<n; i++) {
                          total = total + a[i];
                          sqrTotal = sqrTotal + ( a[i] * a[i] );
                          }
                          return ( sqrTotal - ((total * total)/n) ) / n;
                          }
                          
                          function eval_args(args) {
                          if (args.length == 1 && isNaN(args[0])) args = args[0];
                          return args;
                          }
                          
                          function stdev() {
                          return  sqrt(variance(arguments));
                          }
                          
                          function log(x,b) {
                          if(b==null) b=10;
                          return ln(x)/ln(b);
                          }
                          
                          // Translations
                          permutation=arranjo;
                          combination=combinacao;
                          rad=radianos;
                          deg=graus;
                          mcd=mdc;
                          lcm=mmc;
                          mean=media;
                          geomean=mediageo;
                          
                          // 
                          // http://statpages.org/scicalc.html
                          // 
                          
                          var Pi=Math.PI; var PiD2=Pi/2; var PiD4=Pi/4; var Pi2=2*Pi;
                          //var e=exp(1); 
                          var e10 = exp(0.1);
                          
                          function fact(n) {
                          if(n==0 | n==1) { return 1 }
                          if(n<0) { return fact(n+1)/(n+1) }
                          if(n>1) { return n*fact(n-1) }
                          if(n<0.5) { r = n } else { r = 1 - n }
                          var r = 1 / (1 + r*( 0.577215664819072 + r*(-0.655878067489187 + r*(-0.042002698827786 + r*(0.166538990722800 + r*(-0.042197630554869 + r*(-0.009634403818022 + r*(0.007285315490429 + r*(-0.001331461501875 ) ) ) ) ) ) ) ) );
                          if( n > 0.5 ) { r = n*(1-n)*Pi / (r*sin(Pi*n)) }
                          return r;
                          }
                          
                          function gamma(n) { return fact(n-1) }
                          function cot(x) { return Math.cos(x)/Math.sin(x) }
                          function sec(x) { return 1/Math.cos(x) }
                          function csc(x) { return 1/Math.sin(x) }
                          function acot(x) { return atan(1/x) }
                          function asec(x) { return acos(1/x) }
                          function acsc(x) { return asin(1/x) }
                          
                          function sinh(x) { return (Math.exp(x)-Math.exp(-x))/2 }
                          function cosh(x) { return (Math.exp(x)+Math.exp(-x))/2 }
                          function tanh(x) { return sinh(x)/cosh(x) }
                          function coth(x) { return 1/tanh(x) }
                          function sech(x) { return 1/cosh(x) }
                          function csch(x) { return 1/sinh(x) }
                          function asinh(x) { return Math.log(x+Math.sqrt(x*x+1)) }
                          function acosh(x) { return Math.log(x+Math.sqrt(x*x-1)) }
                          function atanh(x) { return 0.5*Math.log((1+x)/(1-x)) }
                          function acoth(x) { return 0.5*Math.log((x+1)/(x-1)) }
                          function asech(x) { return Math.log(1/x+Math.sqrt(1/(x*x)+1)) }
                          function acsch(x) { return Math.log(1/x+Math.sqrt(1/(x*x)-1)) }
                          
                          function chisq(x,n) {
                          if(x>1000 | n>1000) { var q=norm((pow(x/n,1/3)+2/(9*n)-1)/sqrt(2/(9*n)))/2; if (x>n) {return q}{return 1-q} }
                          var p=Math.exp(-0.5*x); if((n%2)==1) { p=p*Math.sqrt(2*x/Pi) }
                          var k=n; while(k>=2) { p=p*x/k; k=k-2 }
                          var t=p; var a=n; while(t>1e-15*p) { a=a+2; t=t*x/a; p=p+t }
                          return 1-p
                          }
                          function norm(z) { var q=z*z
                          if(abs(z)>7) {return (1-1/q+3/(q*q))*Exp(-q/2)/(abs(z)*sqrt(PiD2))} else {return chisq(q,1) }
                          }
                          function gauss(z) { return ( (z<0) ? ( (z<-10) ? 0 : chisq(z*z,1)/2 ) : ( (z>10) ? 1 : 1-chisq(z*z,1)/2 ) ) }
                          
                          function erf(z) { return ( (z<0) ? (2*gauss(sqrt(2)*z)-1) : (1-2*gauss(-sqrt(2)*z)) ) }
                          
                          function studt(t,n) {
                          t=Math.abs(t); var w=t/Math.sqrt(n); var th=Math.atan(w)
                          if(n==1) { return 1-th/PiD2 }
                          var sth=Math.sin(th); var cth=Math.cos(th)
                          if((n%2)==1)
                          { return 1-(th+sth*cth*StatCom(cth*cth,2,n-3,-1))/PiD2 }
                          else
                          { return 1-sth*statcom(cth*cth,1,n-3,-1) }
                          }
                          function fishf(f,n1,n2) {
                          var x=n2/(n1*f+n2)
                          if((n1%2)==0) { return statcom(1-x,n2,n1+n2-4,n2-2)*Math.pow(x,n2/2) }
                          if((n2%2)==0){ return 1-statcom(x,n1,n1+n2-4,n1-2)*Math.pow(1-x,n1/2) }
                          var th=Math.atan(Math.sqrt(n1*f/n2)); var a=th/PiD2; var sth=Math.sin(th); var cth=Math.cos(th)
                          if(n2>1) { a=a+sth*cth*statcom(cth*cth,2,n2-3,-1)/PiD2 }
                          if(n1==1) { return 1-a }
                          var c=4*statcom(sth*sth,n2+1,n1+n2-4,n2-2)*sth*Math.pow(cth,n2)/Pi
                          if(n2==1) { return 1-a+c/2 }
                          var k=2; while(k<=(n2-1)/2) {c=c*k/(k-.5); k=k+1 }
                          return 1-a+c
                          }
                          function statcom(q,i,j,b) {
                          var zz=1; var z=zz; var k=i; while(k<=j) { zz=zz*q*k/(k-b); z=z+zz; k=k+2 }
                          return z
                          }
                          function anorm(p) { var v=0.5; var dv=0.5; var z=0
                          while(dv>1e-15) { z=1/v-1; dv=dv/2; if(norm(z)>p) { v=v-dv } else { v=v+dv } }
                          return z
                          }
                          
                          function agauss(p) { if(p>0.5) { return( sqrt(achisq(2*(1-p),1)) ) } else { return( -sqrt(achisq(2*p,1)) ) } }
                          
                          function aerf(p) { return agauss(p/2+0.5)/sqrt(2) }
                          
                          function achisq(p,n) { var v=0.5; var dv=0.5; var x=0
                          while(dv>1e-15) { x=1/v-1; dv=dv/2; if(chisq(x,n)>p) { v=v-dv } else { v=v+dv } }
                          return x
                          }
                          function astudt(p,n) { var v=0.5; var dv=0.5; var t=0
                          while(dv>1e-15) { t=1/v-1; dv=dv/2; if(studt(t,n)>p) { v=v-dv } else { v=v+dv } }
                          return t
                          }
                          function afishf(p,n1,n2) { var v=0.5; var dv=0.5; var f=0
                          while(dv>1e-15) { f=1/v-1; dv=dv/2; if(fishf(f,n1,n2)>p) { v=v-dv } else { v=v+dv } }
                          return f
                          }
                          
                          // Base Convertions
                          function tohex(num) {
                          return "0x"+dec2radix(16,num).toUpperCase();
                          }
                          function tobin(num) {
                          return dec2radix(2,num);
                          }
                          function tooct(num) {
                          return "0"+dec2radix(8,num);
                          }
                          function bin2dec(num) {
                          // must never use 0 at left
                          return radix2dec(2,num);
                          }
                          
                          function dec2radix(radix,num) {
                          return new Number(num).toString(radix);
                          }
                          
                          function radix2dec(radix,num) {
                          var snum = (num+"").split("."), r=0, i=0, c=0;
                          for (i=0; i<snum[0].length; i++) {
                          c = parseInt(snum[0].charAt(snum[0].length-i-1));
                          if (c>=radix) return Number.NaN;
                          r += c*pow(radix,i);
                          }
                          if (snum.length == 1) return r+"";
                          
                          for (i=0; i<snum[1].length; i++) {
                          c = parseInt(snum[1].charAt(i));
                          if (c>=radix) return Number.NaN;
                          r += c*pow(radix,-(i+1));
                          }
                          return r+"";
                          }
                          
                          function ascii(c) {
                          return c.charCodeAt(0) + " " + tohex(c.charCodeAt(0));
                          }
                          function prepare_ascii(expr) {
                          var parse = new Parse(expr);
                          var result = "", index=0, cii;
                          try {
                          while (true) {
                          parse.goafter("ascii");
                          parse.goafter("(");
                          cii = parse.extractUntil(")");
                          result += "'"+prepare_unit(cii)+"')";
                          
                          index = parse.goafter(")");
                          }
                          } catch (end) {
                          if (end.indexOf("END") == -1) throw end; 
                          }
                          result += parse.extractToEnd(index);
                          return result;
                          }
                          

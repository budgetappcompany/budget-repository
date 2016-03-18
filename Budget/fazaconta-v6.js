function alertExcel() {
    alert('Expressão compatível com o Excel em português (pt-BR).\n\nPara mais informações consulte as seções:\n "Dicas para o Excel" e "Excel Português x Inglês".');
}
function alertAltere() {
    alert('Altere qualquer valor e instantaneamente verá o resultado!');
}

// funcao utilizada no conversor de taxas de juros entre periodos
function razaoPeriodos(d1, d2) {
    // console.log("Executou: "+d1+"/"+d2);
    d1 = parseInt(d1);
    d2 = parseInt(d2);
    if (d1 == d2) return "1";
    if (d1 == 360 && d2 == 7) return "52";
    if (d1 == 180 && d2 == 7) return "26";
    if (d1 == 7 && d2 == 360) return "1/52";
    if (d1 == 7 && d2 == 180) return "1/26";
    if (d1/d2 == 3/2) return "3/2";
    if (d1/d2 == 2/3) return "2/3";
    if (d1 != 7 && d2 != 7 && d1 > d2) return (d1/d2)+"";
    if (d1 != 7 && d2 != 7 && d2 > d1) return "1/"+(d2/d1);
    return d1+"/"+d2;
}

function perpetuidade(fluxo) {
    fluxo = preparaFluxo(fluxo);
    fluxo = fluxo.replace("...","|...").replace("||","|");
    var toks = fluxo.split("|");
    if (toks.length > 1 && toks[toks.length-1] == "...") return toks[toks.length-2];
    else return 0;
}

function npvfaza(fluxo, juros) {
    fluxo = preparaFluxo(fluxo);
    var perp = perpetuidade(fluxo);
    fluxo = fluxo.replace("|...","").replace("...","");
    var invests = investimentos(fluxo);
    var toks = fluxo.split("|");
    var i=0;
    var expr = "";
    var val;
    for (i in toks) {
        val = toks[i];
        if (i == 0) {
            expr +=val;
        } else {
            if (i == 1) {
                expr += " + NPV("+juros+"%|["+val;
            } else {
                expr += "|"+val;
            }
        }
    }
    if (perp != null && perp != "" && perp != "0") {
        expr += "+"+perp+"/("+juros+"%)";
    }
    if (i > 0) {
        expr += "])";
    } else {
        expr += "";
    }
    return expr;
}

function irrfaza(fluxo, juros) {
    fluxo = preparaFluxo(fluxo);
    var perp = perpetuidade(fluxo);
    fluxo = fluxo.replace("|...","").replace("...","");
    var toks = fluxo.split("|");
    var i=0;
    var expr = "";
    var val;
    for (i in toks) {
        val = toks[i];
        
        if (i == 0) {
            expr += "IRR(["+val;
        } else {
            expr += "|"+val;
        }
    }
    // alert("irrfaza, expr="+expr);
    if (perp != null && perp != "" && perp != "0") {
        expr += "+"+perp+"/("+juros+"%)";
    }
    if (i > 0) {
        expr += "])";
    } else {
        expr += "";
    }
    return expr;
}

function roifaza(fluxo, juros, perp) {
    // monta a expr: (-100 + NPV(20%|[-20|60|85|80])) / (100 + NPV(20%|[20]))
    fluxo = preparaFluxo(fluxo);
    if (perp == null) {
        perp = perpetuidade(fluxo);
    }
    fluxo = fluxo.replace("|...","").replace("...","");
    var invests = investimentos(fluxo);
    var toks = fluxo.split("|");
    var i=0;
    var expr = "(";
    var val;
    for (i in toks) {
        val = toks[i];
        if (i == 0) {
            expr +=val;
        } else {
            if (i == 1) {
                expr += " + NPV("+juros+"%|["+val;
            } else {
                expr += "|"+val;
            }
        }
    }
    if (perp != null && perp != "" && perp != "0") {
        expr += "+"+perp+"/("+juros+"%)";
    }
    if (i > 0) {
        expr += "])) / (";
    } else {
        expr += ") / (";
    }
    
    toks = invests.split("|");
    for (i in toks) {
        val = toks[i];
        if (i == 0) {
            expr +=val;
        } else {
            if (i == 1) {
                expr += " + NPV("+juros+"%|["+val;
            } else {
                expr += "|"+val;
            }
        }
    }
    if (i > 0) {
        expr += "]))";
    } else {
        expr += ")";
    }
    
    
    return expr;
}
function sumfaza(fluxo, invests) {
    // monta a expr: SUM([-100|-20|60|85|80]) / SUM([100|20])
    
    fluxo = preparaFluxo(fluxo);
    var toks = fluxo.split("|");
    var i=0;
    var expr = "";
    for (i in toks) {
        var val = toks[i];
        if (i == 0) {
            expr += "SUM(["+val;
        } else {
            expr += "|"+val;
        }
    }
    expr += "])/";
    
    toks = invests.split("|");
    for (i in toks) {
        var val = toks[i];
        if (i == 0) {
            expr += "SUM(["+val;
        } else {
            expr += "|"+val;
        }
    }
    expr += "])";
    
    return expr;
}

function paybackfaza(fluxo, taxa, decimais) {
    // monta a expr: payback([-100|-20|60|85|80])
    var expr = "payback("+taxa+"%| ["+preparaFluxo(fluxo)+"] | "+decimais+")";
    
    return expr;
}

function myTrim(x) {
    return x.replace(/^\s+|\s+$/gm,'');
}

function preparaFluxo(fluxo) {
    fluxo = myTrim(fluxo);
    fluxo = replaceAll(fluxo,"- ","-");
    fluxo = replaceAll(fluxo,";","|");
    fluxo = replaceAll(fluxo," ","|");
    fluxo = replaceAll(fluxo,"\n","|");
    fluxo = replaceAll(fluxo,"\t","|");
    fluxo = replaceAll(fluxo,"||","|");
    
    return fluxo;
}

function investimentos(fluxo) {
    fluxo = preparaFluxo(fluxo);
    var toks = fluxo.split("|");
    var i=0;
    var invests = "";
    for (i in toks) {
        var val = toks[i];
        var valn = preparaInput(val);
        if (!isNaN(valn)) {
            valn = parseFloat(valn);
            if (valn > 0) {
                break;
            } else {
                val = val.replace("-","");
                if (invests != "") invests += "|";
                invests += val;
            }
        }
    }
    return invests;
}

function preparaInput(val) {
    
    val = replaceTudo(".", "", val);
    val = replaceTudo(",", ".", val);
    
    return val;
}

function replaceTudo(x,y, val) {
    var oldval = "oldval";
    while(oldval != val) {
        oldval = val;
        val = oldval.replace(x,y);
    }
    return val;
}

function formatAsSimpleNum(valorstr) {
    valorstr = replaceAll(valorstr, '.', '');
    valorstr = replaceAll(valorstr, ',', '.');
    return valorstr;
}

var dirtyInputs = {};
function limpaft(inp) {
    //alert(inp);
    /*
     var inpid = inp.form.name+"_"+inp.name;
     if (dirtyInputs[inpid] == "DIRTY") return;
     dirtyInputs[inpid] = "DIRTY";
     inp.value = "";
     */
}

var formids = 0;
function initializeForms() {
    var forms = document.getElementsByTagName("FORM");
    for (i in forms) {
        var f = forms[i];
        if (f.oninput != null) {
            f.formcalc = formcalc;
            f.formcalc();
            if (f.name == null || f.name == "") {
                f.name="form"+(formids++);
            }
        }
    }
}

var iev = getInternetExplorerVersion();
function iecalc(i) {
    if (iev == -1 || iev > 8) return;
    //alert("i.form.out="+i.form.ir);
    i.form.formcalc();
}
function scrollBannerRight() {
    if (iev != -1) return; // variavel definida logo acima
    
    var scrollLeft = document.body.scrollLeft || document.documentElement.scrollLeft;
    var rightcolumn = document.getElementById("rightcolumn");
    var scrollTop = document.body.scrollTop || document.documentElement.scrollTop;
    
    if (scrollTop > 130 && scrollLeft == 0) {
        rightcolumn.style.position = "fixed";
        rightcolumn.style.top = scrollTop;
        rightcolumn.style.marginLeft = "914px";
    } else if (rightcolumn.style.position != "static") {
        rightcolumn.style.position = "static";
        rightcolumn.style.top = 0;
        rightcolumn.style.marginLeft = "0px";
    }
}
window.onscroll = scrollBannerRight;

function formcalc() {
    if (this.oninput != null) {
        try {
            this.oninput(); // if supports HTML5
        } catch (ex) {
            eval(this.oninput); // if does not support HTML5
        }
    }
}
function forcecalc(i) {
    i.form.formcalc();
}

function tucalc2(formula, prec, percent, inputv, inputf, ilabel,enus){
    var ptbr=true;
    if (enus) ptbr=false;
    return tucalc(formula, prec, ptbr, percent, true, inputv, inputf, ilabel);
}

//----------------
// BEGIN preparaDecimais
//----------------

function preparaDecimais(formula) {
    
    var valor = "";
    var formula2 = "";
    var ci;
    for (ci = 0; ci < formula.length; ci++) {
        var cc = formula.charAt(ci);
        if (!isNaN(cc) || cc == "." || cc == ",") {
            valor += cc;
        } else if (valor != ""){
            formula2 += normalizaDecimalPtBr(valor) + cc;
            valor = "";
        } else {
            formula2 += cc;
        }
    }
    if (valor != ""){
        formula2 += normalizaDecimalPtBr(valor);
    }
    
    return formula2;
}

/**
 Faz o melhor esforco para interpretar números decimais em qualquer formato de separadores . ou , por exemplo:
 122.124.455,32 -> 122124455,32 (pt-br)
 122,124,455.32 -> 122124455,32
 122.124.455 -> 122124455 (pt-br)
 122,124,455 -> 122124455
 134,123 -> 134,123 (pt-br)
 134.123 -> 134123 (pt-br)
 134123 -> 134123 (pt-br)
 **/
function normalizaDecimalPtBr(numStr) {
    var ci = numStr.length;
    var le;
    var ri = "";
    var tmp = "";
    var s = null;
    var sehdec = true;
    var sozinho = true;
    for (ci--; ci >= 0; ci--) {
        var cc = numStr.charAt(ci);
        if (s == cc) sehdec = false;
        if ( s == null && ( cc == "." || cc == ",") ) {
            s = cc
            ri = tmp;
            tmp = "";
        } else if (cc == "." || cc == ","){
            sozinho = false;
        }
        if (!isNaN(cc)) {
            tmp = cc + tmp;
        }
    }
    le = tmp;
    
    var resultado = le;
    if (sehdec && sozinho && s == ",") resultado = le + concatOuVazio(",",ri);
    if (sehdec && sozinho && s == ".") return le + ri;
    else if (sehdec) return le + concatOuVazio(",",ri);
    else return le + ri;
}
function concatOuVazio(se, ri) {
    if (ri != "") return se + ri;
    return "";
}

//----------------
// END preparaDecimais
//----------------

function tucalc(formula, prec, ptbr, percent, vonly, inputv, inputf, ilabel) {
    // expected formula is like PMT(1,5%|20|-110) or NPV(1,4%|[123,4;423;221,32])
    var formula = preparaDecimais(formula);
    
    var formulapt = translate2Pt(formula);
    var formulaen = translate2En(formula);
    //if (formula.indexOf("1500") >= 0) alert("DEBUG tucalc, formulapt="+formulapt+", formula="+formula);
    var retornoval = fucalc(formulaen,prec,percent);
    if (percent) retornoval += "%";
    
    if (formula.indexOf("NPV") != -1 || formula.indexOf("SUM") != -1 || formula.indexOf("PAYBACK") != -1) {
        formulapt = replaceAll(formulapt,"[","");
        formulapt = replaceAll(formulapt,"]","");
        formulaen = replaceAll(formulaen,"[","");
        formulaen = replaceAll(formulaen,"]","");
    } else if (formula.indexOf("IRR") != -1) {
        formulapt = replaceAll(formulapt,"[","{");
        formulapt = replaceAll(formulapt,"]","}");
        formulaen = replaceAll(formulaen,"[","{");
        formulaen = replaceAll(formulaen,"]","}");
    }
    var retornof = formulaen;
    if (ptbr) {
        retornof = formulapt;
    }
    if (inputv != null) {
        if (ilabel == null) ilabel = "R: ";
        if (ilabel.indexOf("???")!=-1) inputv.value = ilabel.replace("???",retornoval);
        else inputv.value = ilabel+retornoval;
    }
    if (inputf != null) {
        inputf.value = "="+retornof;
    }
    return retornoval;
    //alert(formula);
    if (vonly) return retornoval;
    return retornof + " = "+retornoval;
}

function fucalc(formula, prec, percent, retornoen) {
    // expected formula is like PMT(1.5%,20,-110) or NPV(1.4%,[123.4;423;221.32])
    if (percent) {
        prec += 2;
    }
    var valor = ucalc(formula,prec);
    if (percent) {
        valor *= 100;
        prec -= 2;
    }
    // convert valor from 1032334.00 to 1.032.334,00
    // alert("valor="+valor);
    var valorformated = convertNum2Pt(valor,prec);
    if (retornoen) valorformated = formatNumFromPt2En(valorformated);
    return valorformated;
}
function formatNumFromPt2En(valorstr) {
    valorstr = replaceAll(valorstr, '.', '|');
    valorstr = replaceAll(valorstr, ',', '.');
    valorstr = replaceAll(valorstr, '|', ',');
    return valorstr;
}
function convertNum2Pt(valor,prec) {
    if (prec == null) prec = 2;
    var negativo = false;
    var valorpt = "ERRO";
    if (valor != null) {
        valor = valor+"";
        if (valor.indexOf("e+") != -1) return valor.replace(".",",");
        if (valor.charAt(0) == "-") {
            valor = valor.replace("-","");
            negativo = true;
        }
        if (isNaN(valor)) {
            valorpt = valor;
        } else {
            valor = aproximaParaZero(valor);
            valorpt = "";
            var toks = valor.split(".");
            var len = toks[0].length;
            for (var c=0; c<len; c++) {
                var ci = len-1-c;
                if (c != 0 && c%3 == 0) valorpt = "."+valorpt;
                valorpt = toks[0].charAt(ci)+valorpt;
            }
            if (toks.length == 2) {
                if (toks[1].length < prec) {
                    toks[1] = toks[1] + zeros(prec - toks[1].length);
                    //alert("valor="+valor+" valorpt="+valorpt+" prec="+prec);
                }
                valorpt += ","+toks[1].substring(0,prec);
                
            } else {
                if (prec > 0) valorpt += "," + zeros(prec);
            }
        }
    }
    if (negativo) valorpt = "-"+valorpt;
    return valorpt;
}
function aproximaParaZero(valor) {
    if (valor.indexOf("e-") != -1) return "0";
    return valor;
}
function zeros(algs) {
    var k=0;
    var retorno = "";
    for (;k<algs;k++) {
        retorno += "0";
    }
    return retorno;
}

function ucalc(formula, prec) {
    if (prec == null) prec = 2;
    return universalcalc(formula, prec); // dependency on calcs.js
}
function translate2En(formula) {
    var formulaen = formula;
    //de PMT(1,5%|20|-110) para PMT(1.5%,20,-110)
    formulaen = replaceAll(formulaen, ",",".")
    formulaen = replaceAll(formulaen, "|",",");
    formulaen = replaceAll(formulaen, ";",",");
    formulaen = replaceAll(formulaen, "--","+");
    formulaen = replaceAll(formulaen, "-+","+");
    formulaen = replaceAll(formulaen, "%%","%");
    return formulaen;
}
function translate2Pt(formula) {
    var formulaen = formula;
    //de PMT(1,5%|20|-110) para PGTO(1,5%;20;-110)
    formulaen = replaceAll(formulaen,"PMT","PGTO");
    formulaen = replaceAll(formulaen,"SUM","SOMA");
    formulaen = replaceAll(formulaen,"NPV","VAL");
    formulaen = replaceAll(formulaen,"PV","VA");
    formulaen = replaceAll(formulaen,"IRR","TIR");
    formulaen = replaceAll(formulaen,"FV","VF");
    formulaen = replaceAll(formulaen,"RATE","TAXA");
    formulaen = replaceAll(formulaen,"NPER","NPER");
    formulaen = replaceAll(formulaen,"POW","POTÊNCIA");
    formulaen = replaceAll(formulaen, ".",",")
    formulaen = replaceAll(formulaen, "|",";");
    formulaen = replaceAll(formulaen, "--","+");
    formulaen = replaceAll(formulaen, "-+","+");
    formulaen = replaceAll(formulaen, "%%","%");
    return formulaen;
}
function replaceAll(str, a, b) {
    if (str == null || a == b) return str;
    while (str.indexOf(a) >= 0) {
        str = str.replace(a, b);
    }
    return str;
}

function getInternetExplorerVersion() {
    var rv = -1; // Return value assumes failure.
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (re.exec(ua) != null)
            rv = parseFloat(RegExp.$1);
    }
    return rv;
}

function comp_financiamento(np,ir,pv,periodo,tipo) {
    
    switch (tipo.selectedIndex) {
        case 0:
            comp_price(np,ir,pv,periodo);
            break;
        case 1:
            comp_sac(np,ir,pv,periodo);
            break;
        case 2: // sistema americano
            comp_americano(np,ir,pv,periodo);
            break;
        case 3: // pagamento unico
            comp_pgunico(np,ir,pv,periodo);
            break;
    }
    
}

function comp_pgunico(anp,air,apv,aperiodo) {
    var sac = "<table class='sac'>";
    anp = parseFloat(translate2En(anp+""));
    air = parseFloat(translate2En(air+""))/100;
    apv = parseFloat(translate2En(apv+""));
    // alert("periodo="+periodo);
    
    var periodo = "mensal";
    var selected_index = aperiodo.selectedIndex;
    if (selected_index > 0) {
        periodo = aperiodo.options[selected_index].value;
    }
    
    if (periodo == "anual") {
        air = comp_mir(12,null, air);
    }
    // alert("air="+air+" anp="+anp+" apv="+apv);
    var i = 0;
    var amortizacao = 0;
    var totalJuros = 0;
    var totalAmort = 0;
    var totalParc = 0;
    var saldoDevedor = apv;
    for (i=0; i<anp-1; i++) {
        var parcela = 0;
        var juros = saldoDevedor;
        saldoDevedor += saldoDevedor*air;
        juros = saldoDevedor - juros;
        sac += "<tr><td width='30'>"+(i+1)+"</td><td width='125'>"+convertNum2Pt(parcela)+"</td><td width='125'>"+convertNum2Pt(amortizacao)+"</td><td width='125'>"+convertNum2Pt(juros)+"</td><td width='125'>"+convertNum2Pt(saldoDevedor)+"</td></tr>";
        totalJuros += juros;
    }
    { // ultimo mes faz o pagamento da divida inicial + juros do ultimo periodo
        var amortizacao = saldoDevedor;
        saldoDevedor += saldoDevedor*air;
        var juros = saldoDevedor - amortizacao;
        var parcela = saldoDevedor;
        sac += "<tr><td width='30'>"+(i+1)+"</td><td width='125'>"+convertNum2Pt(parcela)+"</td><td width='125'>"+convertNum2Pt(amortizacao)+"</td><td width='125'>"+convertNum2Pt(juros)+"</td><td width='125'>"+convertNum2Pt(0)+"</td></tr>";
        totalJuros += juros;
        totalAmort += amortizacao;
        totalParc += parcela;
    }
    sac += "<tr><td width='30' style='font-weight:bold;'> » </td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalParc)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalAmort)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalJuros)+"</td><td width='125' style='font-weight:bold;'>« TOTAIS </td></tr>";
    sac += "</table>";
    
    document.getElementById('sac_result').innerHTML = sac;
    
}

function comp_americano(anp,air,apv,aperiodo) {
    var sac = "<table class='sac'>";
    anp = parseFloat(translate2En(anp+""));
    air = parseFloat(translate2En(air+""))/100;
    apv = parseFloat(translate2En(apv+""));
    // alert("periodo="+periodo);
    
    var periodo = "mensal";
    var selected_index = aperiodo.selectedIndex;
    if (selected_index > 0) {
        periodo = aperiodo.options[selected_index].value;
    }
    
    if (periodo == "anual") {
        air = comp_mir(12,null, air);
    }
    // alert("air="+air+" anp="+anp+" apv="+apv);
    var i = 0;
    var amortizacao = 0;
    var totalJuros = 0;
    var totalAmort = 0;
    var totalParc = 0;
    for (i=0; i<anp-1; i++) {
        var parcela = amortizacao + apv*air;
        sac += "<tr><td width='30'>"+(i+1)+"</td><td width='125'>"+convertNum2Pt(parcela)+"</td><td width='125'>"+convertNum2Pt(amortizacao)+"</td><td width='125'>"+convertNum2Pt(apv*air)+"</td><td width='125'>"+convertNum2Pt(apv-amortizacao)+"</td></tr>";
        totalJuros += apv*air;
        totalAmort += amortizacao;
        totalParc += parcela;
        apv -= amortizacao;
    }
    { // ultimo mes faz o pagamento da divida inicial + juros do ultimo periodo
        amortizacao = apv;
        var parcela = amortizacao + apv*air;
        sac += "<tr><td width='30'>"+(i+1)+"</td><td width='125'>"+convertNum2Pt(parcela)+"</td><td width='125'>"+convertNum2Pt(amortizacao)+"</td><td width='125'>"+convertNum2Pt(apv*air)+"</td><td width='125'>"+convertNum2Pt(apv-amortizacao)+"</td></tr>";
        totalJuros += apv*air;
        totalAmort += amortizacao;
        totalParc += parcela;
        apv -= amortizacao;
    }
    sac += "<tr><td width='30' style='font-weight:bold;'> » </td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalParc)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalAmort)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalJuros)+"</td><td width='125' style='font-weight:bold;'>« TOTAIS </td></tr>";
    sac += "</table>";
    
    document.getElementById('sac_result').innerHTML = sac;
    
}

function comp_sac(anp,air,apv,aperiodo) {
    var sac = "<table class='sac'>";
    anp = parseFloat(translate2En(anp+""));
    air = parseFloat(translate2En(air+""))/100;
    apv = parseFloat(translate2En(apv+""));
    // alert("periodo="+periodo);
    
    var periodo = "mensal";
    var selected_index = aperiodo.selectedIndex;
    if (selected_index > 0) {
        periodo = aperiodo.options[selected_index].value;
    }
    
    if (periodo == "anual") {
        air = comp_mir(12,null, air);
    }
    // alert("air="+air+" anp="+anp+" apv="+apv);
    var i = 0;
    var amortizacao = apv/anp;
    var totalJuros = 0;
    var totalAmort = 0;
    var totalParc = 0;
    for (i=0; i<anp; i++) {
        var parcela = amortizacao + apv*air;
        sac += "<tr><td width='30'>"+(i+1)+"</td><td width='125'>"+convertNum2Pt(parcela)+"</td><td width='125'>"+convertNum2Pt(amortizacao)+"</td><td width='125'>"+convertNum2Pt(apv*air)+"</td><td width='125'>"+convertNum2Pt(apv-amortizacao)+"</td></tr>";
        totalJuros += apv*air;
        totalAmort += amortizacao;
        totalParc += parcela;
        apv -= amortizacao;
    }
    sac += "<tr><td width='30' style='font-weight:bold;'> » </td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalParc)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalAmort)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalJuros)+"</td><td width='125' style='font-weight:bold;'>« TOTAIS </td></tr>";
    sac += "</table>";
    
    document.getElementById('sac_result').innerHTML = sac;
    
}

function comp_price(anp,air,apv,aperiodo) {
    var sac = "<table class='sac'>";
    anp = parseFloat(translate2En(anp+""));
    air = parseFloat(translate2En(air+""))/100;
    apv = parseFloat(translate2En(apv+""));
    // alert("periodo="+periodo);
    
    var periodo = "mensal";
    var selected_index = aperiodo.selectedIndex;
    if (selected_index > 0) {
        periodo = aperiodo.options[selected_index].value;
    }
    
    if (periodo == "anual") {
        air = comp_mir(12,null, air);
    }
    // alert("air="+air+" anp="+anp+" apv="+apv);
    var i = 0;
    var parcela = pmt(air,anp,-apv);
    var totalJuros = 0;
    var totalAmort = 0;
    var totalParc = 0;
    for (i=0; i<anp; i++) {
        var amortizacao = parcela-apv*air;
        sac += "<tr><td width='30'>"+(i+1)+"</td><td width='125'>"+convertNum2Pt(parcela)+"</td><td width='125'>"+convertNum2Pt(amortizacao)+"</td><td width='125'>"+convertNum2Pt(apv*air)+"</td><td width='125'>"+convertNum2Pt(apv-amortizacao)+"</td></tr>";
        totalJuros += apv*air;
        totalAmort += amortizacao;
        totalParc += parcela;
        apv -= amortizacao;
    }
    sac += "<tr><td width='30' style='font-weight:bold;'> » </td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalParc)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalAmort)+"</td><td width='125' style='font-weight:bold;'>"+convertNum2Pt(totalJuros)+"</td><td width='125' style='font-weight:bold;'>« TOTAIS </td></tr>";
    sac += "</table>";
    
    document.getElementById('sac_result').innerHTML = sac;
    
}


function num_format(v,places,dest,delim,radix) { // format numbers with "places" digits
    var x = Math.abs(v);
    var m = Math.pow(10,places);
    var x = Math.floor(x * m + .5);
    var i = places;
    var n = 16;
    var sx = "";
    while(n-- > 0 && (((i--) >= 0) || (x > 0))) {
        if(i < -1) {
            sx = (((i+1) % 3 == 0)?delim:"") + sx;
        }
        sx = (x % 10) + sx;
        x = Math.floor(x / 10);
        if(i == 0) {
            sx = radix + sx;
        }
    }
    if(v < 0) {
        sx = "-" + sx;
    }
    if (dest != null) {
        dest.value = sx;
        set_cell_color(dest,v);
    }
    return sx;
}


/*
	div popup para pedido de like no fb
 */
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}
function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
    }
    return "";
}

function solicitafblike() {
    var dt = new Date();
    var yyddmm = (dt.getFullYear()%100)*10000 + (dt.getMonth()+1)*100 + dt.getDate();
    var fbfazc = getCookie("fbfazc");
    
    // se ja foi exibido, termina
    if (fbfazc.indexOf("fblikeasked") != -1) return;
    // determina se deve ser exibido (tem data de hoje e >= 2 dias)	
    if (fbfazc.indexOf(""+yyddmm) != -1 && fbfazc.length/6 >= 2) {
        mostraPainelFb();
        setCookie("fbfazc", "fblikeasked", 365*3);
    } else if (fbfazc.indexOf(""+yyddmm) == -1) {
        setCookie("fbfazc", fbfazc+yyddmm, 365*3);
    }
}

function mostraPainelFb() {
    montaPainelFb();
    document.getElementById('lightfb').style.display='block';
    document.getElementById('fadefb').style.display='block';
}
function escondePainelFb() {
    document.getElementById('lightfb').style.display='none';
    document.getElementById('fadefb').style.display='none';
}

function montaPainelFb() {
    var painelfb = '<div id="lightfb" class="white_content" >'+
    '<h2 style="color:white">Se você gostou do site, dê um "curtir" no <b>facebook</b> e ajude o <b>fazAconta</b> a ajudar mais pessoas:</h2>'+
    '<br>'+
    '<iframe src="//www.facebook.com/plugins/like.php?href=http%3A%2F%2Ffazaconta.com&amp;send=false&amp;layout=standard&amp;width=220&amp;show_faces=true&amp;action=like&amp;colorscheme=light&amp;font&amp;height=80" scrolling="no" frameborder="0" style="border:4px solid #e9eaed; overflow:hidden; width:225px; height:85px;  background-color:white" allowTransparency="true"></iframe>'+
    '<br><br>'+
    '<p>Não iremos te incomodar mais...</p>'+
    '<p>Muito Obrigado!<br>'+
    'Equipe fazAconta.com</p>'+
    '<div style="text-align:right;padding-right:15px;">'+
    '<a href = "javascript:void(0)" onclick = "escondePainelFb()" style="color:white;">Fechar</a></div>'+
    '</div>'+
    '<div id="fadefb" class="black_overlay" onclick="escondePainelFb()"></div>';
    document.getElementById('divpopupfb').innerHTML = painelfb;
}


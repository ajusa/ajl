import osproc, os, strutils, sequtils
proc impToInc(imp:string):string = 
    var s = imp.replace("import ", "").split(",")
    for i in 0..s.high:
        if s[i].contains('"'): #for importing actual files
            s[i] = ("#include "&s[i].strip).strip
        else:
            s[i] = ("#include "&"<"&s[i].strip&">").strip
    s.join("\n")

proc imports(list: seq[string]): seq[string] = 
    var cp = list
    for i in countdown(cp.high, cp.low): 
        if cp[i].strip.startsWith("import"): 
            cp[i] = impToInc(cp[i]) & "\n" 
        if cp[i].strip.startsWith("include") and not cp[i].contains("#"):
            var space = cp[i].split("inc")[0]
            var file = readFile(cp[i].replace("include").strip)
            var tmp = imports(file.splitLines)
            cp[i] = ""
            for j in tmp.low..tmp.high:
                tmp[j] = space & tmp[j]
            cp.insert(tmp, i)
    return cp.join("\n").splitLines

var filename: string = paramStr(1)
var src = readFile(filename)
#actual code here
var baseFile = "using namespace std;\n$code"
var byLine = src.splitLines
#CPP embedding [TODO]
#Removing comments and replacing var with auto
for i in countdown(byLine.high, byLine.low): 
    if "#" in byLine[i].strip: 
        byLine[i] = byLine[i].split("#")[0]
    byLine[i] = byLine[i].replace("var", "auto")
#Handling Imports and Includes
byLine = byLine.imports
#Removing comments and replacing var with auto, making sure not to clear any imports
for i in countdown(byLine.high, byLine.low): 
    if "#" in byLine[i].strip and not byLine[i].strip.contains("#include"): 
        byLine[i] = byLine[i].split("#")[0]
    byLine[i] = byLine[i].replace("var", "auto")
#Turning methods into function calls, var.function = function(var)
#This is probably the worst way of doing this. Needs to be rewritten to handle more cases
for i in 0..byLine.high:
    if ".." in byLine[i]: #to optimize when we split
        var tokens = byLine[i].split(" ")
        for j in 0..tokens.high:
            if tokens[j].contains(".."):
                var toAdd = ""
                var value = tokens[j].split("..")[0].strip #this is the first arg
                if tokens[j].split("..")[1].split("(")[1].strip.len > 1:
                    toAdd = ", "
                tokens[j] = tokens[j].replace(value).replace("(", "("&value&toAdd).replace("..")
        byLine[i] = tokens.join(" ")

#brackets for flow statements and other tab deliminated things
var flows = @["if ", "for ", "while ", "elif ", "else"]
var count = 0
var lookForFlow = false
for i in 0..byLine.high: 
    if lookForFlow and byLine[i].count("\t") == count:
        byLine[i-1] = byLine[i-1] & "\n"&'\t'.repeat(count)&"}$"
        lookForFlow = false
    elif i==byLine.high and lookForFlow: 
        byLine[i] = byLine[i] & "\n"&'\t'.repeat(count)&"}$"
        lookForFlow = false
    for flow in flows:
        if byLine[i].strip.startsWith(flow): #all of this code is super bad, but it works
            for j in 0..(byLine[i].split(":")[0].count(",")): byLine[i] = byLine[i].replace(",", ";") #replace commas with semicolons (for loops)
            if flow == "else":
                 byLine[i] = byLine[i].replace(":", "{")
            else:
                byLine[i] = byLine[i].replace(flow, flow&"(").replace(":", "){").replace(" in", ":").replace("elif ", "else if")

            if i == byLine.high:
                byLine[i] = byLine[i] & "\n"&'\t'.repeat(count)&"}"
            else:
                count = byLine[i].count("\t")
                lookForFlow = true
#Rebuilding the file
byLine = byLine.join("\n").splitLines
#Removing Empty lines
for i in countdown(byLine.high, byLine.low): 
    if byLine[i].isNilOrWhitespace: byLine.delete(i)
#functions
count = 0
var lookForFunc = false
for i in 0..byLine.high: 
    if lookForFunc and byLine[i].count("\t") <= count:
        byLine[i-1] = byLine[i-1] & "\n"&'\t'.repeat(count)&"}"
        lookForFunc = false
    elif i==byLine.high and lookForFunc: 
        byLine[i] = byLine[i] & "\n"&'\t'.repeat(count)&"}"
        lookForFunc = false
    if "=>" in byLine[i].strip:
        count = byLine[i].count("\t")
        byLine[i] = byLine[i].replace("::", "$")
        byLine[i] = byLine[i].replace("=>", "{")
        byLine[i] = byLine[i].replace("$", "::")
        lookForFunc = true

#Rebuilding the file
byLine = byLine.join("\n").splitLines
#Removing Empty lines
for i in countdown(byLine.high, byLine.low): 
    if byLine[i].isNilOrWhitespace: byLine.delete(i)

#Classes
count = 0
var lookForClass = false
for i in 0..byLine.high: 
    if lookForClass and byLine[i].count("\t") <= count:
        byLine[i-1] = byLine[i-1] & "\n"&'\t'.repeat(count)&"}"
        lookForClass = false
    elif i==byLine.high and lookForClass: 
        byLine[i] = byLine[i] & "\n"&'\t'.repeat(count)&"}"
        lookForClass = false
    if byLine[i].strip.startsWith("class"):
        count = byLine[i].count("\t")
        byLine[i] = byLine[i].replace(":", "{")
        lookForClass = true
        if "from " in byLine[i]:
            byLine[i] = byLine[i].replace("from ", ": public ")
#Adding and tabs semicolons where needed
for i in 0..byLine.high: 
    if not byLine[i].isNilOrWhitespace and not byLine[i].strip.endsWith("{") and not byLine[i].contains("#include") and not byLine[i].strip.endsWith(":") and not byLine[i].contains("template"):
        byLine[i] = (byLine[i] & ";").replace("$;")

src = baseFile % ["code", byLine.join("\n")] #last thing to do
writeFile(filename.split(".")[0]&".cpp", src)
echo execProcess("g++ "& filename.split(".")[0]&".cpp")
echo execProcess("a.exe")
import osproc, os, strutils, sequtils
proc impToInc(imp:string):string = 
    var s = imp.replace("import ", "").split(",")
    for i in 0..s.high: s[i] = ("#include "&"<"&s[i].strip&">").strip
    s.join("\n")

proc imports(list: seq[string]): seq[string] = 
    var cp = list
    for i in countdown(cp.high, cp.low): 
        if "import" in cp[i]: 
            cp[i] = impToInc(cp[i]) & "\n" 
        if "include" in cp[i] and not cp[i].contains("#"):
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
var baseFile = "using namespace std;\n $code"
var byLine = src.splitLines
#Removing comments and replacing var with auto
for i in countdown(byLine.high, byLine.low): 
    if byLine[i].strip.startsWith("#"): byLine.delete(i)
    byline[i] = byLine[i].replace("var", "auto")
#Handling Imports and Includes
byLine = byLine.imports
#brackets for flow statements and other tab deliminated things
var flows = @["if ", "for "]
for flow in flows:
    var count = 0
    var lookForFlow = false
    for i in 0..byLine.high: 
        if lookForFlow and byLine[i].count("\t") == count:
            byLine[i-1] = byLine[i-1] & "\n"&'\t'.repeat(count)&"}"
            lookForFlow = false
        elif i==byLine.high and lookForFlow: 
            byLine[i] = byLine[i] & "\n"&'\t'.repeat(count)&"}"
            lookForFlow = false
        if byLine[i].strip.startsWith(flow): #all of this code is super bad, but it works
            for j in 0..(byLine[i].split(":")[0].count(",")):
                byLine[i] = byLine[i].replace(",", ";")
            byLine[i] = byLine[i].replace(flow, flow&"(").replace(":", "){").replace(" in", ":")
            if i == byLine.high:
                byLine[i] = byLine[i] & "}"
            else:
                count = byLine[i].count("\t")
                lookForFlow = true
#Rebuilding the file
byLine = byLine.join("\n").splitLines
#Removing Empty lines
for i in countdown(byLine.high, byLine.low): 
    if byLine[i].isNilOrWhitespace: byLine.delete(i)
#functions
var count = 0
var lookForFunc = false
for i in 0..byLine.high: 
    if lookForFunc and byLine[i].count("\t") <= count:
        byLine[i-1] = byLine[i-1] & "\n"&'\t'.repeat(count)&"}"
        lookForFunc = false
    elif i==byLine.high and lookForFunc: 
        byLine[i] = byLine[i] & "\n"&'\t'.repeat(count)&"}"
        lookForFunc = false
    if byLine[i].strip.startsWith("func"):
        count = byLine[i].count("\t")
        byLine[i] = byLine[i].replace("::", "$")
        var Type = byLine[i].split(":")[1].strip
        if " " in Type: Type = Type.split(" ")[0] #for inline functions
        byLine[i] = byLine[i].replace(":", "{").replace(Type).replace("func", Type.strip)
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
#Adding and tabs semicolons where needed
for i in 0..byLine.high: 
    if not byLine[i].isNilOrWhitespace and not byLine[i].strip.endsWith("{") and not byLine[i].contains("#include") and not byLine[i].strip.endsWith(":"):
        byLine[i] = byLine[i] & ";"

src = baseFile % ["code", byLine.join("\n")] #last thing to do
writeFile(filename.split(".")[0]&".cpp", src)
echo execProcess("g++ "& filename.split(".")[0]&".cpp")
echo execProcess("a.exe")
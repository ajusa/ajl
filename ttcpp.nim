import osproc, os, strutils
proc impToInc(imp:string):string = 
    var s = imp.replace("import ", "").split(",")
    for i in 0..s.high: s[i] = "#include "&"<"&s[i].strip&">"
    s.join("\n")

var filename: string = paramStr(1)
var src = readFile(filename)
#actual code here
var baseFile = """
using namespace std;
$code
"""
var byLine = src.splitLines
#Handling Imports and Includes
for i in countdown(byLine.high, byLine.low): 
    if "import" in byLine[i]: 
        baseFile = impToInc(byLine[i])& "\n" & baseFile
        byLine.delete(i)
    if "include" in byLine[i]:
        byLine[i] = byLine[i].split("inc")[0] & readFile(byLine[i].replace("include").strip)
byLine = byLine.join("\n").splitLines

#brackets for flow statements and other tab deliminated things
var flows = @["if ", "for "]
for flow in flows:
    var count = 0
    var lookForFlow = false
    for i in 0..byLine.high: 
        if lookForFlow and byLine[i].count("\t") == count:
            byLine[i-1] = byLine[i-1] & "\n}"
            lookForFlow = false
        if byLine[i].strip.startsWith(flow):
            count = byLine[i].count("\t")
            byLine[i] = byLine[i].replace(flow, flow&"(").replace(":", "){")
            lookForFlow = true
#functions
var count = 0
var lookForFunc = false
for i in 0..byLine.high: 
    if lookForFunc and byLine[i].count("\t") == count:
        byLine[i-1] = byLine[i-1] & "\n}"
        lookForFunc = false
    if byLine[i].strip.startsWith("func"):
        count = byLine[i].count("\t")
        var Type = byLine[i].split(":")[1]
        byLine[i] = byLine[i].replace(":", "{").replace(Type).replace("func", Type)
        lookForFunc = true
#Removing Empty lines
for i in countdown(byLine.high, byLine.low): 
    if byLine[i].isNilOrWhitespace: byLine.delete(i)

#Rebuilding the file
byLine = byLine.join("\n").splitLines

#Adding and tabs semicolons where needed
for i in 0..byLine.high: 
    byLine[i] = "\t" & byLine[i] & ";"

src = baseFile % ["code", byLine.join("\n")] #last thing to do
writeFile(filename.split(".")[0]&".cpp", src)
echo execProcess("g++ "& filename.split(".")[0]&".cpp")
echo execProcess("a.exe")
# AJL

A simple compile to c++ language
## Why?
Why did I make this? After all, Nim exists, and the first version of this compiler is written in Nim.

AJL was created to address a specific problem I had: the USACO. I wanted to write python, but they said that "Python cannot solve all the test cases".
So, to show them, I created my own programming language, spending more time to avoid writing C++...

Anyway, this will generate one C++ file, and that is it. It has full interop with any C++ library, although single header files work best. You get a Pythonic syntax, with the speed and 
power of C++.

## Installation
1. Make sure that you have g++ installed on your system. If you don't, you can get it for Windows [here](http://www1.cmc.edu/pages/faculty/alee/g++/g++.html).
2. Check that it is on your PATH by typing `g++ -v`. If it isn't, add it
3. Clone this repository, or hit the download zip button. Extract, and add the directory to your PATH. (Note, you may need the contents of the folder in your project. Not sure yet)
4. To build a file, do `ajl filename.ajl`, and it will spit out a filename.cpp and a.exe, which is your executable. It will also run the code right after.

## Guide[WIP]
**Hello World!**
```Nim
include std/io.ajl
int main() => print("Hello World!")
```

**Declaring Variables**
```Nim
var a = 5
float b = 2.0
bool c = true
```
var can be used for some type inferring

**Flow Statements**
```Nim
if c: println("c is true!")
```

**Loop Statements**
```Nim
var i = 0
while i<5:
	println(i)
	i++

vector<int> dog_ids #note, this will require you to "import vector" in your file
for int i = 0, i < 3, i++: 
	dog_ids.push_back(i)
for var elem in dog_ids: println(elem)
```

**.. Operator**
```Nim
println(elem) #or
elem..println() #makes more sense when you realize that one cannot add methods to STL code in C++
```
Anything that isn't covered here but works in C++, will most likely work. Keep in mind, the std namespace is used by default.

For more examples, look at the demo.ajl file located in the root of this repository.
# AJL

A simple whitespace-sensitive transpile to c++ language
## Why?
Why did I make this? After all, Nim exists, and the first version of this compiler is written in Nim. 

AJL was created to address a specific problem I had: the USACO. I wanted to write python, but they said that "Python cannot solve all the test cases".
While Nim does have a compile to C++ option, it is tied to the OS, and I didn't want to deal with cross compilation issues. Also, the Nim library took up roughly half the 
limit on filesize.
So, to show the USACO, I created my own programming language, spending more time to avoid writing C++...

Anyway, this will generate one C++ file, and that is it. It has full interop with any C++ library, although single header files work best. You get a Pythonic syntax, with the speed and 
power of C++. I find that writing less code and reading less code leads to better algorithims and faster debugging, making it ideal for programming competitions where 
C++ is allowed, and speed is key.

## Installation
1. Make sure that you have g++ installed on your system. If you don't, you can get it for Windows [here](http://www1.cmc.edu/pages/faculty/alee/g++/g++.html).
2. Check that it is on your PATH by typing `g++ -v`. If it isn't, add it
3. Clone this repository, or hit the download zip button. Extract, and add the directory to your PATH. (Note, you may need the contents of the folder in your project. Not sure yet)
4. To build a file, do `ajl filename.ajl`, and it will spit out a filename.cpp. 
5. To compile a file, do `g++ filename.cpp`, and run the a.exe that is generated.

### Other Operating Systems
1. Find the best way to install [Nim](https://nim-lang.org/)
2. Run `nim c ajl.nim`
3. Use the binary similarly to the steps outlines above.

## Guide[WIP]
**Indentation and Syntax Highlighting**
At this point in time, only tabs are allowed. Tabs are used to determine when statements end.
There is currently no syntax highlighting avalible. If someone creates one, feel free to make an issue and I'll add it to this README.
For now, I reccomend Nim highlighting, or Python.

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

**Import vs Include Statements**
```Nim
import vector, string, iostream
include std/io.ajl
```
Import statements are for C++. This code turns each thing into "#include vector" and so on

Include statements are built into the compiler. The compiler hunts for the file you are trying to include, and adds it to the source directly. It then processes it through the
pipeline as well.

**Loops**
```Nim
var i = 0
while i<5:
	println(i)
	i++
vector<int> dog_ids # note, this will require you to "import vector" in your file
for int i = 0, i < 3, i++: 
	dog_ids.push_back(i)
for var elem in dog_ids: println(elem)
```

**.. Operator**
```Nim
println(elem) # which is the same as...
elem..println() # makes more sense when you realize that one cannot add methods to STL code in C++
```

**Functions**
```Nim
void asdf(string thing, int other) =>
	var sq = other*other
	#do some stuff here
```
Pretty similar to normal C/C++ functions. Templates also work as expected.

**Clases/Inheritance**
```Nim
class Rectangle:
	int width, height # Private by default
	public:
		void set_values (int,int)
		int area() => return width*height # Defining within the class
void Rectangle::set_values(int x, int y) => # Can also be defined elsewhere
	width = x
	height = y

class Square from Rectangle: # From signifies the inheritance
	int length
	public: void setSide(int x) => length = x
```
Many C++ constructs (such as friends, or multiple inheritances) haven't been implemented yet, but it is rare to have to use them.
I do plan on adding them some time in the future.

Anything that isn't covered here but works in C++, will most likely work. Keep in mind, the std namespace is used by default.

For more examples, look at the demo.ajl file located in the root of this repository.
using namespace std;
 #include <iostream>
#include <string>
#include <algorithm>
class Rectangle{
    	int width, height;
	public:
	    void set_values (int,int);
	    int area(){
	    	return width*height;
	}
};
void Rectangle::set_values(int x, int y){
	width = x;
	height = y;
};
void asdf(string thing){
	cout << "I love the void";
};
int main(){
	cout << "My name is arham";
	auto arham = true;
	if (arham){ 
		cout << "ya \n";
	};
	cout << "Arham is the best";
	asdf("hello");
	if (!arham){ cout << "broke the code lol";
	};
	return 1;
};
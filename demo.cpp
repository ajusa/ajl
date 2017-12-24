using namespace std;
#include <string>
#include <vector>
#include <iostream>
template <typename T> 
void print(T t) {
	cout << t;
};
template <typename T> 
void println(T t) {
	cout << t << endl;
};
class Rectangle{
	int width, height;
	public:
		void set_values (int,int);
		int area() { return width*height;
		}
};
void Rectangle::set_values(int x, int y) {
	width = x;
	height = y;
};
class Square : public Rectangle{
	int length;
	public: void setSide(int x) { length = x;
	}
};
void asdf(string thing, int other) {
	cout << "I love the void";
};
int main() {
	auto rect = Rectangle();
	rect.set_values(5,6);
	print(rect.area());
	printf("Printf test");
	auto temp= "other test";
	printf(temp);
	asdf(temp, 5);
	auto i = 0;
	while (i<5){
		cout << i << endl;
		i++;
	};
	auto arham = true;
	vector<int> dog_ids;
	for (int i = 0; i < 3; i++){ dog_ids.push_back(i);
	};
	for (auto elem: dog_ids){ cout << elem << endl;
	};
	if (arham){ cout << "ya \n";
	};
	asdf("hello", 2);
	if (!arham){ cout << "broke the code lol";
	};
};
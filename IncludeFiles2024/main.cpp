#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern FILE *yyin;
FILE* output;
extern void switch_input_file(char* file);
int main(int argc, char *argv[])
{
	fopen_s(&yyin, argv[1], "r");
	fopen_s(&output, argv[2], "w");
	switch_input_file(argv[1]);
	yylex();
	fclose(output);
	fclose(yyin);
	
	return 0;
}
 
 
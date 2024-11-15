%option noyywrap

%{
#include <stack>
#define ECHO
void switch_input_file(char *filename);
extern FILE *output;
char filename[256];
std::stack<YY_BUFFER_STATE> yystatebuffer;
FILE *files[3]={0};
int currentfile=-1;
%}

%x INCLUDE 

%%
 char c;

#[ \t]*include[ \t]+\" { printf("%s", yytext); BEGIN INCLUDE; }
<INCLUDE>[^ \t>"]* { printf("%s", yytext);
				     strcpy_s(filename, sizeof(filename), yytext);
					 printf("filename: \n%s\n", filename);
					 c=0;
				     while( c!= '>' && c!= '\"' ){
				        c = yyinput();
				     }
					 switch_input_file(yytext);
					 BEGIN(INITIAL); }

.|\n { fprintf(output, "%s", yytext); }

<<EOF>> { fclose(files[currentfile]);
		  yystatebuffer.pop();
		  currentfile--;
		  if (yystatebuffer.empty()){
			  yyterminate(); 
		  }
		  else{			  
			  yy_switch_to_buffer(yystatebuffer.top());			  
		  }
		}


%%

void switch_input_file(char *filename){
	currentfile++;
	fopen_s(&files[currentfile],filename,"r");
	yystatebuffer.push(yy_create_buffer(files[currentfile], YY_BUF_SIZE));
	yy_switch_to_buffer(yystatebuffer.top());
}
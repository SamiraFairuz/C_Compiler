%{
	#include <stdio.h>
	#include<string.h>
	#include "calcusum20.tab.h"
	extern void yyerror(char *s);
%}

%%
"exit"					{return EXIT;}
"int"					{return INT;}
"\n"					{return END;}
"void"					{return VOID;}
"if"					{return IF;}
"else"					{return ELSE;}
"return"				{return RETURN;}
"&&"					{return AND;}
"||"					{return OR;}
"{"						{return *yytext;}
"}"						{return *yytext;}
"=="					{return *yytext;}
"()"					{return *yytext;}
"--"					{return *yytext;}
[\t ]					;
[a-zA-Z]+				{yylval.c = strdup(yytext); return ID;}
[+*/%=][+*/%=]			{return *yytext;}
[\)\(\+\*%/-]		    {return yytext[0];}
"="						{return *yytext;}
[0-9][0-9]*				{yylval.num = atoi(yytext); return NUM;}
.						{return *yytext;}

%%

int yywrap()
{
	return 1;
}

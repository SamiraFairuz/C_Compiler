%{
	#include <stdio.h>
	#include <stdlib.h>
	#include<string.h>
	extern int yylex();
	extern void yyerror();
	typedef struct{int value; char *name;} store;
	store sym[52];
	int count=0;
	int searchVal(char *ch);
	int setVal(char *ch, int a);


%}

%start	st
%union 	{int num; 
		char *c;}
%term <num> EXIT NUM END
%token <c> INT VOID IF ELSE RETURN ID AND OR 
%type <num> st statement exp ter min mult div mod me de pe ae se pp mm exp2 if_cond func_def statements

%%

st	: EXIT					{return 0;}
   	| aug st
	;
aug	: statements END
if_cond : IF '(' exp2 ')' '{' statement '}'		{printf("reached if-block"); if($3==1){$$=$6;}} 
		| IF '(' exp2 ')' '{' statement '}' ELSE '{' statement '}'		{printf("reached ifel-second-block"); if($3==1){$$=$6;} else{$$=$10;}}	
	 ;		
return_st: RETURN exp 		{printf("%d\n", $2);}
		 | RETURN pp		{printf("%d\n", $2);}
		 | RETURN mm		{printf("%d\n", $2);}	
		 ;
statements: 
		  |statements statement
		  ; 
statement : exp ';'
		  | me ';'
		  | de ';'
		  |	pe ';'
		  | ae ';'
		  | se ';'
		  | pp ';'
		  | mm ';'
		  | if_cond 
		  | return_st ';'
		  | func_def 
		  ;	  	
exp : exp '+' min	{$$ = $1 + $3;}
	| INT ID '=' exp 	{printf("assigning...\n"); $$=setVal($2,$4); }
    | min		
	;
min : min '-' ter 	{$$ = $1 - $3;}
	|ter	
ter	: ter '*' mult	{$$ = $1 * $3;}
     	| mult
	;
mult: mult '/' div	{$$ = $1 / $3;}
	|div
	;
div: div '%' mod	{$$ = $1 % $3;}
	|mod
	;
mod	: '(' exp ')'	{$$ = $2;}
	| NUM
	| ID 			{printf("searching ID...\n"); $$= searchVal($1);}		
	;


me  :ID '%=' exp 		{$$=setVal($1,searchVal($1) % $3);}
	;
de  :ID '/=' exp		{$$=setVal($1,searchVal($1) / $3);}
	;
pe	:ID '*=' exp		{$$=setVal($1,searchVal($1) * $3);}
	;				
ae	:ID '+=' exp 		{$$=setVal($1,searchVal($1) + $3);}
	;
se  :ID '-=' exp		{$$=setVal($1,searchVal($1) - $3);}
	;
pp	:exp '++'			{$$= $1+1;}
	;
mm	:exp '--'			{$$= $1-1;}	
	;

/* sb  :'{' exp '}'	{$$=$2;}
	; */

func_def: INT ID '()' '{' statements '}'		{$$=$5;}
		| VOID ID '()' '{' statements '}'		{$$=$5;}
		;




exp2 : exp '==' exp 	{if($1==$3){$$= 1;} else{ $$= 0;}}
	 | exp2 AND exp2	{if($1==1 && $3==1){$$=1;}else{$$=0;}}
	 | exp2 OR exp2		{if($1==1 || $3==1){$$=1;}else{$$=0;}}
	 | 'true'			{$$=1;}
	 | 'false' 			{$$=0;}
	 ;


	


 
%%
int searchVal(char *ch)
{
	for(int i=0;i<52;i++)
	{
		if(*sym[i].name==*ch)
		{	return sym[i].value;
		}
	}
	printf("\ndid not find ID in symbol table!\n");
	return 0;
}
int setVal(char *ch, int a)
{
	sym[count].name=ch;
	sym[count].value=a;
	count++;
	return a;

} 


int main()
{
	return yyparse();
}

void yyerror(char *s)
{
	fprintf(stderr, "%s\n", s);
}

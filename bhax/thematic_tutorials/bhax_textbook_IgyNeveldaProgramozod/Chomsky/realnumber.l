%{
#include <stdio.h>
int realnumbers = 0;
%}
digit	[0-9]
%%
{digit}*(\.{digit}+)?	{++realnumbers; 
    printf("[realnum=%s %f]", yytext, atof(yytext));}
%%
int
main ()
{
 yylex ();
 printf("The number of real numbers is %d\n", realnumbers);
 return 0;
}


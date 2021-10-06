%{
#include "synt.tab.h"
extern int nbcol;
extern YYSTYPE yylval;
#include "fonctions.h"
%}

%option yylineno
lettres [a-zA-Z]
chiffres [+-]?[0-9]+
cst {chiffres}+
idf "$"{lettres}({lettres}|{chiffres}|_)*
idf_Tab "@"{lettres}({lettres}|{chiffres}|_)*
rel [\+\-]?{chiffres}+"."{chiffres}+
str ({lettres}|{chiffres})*
comment "##"[^#]*"##" 

%%

import {  nbcol+=yyleng; return mc_import;}
ISIL.io {  nbcol+=yyleng;return bib_io;}
ISIL.lang {  nbcol+=yyleng; return bib_lang;}
public {  nbcol+=yyleng;return mc_public;}
private {  nbcol+=yyleng;return mc_private;}
protected {  nbcol+=yyleng; return mc_protected;}
class {  nbcol+=yyleng; return mc_class;}
Entier {  nbcol+=yyleng; yylval.str = strdup("Entier"); return mc_entier;}
Reel {  nbcol+=yyleng; yylval.str = strdup("Reel");return mc_reel;}
Chaine {  nbcol+=yyleng; yylval.str = strdup("Chaine");return mc_chaine;}
CONST {  nbcol+=yyleng; yylval.str = strdup("CONST");return mc_const;}
Main {  nbcol+=yyleng; return mc_main;}
out {  nbcol+=yyleng; return ecriture;}
in {  nbcol+=yyleng; return lecture;}
for {  nbcol+=yyleng; return boucle;}
{cst} {  nbcol+=yyleng; yylval.entier=atoi(yytext);return cst;}
{str} {  nbcol+=yyleng; yylval.str=strdup(yytext); return str;}
{rel} {  nbcol+=yyleng; yylval.fl=atof(yytext); return rel;}
{idf}  {  nbcol+=yyleng;  if(yyleng<=25) { yylval.str=strdup(yytext); return idf;}
        else printf("erreur lexical ligne %d : la taille de l'idf depasse 25 car %s\n", yyleng,yytext);
		}
{idf_Tab} { yylval.str=strdup(yytext); return idf_tab;}
{comment}
"[" {nbcol+=yyleng; return cr_ouv;}
"]" {nbcol+=yyleng;return cr_frm;}
"," {nbcol+=yyleng;return vrg;}
"{" {nbcol+=yyleng;return aco_ouv;}
"}" {nbcol+=yyleng;return aco_frm;}
\( {nbcol+=yyleng;return po;}
\) {nbcol+=yyleng;return pf;}
; {nbcol+=yyleng;return pvg;}
"<" {nbcol+=yyleng;return inf;}
">" {nbcol+=yyleng;return sup;}
"<=" {nbcol+=yyleng;return infeq;}
">=" {nbcol+=yyleng;return supeq;}
"!=" {nbcol+=yyleng;return noteq;}
"==" {nbcol+=yyleng;return eq;}
"=" {nbcol+=yyleng;return eg;}
":=" {nbcol+=yyleng;return aff;}
\+ {nbcol+=yyleng;return plus;}
\* {nbcol+=yyleng;return mult;}
\- {nbcol+=yyleng;return sustr;}
\/ {nbcol+=yyleng;return divs;}
\" {nbcol+=yyleng;return qutt;}
"%f" {nbcol+=yyleng; return reel;}
"%d" {nbcol+=yyleng; return entier;}
"%c" {nbcol+=yyleng;return car;}
"%s" {nbcol+=yyleng; return string;}
[ \t] 

\n nbcol=0;
. printf("erreur lexicale a la ligne %d et la colonne %d avec l'entite %s\n",yylineno,nbcol, yytext);




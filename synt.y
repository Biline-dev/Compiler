%{
char sauvType[20];// variable pour sauvgarder le type 
int boolcst=0;// un boolean si cst
int valcst=1;// sauvgarder la valeur de cst
int nbcol=0; // Nombre de colonne
extern int yylineno; //nombre de lignes
int taille=1; // la taille du tableau
char sauvOPr[20]; // sauvgarder l'oprand
int nbSF=0; // nombre de signe de formatage dans une fonction 
int nbParametre = 0;// sauvegarde le nombre de parametre dans la fonction OUT
char SF_nom[2]; //Nom du signe de formatage
char SF_type[2]; // type de signe de formatage
int nbOper=0; // calcule le nombre d'opérand dans une opération
%}

%union {
int     entier;
char*   str;
float fl;
}

	%token mc_import <str>bib_io <str>bib_lang pvg 
        aco_frm aco_ouv <str>idf mc_class mc_public <str>mc_entier
		mc_private mc_protected <str>mc_reel <str>mc_chaine vrg <entier>cst cr_ouv cr_frm
		<str>idf_tab mc_main <str>mc_const <str>ecriture <str>lecture boucle eq po pf inf sup infeq supeq noteq plus mult sustr <str>divs
		aff entier string car qutt reel <str>str <fl>rel eg

%%
S: LISTE_BIB HEADER_CLASS aco_ouv CORPS MAIN aco_frm{printf("Heey you gonna do it u know that you CAN do it yeah !!");}
 
;

LISTE_BIB : BIB LISTE_BIB
          |
;		  
BIB: mc_import Nom_BIB pvg 
    
;	
Nom_BIB:bib_io {ajouterBible("ISIL.io");}
       |bib_lang {ajouterBible("ISIL.lang");}
;
HEADER_CLASS: MODIFICATEUR mc_class idf 
;

MODIFICATEUR: mc_public
            |mc_private
			|mc_protected
;

CORPS: Partie_DEC
;

Partie_DEC: Partie_DEC_VAR Partie_DEC
           |Partie_DEC_TAB Partie_DEC
		   |Partie_DEC_CONST Partie_DEC
		   |
;	
Partie_DEC_TAB: TYPE LISTE_IDF_TAB pvg
;
LISTE_IDF_TAB: idf_tab cr_ouv cst cr_frm  {if (existDeclaration($1)==0){if ($3<0)printf("line %d colonne %d : vous pouvez pas declarer le tableau avec un indice nagative \n",yylineno, nbcol);
                                                                        else inserer($1,"Tableau",sauvType,$3);
                                                                       }else printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);} vrg LISTE_IDF_TAB
              |idf_tab cr_ouv cst cr_frm  {if (existDeclaration($1)!=0){
				                            printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);
			                                }else{if ($3<0){printf("line %d colonne %d : vous pouvez pas declarer le tableau avec un indice nagative \n",yylineno, nbcol);
			  }                                   else inserer($1,"Tableau",sauvType,$3);}}
											 
									
Partie_DEC_VAR: TYPE LISTE_IDF pvg {valcst=0;}
;
TYPE: mc_entier {strcpy(sauvType,$1);}
     |mc_reel   {strcpy(sauvType,$1);}
	 |mc_chaine {strcpy(sauvType,$1);}
;

LISTE_IDF: idf vrg { if (existDeclaration($1)==0){if(boolcst>0) inserer($1,"Constante",sauvType,1); else inserer($1,"idf",sauvType,1);
                                                 }else printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);}{valcst=0;}LISTE_IDF
          |idf { if (existDeclaration($1)==0){if(boolcst>0)inserer($1,"Constante",sauvType,1);else inserer($1,"idf",sauvType,1);
		                                     }else printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);}{valcst=0;}
          |idf aff cst {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
		               }else{ if (existDeclaration($1)==0){if(boolcst>0){inserer($1,"Constante",sauvType,1);initialiseINT($1, $3);
					                                                    }else{ inserer($1,"idf",sauvType,1);initialiseINT($1, $3);}
					                                      }else printf("line %d colonne %d : double declaration de %s\n",yylineno,nbcol,$1);
														  if(strcmp(sauvType,"Entier")!=0)printf("line %d colonne %d :Incompatible type %s\n",yylineno,nbcol,$1);}}{valcst=0;}
	      |idf aff cst vrg {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
					       }else{if (existDeclaration($1)==0){
							     if(boolcst>0){inserer($1,"Constante",sauvType,1);initialiseINT($1, $3);
								              }else{ inserer($1,"idf",sauvType,1);initialiseINT($1, $3);}
															 }else printf("line %d colonne %d :double declaration de %s\n",yylineno,nbcol,$1);
															  if(strcmp(sauvType,"Entier")!=0)printf("line %d colonne %d :Incompatible type %s\n",yylineno,nbcol,$1);}{valcst=0;}}LISTE_IDF
		  |idf aff rel vrg {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
						   }else{if (existDeclaration($1)==0){
							   if(boolcst>0){inserer($1,"Constante",sauvType,1);initialiseFLOAT($1, $3);
							                }else {inserer($1,"idf",sauvType,1);}
											                 }else printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);
															 if(strcmp(sauvType,"Reel")!=0)printf("line %d colonne %d:Incompatible type %s\n",yylineno,nbcol,$1);}}LISTE_IDF
          |idf aff rel {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
					   }else{if(existDeclaration($1)==0){
						   if(boolcst>0){inserer($1,"Constante",sauvType,1);initialiseFLOAT($1, $3);
						                }else {inserer($1,"idf",sauvType,1);}
										                }else printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);
		                                                if(strcmp(sauvType,"Reel")!=0)printf("line %d colonne %d :Incompatible type %s\n",yylineno,nbcol,$1);}}
		  |idf aff qutt str qutt {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
								  }else{if (existDeclaration($1)==0){
									  if(boolcst>0){inserer($1,"Constante",sauvType,1);initialiseCHAINE($1, $4);
									               }else {inserer($1,"idf",sauvType,1);initialiseCHAINE($1, $4);}
												                    }else printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);
																	if(strcmp(sauvType,"Chaine")!=0)printf("line %d colonne %d: Incompatible type %s\n",yylineno,nbcol,$1);}}
		  |idf aff qutt str qutt vrg {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
								  }else{if (existDeclaration($1)==0){
									  if(boolcst>0){inserer($1,"Constante",sauvType,1);initialiseCHAINE($1, $4);
									               }else {inserer($1,"idf",sauvType,1);initialiseCHAINE($1, $4);}
												                    }else printf("line %d colonne %d: double declaration de %s\n",yylineno,nbcol,$1);
																	if(strcmp(sauvType,"Chaine")!=0)printf("line %d colonne %d : Incompatible type %s\n",yylineno,nbcol, $1);}}LISTE_IDF
;  


LISTE_IDF2:idf { if (existDeclaration($1)==0){printf("line %d colonne %d: variable %s non declare\n",yylineno,nbcol,$1);
		                                     }else nbParametre++; insererParm($1);}vrg LISTE_IDF2
          |idf { if (existDeclaration($1)==0){printf("line %d colonne %d: variable %s non declare\n",yylineno,nbcol,$1);
		                                     }else nbParametre++; insererParm($1);}
          |cst {nbParametre++; } vrg LISTE_IDF2
		  |cst {nbParametre++; }
;

Partie_DEC_CONST: mc_const {boolcst=1;} TYPE {valcst=0;} LISTE_IDF pvg {boolcst=0;}
;
MAIN: mc_main po pf aco_ouv BODY aco_frm
;

BODY: Partie_INS
     
;

Partie_INS: Partie_INS_LIR Partie_INS
           |Partie_INS_ECR Partie_INS
		   |Partie_INS_BCL Partie_INS
		   |Partie_INS_AFF Partie_INS
		   |
;
	   
Partie_INS_LIR:lecture po qutt Signe_de_formatage qutt vrg idf pf pvg {
if(chercherBible("ISIL.io")!=0){printf("line %d colonne %d: la bibliotheque ISIL.io nest pas importer \n",yylineno,nbcol);
						       }else{if (existDeclaration($7)==0)printf("line %d colonne %d: variable %s non declare\n",yylineno,nbcol,$7);
									 else{if(ModifCST($7)==0)printf("line %d colonne %d: %s est une constante, Vous ne pouvez pas lui affecter une entree\n",yylineno,nbcol,$7);}}}							                                      
;
Partie_INS_ECR:ecriture po qutt SF qutt vrg LISTE_IDF2 {if(chercherBible("ISIL.io")!=0){printf("line %d colonne %d: la bibliotheque ISIL.io nest pas importer \n",yylineno,nbcol);
                                                         }else{if(nbParametre!=nbSF){ printf("line %d colonne %d: Nombre de parametre insuffisant\n",yylineno,nbcol);
                                                         }else{if(Error(nbSF)!=0) printf("line %d colonne %d: format incorrecte\n",yylineno,nbcol);} nbSF=0; nbParametre=0;}} pf pvg	
;
Partie_INS_BCL:boucle po INITIALISATION pvg CONDITION pvg INCREMENTATION pf aco_ouv BODY aco_frm
              |boucle po pf aco_ouv BODY aco_frm
			  |boucle po idf pvg CONDITION pvg INCREMENTATION pf aco_ouv BODY aco_frm {
				  if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
			      }else{if (existDeclaration($3)==0){printf("line %d colonne %d: variable %s non declare\n",yylineno,nbcol,$3);}}}
; 
Partie_INS_AFF:  INITIALISATION pvg
;

Signe_de_formatage:string {strcpy(SF_nom,"%s"); strcpy(SF_type,"Chaine");}
                  |reel {strcpy(SF_nom,"%f");strcpy(SF_type,"Reel"); }
				  |entier {strcpy(SF_nom,"%d"); strcpy(SF_type,"Entier");}
				  |car {strcpy(SF_nom,"%c"); }
			
;
SF: Signe_de_formatage {nbSF++; insererSF(SF_nom,SF_type);} SF
   |Signe_de_formatage {nbSF++; insererSF(SF_nom,SF_type);} 
;

INITIALISATION:idf aff OPERATION  {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
								  }else{if (existDeclaration($1)==0){printf("line %d colonne %d: variable %s non declare\n",yylineno,nbcol,$1);
								  }else{ if(ModifCST($1)==0)printf("line %d colonne %d: Vous ne pouvez pas changer la valeur d'une constante \n",yylineno,nbcol);}}}				
              |idf_tab cr_ouv cst cr_frm aff OPERATION  {
					if (existDeclaration($1)==0){
					   printf("line %d colonne %d: variable %s non declare\n",yylineno,nbcol,$1);
				    }else{
				       if(TailleTab($1,$3)!= 0)printf("line %d colonne %d: Taille du tableau depasse\n",yylineno,nbcol); }
				}
;
CONDITION:idf COMPARAISON IDE_OPR  {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d: la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
								   }else{ if (existDeclaration($1)==0)printf("line %d colonne %d: variable %s non declare\n ",yylineno,nbcol,$1);}}
;
INCREMENTATION:idf plus plus  {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
                              }else{ if (existDeclaration($1)==0)printf("line %d colonne %d: variable %s non declare\n ",yylineno,nbcol,$1);}}
              |idf sustr sustr{if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
			                  }else{ if (existDeclaration($1)==0)printf("line %d colonne %d: variable %s non declare\n ",yylineno,nbcol,$1);}}
;
COMPARAISON: noteq
            |eq 
            |infeq 
            |supeq 
            |inf
;
OPERATION: IDE_OPR
		  |IDE_OPR OPERATEUR {if(chercherBible("ISIL.lang")!=0){ printf("line %d colonne %d:la bibliotheque ISIL.lang nest pas importer\n",yylineno,nbcol);
		                     }else{if((strcmp(sauvOPr,"divs")==0) && (valcst==0)) printf("line %d colonne %d: Division sur zero\n",yylineno,nbcol);} 
							 }OPERATION {if(Compare(nbOper)!=0) printf("line %d colonne %d:Incomapatible type\n",yylineno,nbcol); nbOper=0;}
;
IDE_OPR: cst {valcst=$1;}
        |idf  { if (existDeclaration($1)==0){printf("line %d colonne %d: variable %s non declare\n",yylineno,nbcol, $1);}else {InsererElement($1); nbOper++;}}
;

OPERATEUR: plus
          |sustr
		  |mult 
		  |divs {strcpy(sauvOPr,"divs");}
;			 
%%		
main()
{yyparse();
afficher(); afficher2 ();afficher3 (); afficher4 ();}
yywrap(){}
yyerror(char*msg)
{
printf("erreur syntaxique dans le projet isil2021 à la ligne %d et la colonne %d\n", yylineno, nbcol);

}


// La programmation de la table des symboles
   //Déclaration
   //structure de la table de symole
   typedef struct
	{
	  char NomEntite[20];
	  char CodeEntite[20];
	  char TypeEntite[20];
	  int taille;
	  int initialise1;
	  char initialise[100];
	  float initialise2;
	} TypeTS;
	
   TypeTS ts[100];  //initialisation d'un tableau quiva contenir les elements de la table des symboles
   int CpTabSym=0; //compteur pour le tableau des ts
    
   typedef struct // structeur pour s'auvgarder les bliotheques importer
	{
	  char NomBibliotheque[20];
	}bibl;
	bibl biblio[2];
	int b=0;// compteur pour le tableu des bliotheques
	 
    //structure de la table SIGNE DE FORMATAGE 
	typedef struct
	  {
	    char Tab_SF[2];
		char Type_SF[20];
	  }SF;
	SF sf[100];
	int CpSF=0;
	
	//structure de la table PARAMETRE
	typedef struct
	  {
		char tab_Param[20];	
		char Type_Param[20];
	  }PARAMETRE;
	PARAMETRE pramtr[100];
	int CpParm=0;
	
	
	//........................................Table des Symboles functions................................//
	   
   //Definir une fonction recherche
   int recherche(char entite[])
	{
	int i=0;
	while(i<CpTabSym)
	{
	if (strcmp(entite,ts[i].NomEntite)==0) return i;
	i++;
	}

	return -1;
	}
	//Definir une fonction pour inserer
	void inserer(char entite[], char code[], char type[],int taille)
	{

	if ( recherche(entite)==-1)
	{
	strcpy(ts[CpTabSym].NomEntite,entite); 
	strcpy(ts[CpTabSym].CodeEntite,code);
	strcpy(ts[CpTabSym].TypeEntite,type);
	ts[CpTabSym].taille=taille;
	CpTabSym++;

	}
	
	}
    //Definir la fonction afficher  
    void afficher ()
	{  
		printf("\n\n\n\n\t/**********************Table des symboles *************************/\n");
		printf("\t _________________________________________________________________\n");
		printf("\t|Nom         |Code          |Type         |Initialise  |taille    |\n");
		printf("\t|____________|______________|_____________|____________|__________|\n");
		int i=0;
		  while(i<CpTabSym)
		  { 
		  if(strcmp(ts[i].TypeEntite,"Entier")==0){
				printf("\t|%10s  |%12s  |%10s   |%10d  |%10d|\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].initialise1, ts[i].taille);
		  }else{if(strcmp(ts[i].TypeEntite,"Reel")==0){
			  	printf("\t|%10s  |%12s  |%10s   |%10f  |%10d|\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].initialise2, ts[i].taille);
		  }else
		  printf("\t|%10s  |%12s  |%10s   |%10s  |%10d|\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].initialise, ts[i].taille);}
				i++;	 
		  }
	}
	
	//Definir une fonction pour inserer
	void insererTYPE(char entite[], char type[])
	{
       int pos;
	   pos = recherche(entite);
		if ( pos!=-1)
		{
		strcpy(ts[pos].TypeEntite,type); 
		}
	}
	//Definir une fonction pour inserer
	void initialiseINT(char entite[], int init)
	{ 
       int pos;
	   pos = recherche(entite);
		if ( pos!=-1)
		{
		 ts[pos].initialise1 = init; 
		}
	}
	
		//Definir une fonction pour inserer................................................................................................................
	void initialiseFLOAT(char entite[], float init)
	{
        int pos;
	    pos = recherche(entite);
		if ( pos!=-1)
		{ 
		 ts[pos].initialise2=init; 
		}
	}
	
		//Definir une fonction pour inserer
	void initialiseCHAINE(char entite[], char init[])
	{
       int pos;
	   pos = recherche(entite);
		if ( pos!=-1)
		{
		strcpy(ts[pos].initialise,init); 
		}
	}
	
		//Fonction qui donne la taille d'un tableau
	int TailleTab(char entite[], int cst)
	{    
	   int pos;
		pos = recherche(entite);
		if(pos!=-1 && cst < ts[pos].taille)
		return 0;
		else return -1;
	
	}
	
//.....................................................................fin TS...................................................//

//....................................Fonction message d'erreur...................................//

	// Definir une fonction qui detecte exist declaration
	int existDeclaration(char entite[]){
		int pos;
		pos = recherche(entite);
	    if(strcmp(ts[pos].NomEntite,"")==0) return 0;
		else return -1;
	}
	
	int ModifCST(char entite[])
	{
		int pos;
		pos = recherche(entite);
		if(pos!=-1){
		   if(strcmp(ts[pos].CodeEntite,"Constante")==0)
		   {
			   if(ts[pos].initialise1==0) 
			   return -1;
			   else return 0;
		   }else return -1;
		}else return -1;
		
	}
	
	//................................................Fonction pour l'importation des bibliothque.............................................//
	
// fonction pour chercher si une Bibliotheque est importée
   int chercherBible(char NomBibliotheque[]) 
   {
      int i;
      for(i=0;i<2;i++){
       if(strcmp(biblio[i].NomBibliotheque,NomBibliotheque)==0)
         return 0;
      }
       return 1;
   }


// fonction pour ajouter une bliotheque au tableau des bliotheques
	 int ajouterBible(char NomBibliotheque[])
	 {
		
		if(chercherBible(NomBibliotheque)==1)
		{
		   strcpy(biblio[b].NomBibliotheque,NomBibliotheque);
		   b++;
		   return 0;
		}
		else 
		   return -1;
	 }

//...............................................Erreur de signe de formatage...................................../

    //Definir une fonction recherche pour SF
   int rechercheSF(char tab_SF[])
	{
	int i=0;
	while(i<CpSF)
	{
	if (strcmp(tab_SF,sf[i].Tab_SF)==0) return i;
	i++;
	}

	return -1;
	}
	
	//Definir une fonction pour inserer dans la table SF
	void insererSF(char tab_SF[], char type[])
	{
		strcpy(sf[CpSF].Tab_SF,tab_SF); 
		strcpy(sf[CpSF].Type_SF,type);
		CpSF++;
	}

    //Definir une fonction recherche pour parametre
   int rechercheParm(char tab_paramt[])
	{
	int i=0;
	while(i<CpParm)
	{
	if (strcmp(tab_paramt,pramtr[i].tab_Param)==0) return i;
	i++;
	}
	return -1;
	}
	
	//Definir une fonction pour inserer dans la table parametre
	void insererParm(char tab_Param[])
	{
		int pos = recherche(tab_Param);
		if ( pos!=-1)
		{
			strcpy(pramtr[CpParm].tab_Param,tab_Param); 
			strcpy(pramtr[CpParm].Type_Param,ts[pos].TypeEntite);
			CpParm++;
		}
	    
	}

 //Definir la fonction afficher SF
    void afficher2 ()
	{  
		printf("\n\n\n\n\t/*****Table des Signes de formatages *****/\n");
		printf("\t ________________________\n");
		printf("\t|NomSigne    |Type       |\n");
		printf("\t|____________|___________|\n");
		int i=0;
		  while(i<CpSF)
		  { 
				printf("\t|%10s  |%10s |\n",sf[i].Tab_SF,sf[i].Type_SF);
				i++;	 
		  }
	}

	 //Definir la fonction afficher parametre
    void afficher3 ()
	{  
		printf("\n\n\n\n\t/*****Table des variables utilise dans les fonctions *****/\n");
		printf("\t __________________________\n");
		printf("\t|NomVariable   |Type       |\n");
		printf("\t|______________|___________|\n");
		int i=0;
		  while(i<CpParm)
		  { 
				printf("\t|%10s    |%10s |\n",pramtr[i].tab_Param,pramtr[i].Type_Param);
				i++;	 
		  }
	}

//fontion de Détection d'erreur pour le format

	int Error(int nb){
	  int i = CpParm-1;
	  while(strcmp(pramtr[i].Type_Param, sf[i].Type_SF)==0 && i>=CpParm-nb+1)
	  {
		  i--;
	  }
      if(strcmp(pramtr[i].Type_Param, sf[i].Type_SF)==0){
	  return 0;}
	  else {return -1;}
	}
     
	
//...................................type incompatible..................................//

typedef struct // structeur pour s'auvgarder les bliotheques importer
	{
	  char Typevariable[20];
	}Var;
	Var variablElm[100];
	int v=0;// compteur pour le tableu des variable
// inserer des variables dans un tableau pour le calcul

	void InsererElement(char variable[]){
		
		int pos = recherche(variable);
			
			if(pos!=-1){
				strcpy(variablElm[v].Typevariable,ts[pos].TypeEntite);	
				v++;								
			}
	    }
// Afficher tableau variable
	
	    void afficher4 ()
	{  
		printf("\n\n\n\n\t/*****Table des types des variables utilise dans les Operations*****/\n");
		printf("\t ______________\n");
		printf("\t|Type          |\n");
		printf("\t|______________|\n");
		int i=0;
		  while(i<v)
		  { 
				printf("\t|%10s    |\n",variablElm[i].Typevariable);
				i++;	 
		  }
	}

     int Compare(int nb){
		 int i=v-1,j;
		 int dif=0;
		 if(nb>1){
		 while(i>=v-nb && dif==0){
		 
		     for(j=i-1;j>=v-nb;j--){
				 if(strcmp(variablElm[i].Typevariable,variablElm[j].Typevariable)!=0){
				 dif = -1;}
			 }
			 i--;
		 }
		 }
		 if(dif!=0)
		 return -1;
		 else return 0;
		 
	 }







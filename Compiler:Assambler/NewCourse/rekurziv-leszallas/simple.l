%option noyywrap c++

%{
#include "simple.h"
%}

%%

true	return TR;
false	return FL;
:=	return ERTEKADO_OP;
if	return IF;
then	return THEN;
endif	return ENDIF;
while	return WHILE;
do	return DO;
done	return DONE;

\?[a-z0-9]+	return VAR;

[ \t\n]+	// feher szokozok: semmi teendo

<<EOF>>	return VEGE;

. 	hiba();

%%

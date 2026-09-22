#include <iostream>
#include <fstream>
#include <cstdlib>
#include "simple.h"
#include <FlexLexer.h>

using namespace std;

yyFlexLexer *lexikalis;
szimbolum aktualis;

void elfogad( szimbolum s );
szimbolum kovetkezo();
void S();
void U();
void K();

int main( int argc, char* argv[] )
{
    if( argc != 2 )
    {
        cerr << "Egy parancssori parametert kell adni." << endl;
        return 1;
    }
    ifstream in( argv[1] );
    if( !in )
    {
        cerr << "Nem tudom megnyitni: " << argv[1] << endl;
        return 1;
    }
    lexikalis = new yyFlexLexer(&in, &cout);
    aktualis = kovetkezo();
    S();
    if( aktualis != VEGE )
    {
        hiba();
    }
    return 0;
}

void S()
{
    if( aktualis == ENDIF || aktualis == DONE || aktualis == VEGE )
    {
        cout << "S -> epszilon" << endl;
    }
    else if( aktualis == VAR || aktualis == IF || aktualis == WHILE )
    {
        cout << "S -> US" << endl;
        U();
        S();
    }
    else
    {
        hiba();
    }
}

void U()
{
    if( aktualis == VAR )
    {
        cout << "U -> var := K" << endl;
        elfogad( VAR );
        elfogad( ERTEKADO_OP );
        K();
    }
    else if( aktualis == IF )
    {
        cout << "U -> if var then S endif" << endl;
        elfogad( IF );
        elfogad( VAR );
        elfogad( THEN );
        S();
        elfogad( ENDIF );
    }
    else if( aktualis == WHILE )
    {
        cout << "U -> while var do S done" << endl;
        elfogad( WHILE );
        elfogad( VAR );
        elfogad( DO );
        S();
        elfogad( DONE );
    }
    else
    {
        hiba();
    }
}

void K()
{
    if( aktualis == VAR )
    {
        cout << "K -> var" << endl;
        elfogad( VAR );
    }
    else if( aktualis == TR )
    {
        cout << "K -> true" << endl;
        elfogad( TR );
    }
    else if( aktualis == FL )
    {
        cout << "K -> false" << endl;
        elfogad( FL );
    }
    else
    {
        hiba();
    }
}

void hiba()
{
    cerr << "Hiba." << endl;
    exit(1);
}

void elfogad( szimbolum s )
{
    if( aktualis == s )
    {
        aktualis = kovetkezo();
    }
    else
    {
        hiba();
    }
}

szimbolum kovetkezo()
{
    return (szimbolum)lexikalis->yylex();;
}

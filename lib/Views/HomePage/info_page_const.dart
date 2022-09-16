// References for all images  with copyright free to be used showing author
final linkRef = [
  "it.freepik.com - Icone dei Badge",
  "www.onlinewebfonts.com - Progress bar"
];

final infoSections = [
  {
    'title': '''Che obbiettivo ha questa app?''',
    'body':
        '''Fornire informazioni sulla sostenibilità dell’Università di Bologna rendendo più consapevoli gli studenti sul tema.''',
  },
  {
    'title': '''Che obbiettivo ha questa app?''',
    'body':
        '''I dati della co2, energia elettrica e barili di petrolio sono stati calcolati a partire dalla quantità di fogli di carta risparmiati.
Nei calcoli delle conversioni è stato considerato un foglio di carta da ufficio con densità pari a 80g/m².

Considerato, come regola generale, che 1 Kg di carta corrisponde ad 1 Kg di Co2 durante la sua produzione (1,2 kg di CO2 per la carta non riciclata e 0,7 kg di CO2 per la carta riciclata) si ottiene che si hanno circa 16 fogli/m².

Si ha quindi che un folgio di carta corrisponde a circa 5g di Co2.''',
  },
  {
    'title': '''Come sono stati calcolati i litri di petrolio?''',
    'body':
        '''Per calcolare i litri di petrolio corrispondendi ai Kg di Co2 si è moltiplicato il valore della Co2 risparmiata per la costante 0.429''',
  },
  {
    'title': '''Come è stato calcolata l'energia elettrica?''',
    'body': '''''',
  },
];

// // x = 429 petrol litri/1000 Kg = 0,429 Litri Petrolio/Kg
//   // from Kg Co2 --> petrol oil liters
//   static const double literPerKgOil = 0.429;

//   // //from petrol liters --> giga Joule energy --> GWh
//   // const double gigJoulePerLiterOil = 0.03501030928;
//   // const double gigWattHourPerGigJoule = 0.000277778;

//   static const double gigWattHourPerLiterOil = 0.000009725093691;

//   // barels/liter petrolio = 0,006293706294 Barrels/liter
//   //from liters petrol oil --> petrol oil barrels
//   static const double barrelsPerLiterOil = 0.006293706294;
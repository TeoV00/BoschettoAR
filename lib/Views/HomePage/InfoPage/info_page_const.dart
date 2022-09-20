// References for all images  with copyright free to be used showing author
import 'package:tree_ar/constant_vars.dart';

final linkRef = [
  "it.freepik.com - Icone dei Badge",
  "www.onlinewebfonts.com - Progress bar",
  "Icone dei progetti create da Freepik - Flaticon"
];

final infoSections = [
  {
    'title': '''Che obbiettivo ha questa app?''',
    'body':
        '''Fornire informazioni sulla sostenibilità dell’Università di Bologna rendendo più consapevoli gli studenti sul tema.''',
  },
  {
    'title':
        '''Come è stata calcolata la $co2String a partire dai fogli di carta?''',
    'body':
        '''I dati della $co2String, energia elettrica e taniche di benzina (da 20 litri) sono stati calcolati a partire dalla quantità di fogli di carta risparmiati.
Nei calcoli delle conversioni è stato considerato un foglio di carta da ufficio con densità pari a 80g/m².

Considerato, come regola generale, che 1 Kg di carta corrisponde ad 1 Kg di $co2String durante la sua produzione (1,2 kg di $co2String per la carta non riciclata e 0,7 kg di $co2String per la carta riciclata) si ottiene che si hanno circa 16 fogli/m².

Si ha quindi che un folgio di carta corrisponde a circa 5g di $co2String.''',
  },
  {
    'title':
        '''Come è stata calcolata la quantità di benzina in litri a partire dalla $co2String?''',
    'body':
        '''Un litro di benzina produce circa 2,3035 Kg di $co2String quindi si ottiene una costante per la conversione pari a circa 0.429 Litri/Kg.\nMoltiplicando i chilogrammi di $co2String per questa costante si ottengono i litri di benzina.''',
  },
  {
    'title': '''Come è stato calcolata l'energia elettrica?''',
    'body':
        '''Considerando un PCI (Potere calorifico inferiore) medio della benzina di 43,6 MJ/kg, e una densità media di circa 750g/L.\nSi ha che con 1 Litro di benzina si producono circa 9,06 kWh. Andanndo a moltiplicare questa costante per il numero di litri otteniamo l'energia elettrica.''',
  },
];

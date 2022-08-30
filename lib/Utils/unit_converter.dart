import 'dart:math';

class ValueConverter {
  // x = 429 petrol litri/1000 Kg = 0,429 Litri Petrolio/Kg
  // from Kg Co2 --> petrol oil liters
  static const double literPerKgOil = 0.429;

  // //from petrol liters --> giga Joule energy --> GWh
  // const double gigJoulePerLiterOil = 0.03501030928;
  // const double gigWattHourPerGigJoule = 0.000277778;

  static const double gigWattHourPerLiterOil = 0.000009725093691;

  // barels/liter petrolio = 0,006293706294 Barrels/liter
  //from liters petrol oil --> petrol oil barrels
  static const double barrelsPerLiterOil = 0.006293706294;

  static double fromCo2ToPetrolLiter(num co2Kg) {
    return co2Kg * literPerKgOil;
  }

  static double fromPetrolToKiloWatt(double petrolOilLiter) {
    return (petrolOilLiter * gigWattHourPerLiterOil * pow(10, 6));
  }

  static double fromCo2ToKiloWatt(num co2Kg) {
    return (fromCo2ToPetrolLiter(co2Kg) * gigWattHourPerLiterOil * pow(10, 6));
  }

  static int fromPetrolLiterToBarrels(num petrolLiter) {
    return (petrolLiter * barrelsPerLiterOil).toInt();
  }

  static int fromCo2ToPetrolBarrels(num co2Kg) {
    return (fromCo2ToPetrolLiter(co2Kg) * barrelsPerLiterOil).toInt();
  }
}

class ValueConverter {
  // x = 429 petrol litri/1000 Kg = 0,429 Litri Petrolio/Kg
  // from Kg Co2 --> petrol oil liters
  static const double literPerKgOil = 0.429; //per benzina senza piombo

  // //from petrol(benzina) liters --> giga Joule energy --> GWh
  // const double gigJoulePerLiterOil = 0.03501030928;
  // const double gigWattHourPerGigJoule = 0.000277778;

  static const double gigWattHourPerLiterBenzina = 9.06;
  // static const double gigWattHourPerLiterOil = 0.000009725093691;

  // barels/liter petrolio = 0,006293706294 Barrels/liter

  //from liters petrol oil --> petrol oil barrels
  // static const double barrelsPerLiterOil = 0.006293706294;

  // tank/20 liter benzina => 1 tank of capacity 20 liters => 1/20 = 0,05
  static const double tankPer20LitersFuel = 0.05;

  static double fromCo2ToBenzinaLiter(num co2Kg) {
    return co2Kg * literPerKgOil;
  }

  static double fromLiterToKiloWatt(double petrolOilLiter) {
    // Considerando un PCI medio di 43,6 MJ/kg, e una densità media di circa 750g/L.
    // 43,6 [MJ/kg] * 0,75 [kg/L] * 0,277 [kWh/MJ] ~= 9,06 kWh/L
    return (petrolOilLiter * gigWattHourPerLiterBenzina);
  }

  static double fromCo2ToKiloWatt(num co2Kg) {
    return fromLiterToKiloWatt(fromCo2ToBenzinaLiter(co2Kg));
  }

  static int fromCo2ToFuelTanks(num co2Kg) {
    return (tankPer20LitersFuel * fromCo2ToBenzinaLiter(co2Kg)).toInt();
  }

  // static double fromCo2ToKiloWatt(num co2Kg) {
  //   return (fromCo2ToPetrolLiter(co2Kg) * gigWattHourPerLiterOil * pow(10, 6));
  // }

  // static int fromPetrolLiterToBarrels(num petrolLiter) {
  //   return (petrolLiter * barrelsPerLiterOil).toInt();
  // }

  // static int fromCo2ToPetrolBarrels(num co2Kg) {
  //   return (fromCo2ToPetrolLiter(co2Kg) * barrelsPerLiterOil).toInt();
  // }
}

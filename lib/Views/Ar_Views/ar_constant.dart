const int maxCountStack = 20;

enum Dimension { length, height, width }

//ATTENTION: these measure are in mm (millimeter)
class ObjDimension {
  final double height;
  final double width;
  final double lenght;

  ObjDimension(this.height, this.lenght, this.width);
}

ObjDimension stack3Size = ObjDimension(160, 300, 200);
ObjDimension barrelSize = ObjDimension(850, 572, 572);

const double mmToPixelFactor = 3.7795275591;

double mm2Pixel(double mm) {
  return mm * mmToPixelFactor;
}

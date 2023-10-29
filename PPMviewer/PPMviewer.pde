PImage imgBuffer, img;
int zoom = 0,
bufferSize = 16384;
float compressionValue = 0.8;
SliderWindow sw;

void setup() {
  size(400,300);
  surface.setLocation(200, 200);
  colorMode(RGB, 255);
  background(0);    
  String[] args = {"Compression Rate"};
  sw = new SliderWindow();
  PApplet.runSketch(args, sw);
}

void draw(){
  if(sw.slider!=null)
  compressionValue = sw.slider.getPos();
  if(img!=null)
  image(img,0,0);
}

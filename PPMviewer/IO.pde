void keyPressed() {
  if (keyCode == 112) 
    selectOutput("Select a file to write to:", "outputFileSelected");
  
  else if (keyCode == 113) 
    selectInput("Select a file to read from:", "inputFileSelected");
  
  else if(img!=null && (key == '-' || key == '+')){
    int newWidth, newHeight;
    if(key == '-') zoom--;
    else           zoom++;
    
    newWidth=round(float(imgBuffer.width)*pow(1.5,zoom));
    newHeight=round(float(imgBuffer.height)*pow(1.5,zoom));
    
    if(newWidth>0 && newHeight>0){
      img = imgBuffer.copy();
      img.resize(newWidth,newHeight);
      resizeCanvas();
    }else zoom++;
  }
}

void outputFileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  }
  else if(isItJPEG(selection.getName())){
    println("User selected " + selection.getAbsolutePath());
    if(!selection.exists()){
      try {
          // Create a new file
          boolean fileCreated = selection.createNewFile();
          if (fileCreated) {
              println("File created: " + selection.getAbsolutePath());
          } else {
              println("Failed to create the file.");
              JOptionPane.showMessageDialog(null, "Failed to create the file", "Error", JOptionPane.ERROR_MESSAGE);
          }
      } catch (IOException e) {
          println("Error creating file: " + e.getMessage());
          JOptionPane.showMessageDialog(null, "Error creating file: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
      }
    }
    if(imgBuffer!=null){
    //imgBuffer.save(selection.getAbsolutePath());


    try{
      Iterator iter;
      if(selection.getName().endsWith(".jpg"))
        iter = ImageIO.getImageWritersByFormatName("jpg");
      else
        iter = ImageIO.getImageWritersByFormatName("jpeg");
      FileImageOutputStream output = new FileImageOutputStream(selection);
      ImageWriter writer = (ImageWriter)iter.next();
      ImageWriteParam iwp = writer.getDefaultWriteParam();
      iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
      iwp.setCompressionQuality(compressionValue); //1-min compression
      println("compression",compressionValue);
      writer.setOutput(output);
      BufferedImage bufImage = (BufferedImage)imgBuffer.getNative();
      IIOImage iioImage = new IIOImage(bufImage, null, null);
      writer.write(null, iioImage, iwp);
      writer.dispose();
    }catch(Exception e){
      println("Error writing file: " + e.getMessage());
      JOptionPane.showMessageDialog(null, "Error writing file: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
    }
    
    
    }else{
      println("No image loaded");
      JOptionPane.showMessageDialog(null, "No image loaded", "Warning", JOptionPane.INFORMATION_MESSAGE);
    }
  }else{
      println("Unsupported file format");
      JOptionPane.showMessageDialog(null, "Unsupported file format", "Warning", JOptionPane.INFORMATION_MESSAGE);
  }
}

void inputFileSelected(File selection) {
  if (selection == null) {
    println("No file selected.");
  }else{
    println("User selected " + selection.getAbsolutePath());
    
    if(isItJPEG(selection.getName())){
      imgBuffer = loadImage(selection.getAbsolutePath());
      img = imgBuffer.copy();
      zoom = 0;
      resizeCanvas();
    }else if(isItPPM(selection.getName())){
      imgBuffer = ppmToPImage(selection.getAbsolutePath());
      img = imgBuffer.copy();
      zoom = 0;
      resizeCanvas();
    }else{
      println("Unsupported file format");
      JOptionPane.showMessageDialog(null, "Unsupported file format", "Error", JOptionPane.INFORMATION_MESSAGE);
    }
  }
}

void resizeCanvas(){
    surface.setResizable(true);
    surface.setSize(img.width, img.height);
    surface.setResizable(false);
}


boolean isItJPEG(String fileName) {
return (
   fileName.endsWith(".jpg") ||
   fileName.endsWith(".jpeg")) ;
}

boolean isItPPM(String fileName) {
return (
   fileName.endsWith(".ppm"));
}

PImage ppmToPImage(String filePath) {
  try{
    PImage image;
    BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(filePath)));
    
    String format = reader.readLine().trim();
    int w = 0, h = 0, maxC = 0, linesToSkip = 1;
    String line = reader.readLine();
    String[] numbers;
    
    if(format.equals("P3") || format.equals("P6")){
      //nagłówek
      while(line!=null){
        linesToSkip++;
        line = line.split("#", 2)[0]; //usuwanie komentarza
        numbers = line.split("\\s");
        for(String number : numbers){
          if(!number.equals("")){
            if(w==0) w=int(number);
            else if(h==0) h=int(number);
            else if(maxC==0) {maxC=int(number);break;}
          }
        }
        if(maxC!=0) break;
        line = reader.readLine();
      }
      
      //część wspólna w P3 i P6
      image = createImage(w, h, RGB);
      int r=0,g=0 ,b=0 ,counter = 0, x = 0, y = 0;
      float scale = 255/float(maxC);
      boolean ifScale;
      if(scale==1.0)  ifScale = false;
      else            ifScale = true;
      
      //P3
      if (format.equals("P3")) {
        line = reader.readLine();
        while(line!=null){
          line = line.split("#", 2)[0]; //usuwanie komentarza
          numbers = line.split("\\s");
          for(String number : numbers){
            if(!number.equals("")){
              switch(counter){
                case 0:
                r=int(number);
                break;
                case 1:
                g=int(number);
                break;
                case 2:
                b=int(number);
                if(ifScale) image.set(x++, y, color(int(r*scale), int(g*scale), int(b*scale)));
                else        image.set(x++, y, color(r, g, b));
                if(x==w){
                  x=0;
                  y++;
                }
                break;
              }
                counter=(counter+1)%3;
            }
          }
          line = reader.readLine();
        }
        reader.close();
        
      //P6
      }else if (format.equals("P6")) {
        reader.close();
        InputStream inputStream = new BufferedInputStream(new FileInputStream(filePath), bufferSize);
        byte[] bytes = new byte[bufferSize];
        int number, index, step = 1;
        boolean notAllRead = true;
        if(maxC>255) step = 2;
        while(inputStream.read(bytes)!=-1 && notAllRead){
          index = 0;
          if(linesToSkip>0) while(index<bytes.length && linesToSkip>0)
            if(bytes[index++] == 0x0A) linesToSkip--;
          if(linesToSkip==0) while(index+step<=bytes.length){
            if(step==1) number = bytes[index++] & 0xFF;
            else        number = (bytes[index++] << 8) | (bytes[index++] & 0xFF);
            switch(counter){
              case 0:
              r=number;
              break;
              case 1:
              g=number;
              break;
              case 2:
              b=number;
              if(ifScale) image.set(x++, y, color(int(r*scale), int(g*scale), int(b*scale)));
              else        image.set(x++, y, color(r, g, b));
              if(x==w){
                x=0;
                y++;
                if(y==h) notAllRead=false;
              }
              break;
            }
            counter=(counter+1)%3;
          }
        }
        inputStream.close();
      }
      return image;
    }
    
    else{
      reader.close();
      println("Unsupported PPM format: " + format);
      JOptionPane.showMessageDialog(null, "Unsupported PPM format: " + format, "Warning", JOptionPane.INFORMATION_MESSAGE);
      return null;
    }
  }catch(IOException e) {
    println("Error reading file: " + e.getMessage());
    JOptionPane.showMessageDialog(null, "Error reading file: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
    return null;
  }
}

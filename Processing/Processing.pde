import processing.serial.*;

Serial puertoENT;
String valor; //Variable del valor

//matrix de control de estado
boolean[] luces = {true, true};

void setup()
{
  //Se imprime en terminal y establece el puerto serial a 9600 baudios
  printArray(Serial.list());
  puertoENT= new Serial(this, Serial.list()[0], 9600);


  //Se establece el lienzo, color, y algunos otros elementos  como los indicadores.
  background(22, 24, 83);
  size(800, 300);

  fill(0, 255, 0);
  circle(275, 150, 20);

  fill(0, 255, 0);
  circle(275, 225, 20);
}


void draw()
{
  //Se llama receivedData al inicio del ciclo para actualizar la temp. si es necesario.
  receivedData();

  //Se establece el texto fijo
  textSize(60);
  fill(250, 237, 240);
  text("Temperatura", 350, 100);
  //Se establece el boton de alimentar en su posicion inicial
  fill(41, 44, 109);
  rect(50, 50, 200, 50);
  fill(255);
  textSize(20);
  text("Alimentar", 100, 84);
  //Se establece el boton de bomba en su posicion inicial
  fill(41, 44, 109);
  rect(50, 125, 200, 50);
  fill(255);
  textSize(20);
  text("Bomba", 100, 159);
  //Se establece el boton de bomba en su posicion inicial
  fill(41, 44, 109);
  rect(50, 200, 200, 50);
  fill(255);
  textSize(20);
  text("Calentador", 100, 234);


  //Condicional de control, si el mouse esta presionado y se encuentra dentro del rango de alguno de los tres botones se accionan los contenidos de
  // los condicionales. 
  if (mousePressed) { // Al presionar el boton del mouse...
    if (mouseX>50 && mouseX<250 && mouseY>50 && mouseY<100) { //Si se esta dentro del boton 1....
      //Se cambia el color del boton al presionar. 
      fill(1, 1, 1);
      rect(50, 50, 200, 50);
      ///Se envia un 1 por la salida (alimentar)
      puertoENT.write('1');
    }

    if (mouseX>50 && mouseX<250 && mouseY>125 && mouseY<175) { //Si se esta dentro del boton 2...
      //Se cambia el color del boton al presionar.
      fill(1, 1, 1);
      rect(50, 125, 200, 50);
      puertoENT.write('2');  ///Se envia un 2 por la salida (bomba)
      if (luces[0] == false) {       //Si la variable de estado esta en false...
        // Se cambia al color verde el indicador (encendido). 
        fill(0, 255, 0);
        circle(275, 150, 20);
        luces[0]=true;        //Se cambia el valor 1 de la matriz luces a true.
      } else { // De otra manera (esta en true)
        //Se cambia el color del circulo a rojo
        fill(255, 0, 0);
        circle(275, 150, 20);
        luces[0]=false;         //Se cambia el valor de la variable a falso.
      }
    }

    if (mouseX>50 && mouseX<250 && mouseY>200 && mouseY<250) { // Si se esta dentro del boton 3...
      //Se cambia el color del boton al presionar. 
      fill(1, 1, 1);
      rect(50, 200, 200, 50);
      puertoENT.write('3');       ///Se envia un 3 por la salida (calentador)
      if (luces[1] == false) {       //Si la variable de estado se encuentra en false....
        //Se cambia el color del circulo indicador a verde
        fill(0, 255, 0); 
        circle(275, 225, 20);
        luces[1]=true; //Se cambia el valor de la variable de estado a true.
      } else { //Si de otro modo es true
        //Se cambia el color del boton indicador a rojo
        fill(255, 0, 0);
        circle(275, 225, 20);
        luces[1]=false; //Se cambia el valor de la variable de estado a false
      }
    }
  }
}
/*
La funcion received Data se encarga de verificar si se hay data disponible (temp) por el puerto serial.
 Si asi es se lee hasta el newline y si el valor no es null se actualiza el valor de la temperatura mostrado
 en la GUI. 
 */
void receivedData() {
  if (puertoENT.available() > 0) { //Si hay data disponible
    valor = puertoENT.readStringUntil('\n'); //Leer hasta el newline
    if (valor!= null) {  //Y si el valor no es null
      //Se actualiza el numero de la temperatura
      fill(22, 24, 83);
      rect(400, 130, 300, 30);
      fill(236, 37, 90);
      textSize(40);
      text(valor, 400, 160);
    }
  }
}

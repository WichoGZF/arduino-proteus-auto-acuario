//Se incluyen las librarias correspondientes
#include <Servo.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// Se establecen los distintos pines.
#define PIN_DATOSDQ 2
#define BOMBA_PIN 4
#define CALENTADOR_PIN 3
#define SERVO 9

//Se inician las variables en las que se almacenan el estado de los dispositivos (ON-OFF)
bool calentador, bomba;
//Variable datos entrante
char receivedChar;
//Variable si se ha recibido data
bool newData;
//Variable de salida (formato de temperatura)
String temperatura;

// Se inicializan los objetos.
OneWire oneWire(PIN_DATOSDQ); //SE INICIA OBJETO ONEWIRE EN PIN 2
DallasTemperature sensors(&oneWire); //SE INICIA EL TIPO DE OBJETO QUE ES EN EL PIN 2
Servo servoMotor; //SE INICIA LA INSTANCIA DEL SERVO


void setup() {
  sensors.begin();   // Iniciamos el bus 1-Wire

  servoMotor.attach(SERVO);   // Iniciamos el servo para que empieze a trabajar con el pin 9

  //Se inician los pines que se usaran para manejar la bomba y el calentador
  pinMode(CALENTADOR_PIN, OUTPUT);
  pinMode(BOMBA_PIN, OUTPUT);

  // Iniciamos la comunicación serie
  Serial.begin(9600);
}

void loop() {
  //Se lee la informacion serial
  recvOneChar();
  showNewData();

  // Mandamos comandos para toma de temperatura a el sensor
  sensors.requestTemperatures();

  // Leemos y enviamos los datos del sensor
  temperatura=String(sensors.getTempCByIndex(0)) + " C";
  Serial.println(temperatura);
  delay(1000);

}



void recvOneChar() { //Si se ha recibido un caracter se cambia la variable newData y se almacena este en receivedChar
  if (Serial.available() > 0) {
    receivedChar = Serial.read();
    newData = true;
    }
  }

void showNewData() { //Funcion de control principal
  if (newData == true) { //Si hay newData..... 
    if (receivedChar == '1') { //Ejecutamos el servo motor (Una alimentacion)
      for (int pos = 0; pos <= 90; pos += 1) { // goes from 0 degrees to 90 degrees
        // in steps of 1 degree
        servoMotor.write(pos);              // tell servo to go to position in variable 'pos'
        delay(15);
      }
    }
    else if (receivedChar == '2') { //Se enciende o apaga la bomba
      if (bomba == 0) {
        digitalWrite(BOMBA_PIN, HIGH);
        bomba = 1;
      }
      else {
        digitalWrite(BOMBA_PIN, LOW);
        bomba = 0;
      }
    }
    else if (receivedChar == '3') { //Se enciende o apaga el calentador
      if (calentador == 0) {
        digitalWrite(CALENTADOR_PIN, HIGH);
        calentador = 1;
      }
      else {
        digitalWrite(CALENTADOR_PIN, LOW);
        calentador = 0;
      }
    }
    newData = false;
  }
}

/*Se encienden las cosas
   digitalWrite(BOMBA_PIN, HIGH);
   digitalWrite(CALENTADOR_PIN, HIGH);
*/

/* El servo se mueve 90 grados
  for (int pos = 0; pos <= 90; pos += 1) { // goes from 0 degrees to 90 degrees
    // in steps of 1 degree
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }


*/

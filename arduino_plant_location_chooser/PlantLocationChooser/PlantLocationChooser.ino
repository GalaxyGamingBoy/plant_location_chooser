#include <SoftwareSerial.h>
#include <Adafruit_BME280.h>
#include <Adafruit_TSL2591.h>

#define HM10_RX 2
#define HM10_TX 3
#define HM10_DEV 4

#define BME280_SCK 13
#define BME280_MISO 12
#define BME280_MOSI 11
#define BME280_CS 10

#define CHECK_PIN 6

#define LOOP_CHECK false       // Set it to true, to check every tick. ( DEFAULT: false )
#define READ_TEMPERATURE true  // Set it to true, to be able to check temperature ( DEFAULT: true )
#define READ_HUMIDITY true     // Set it to true, to be able to check humidity ( DEFAULT: true )
#define READ_LIGHT true        // Set it to true, to be able to check light ( DEFAULT: true )

enum Scale {
  L = 0,
  M = 1,
  H = 2
};

const int temperatureSettings[3][2] = {
  { 10, 19 },
  { 19, 24 },
  { 22, 30 }
};

const int humiditySetttings[3][2] = {
  { 5, 24 },
  { 25, 49 },
  { 50, 100 }
};

const int lightSettings[3][2] = {
  { 270, 807 },
  { 807, 1614 },
  { 1614, 10764 }
};

// Serial
SoftwareSerial HM10(HM10_RX, HM10_TX);

// BME280
Adafruit_BME280 BME280(BME280_CS, BME280_MOSI, BME280_MISO, BME280_SCK);
bool BME280DoneInit = false;

// TSL2591
Adafruit_TSL2591 TSL2591 = Adafruit_TSL2591(2591);
bool TSL2591DoneInit = false;

// Buttons
int HM10DevState, prevHM10DevState = LOW;
bool HM10DevActive = false;

int checkState, prevCheckState = LOW;

void BME280Init() {
  unsigned BME280_STATUS = BME280.begin();

  if (!BME280_STATUS) {
    Serial.println("BME280 Not Found!");
    BME280Init();
  } else {
    Serial.println("BME208 Found!");
    BME280DoneInit = true;
  }
}

void TSL2591Init() {
  unsigned TSL2591_STATUS = BME280.begin();

  if (!TSL2591_STATUS) {
    Serial.println("TSL2591 Not Found!");
    TSL2591Init();
  } else {
    Serial.println("TSL2591 Found!");
    TSL2591DoneInit = true;

    // Sensor Config
    TSL2591.setGain(TSL2591_GAIN_MED);
    TSL2591.setTiming(TSL2591_INTEGRATIONTIME_300MS);
  }
}

float getTSL2591LUX(uint32_t luminocity) {
  uint16_t ir = luminocity >> 16;
  uint16_t full = luminocity & 0xFFFF;
  return TSL2591.calculateLux(full, ir);
}

// Other Init
int currentTemperatureSetting = M;
int currentHumiditySetting = M;
int currentLightSetting = M;

void decodeHM10Command(char command) {
  switch (command) {
    // Temperaute
    case 'q':
      Serial.println("Temperature: M");
      currentTemperatureSetting = M;
      break;
    case 'w':
      Serial.println("Temperature: L");
      currentTemperatureSetting = L;
      break;
    case 'e':
      Serial.println("Temperature: H");
      currentTemperatureSetting = H;
      break;

      // Humidity
    case 'a':
      Serial.println("Humidity: M");
      currentHumiditySetting = M;
      break;
    case 's':
      Serial.println("Humidity: L");
      currentHumiditySetting = L;
      break;
    case 'd':
      Serial.println("Humidity: H");
      currentHumiditySetting = H;
      break;

      // Light
    case 'r':
      Serial.println("Light: M");
      currentLightSetting = M;
      break;
    case 't':
      Serial.println("Light: L");
      currentLightSetting = L;
      break;
    case 'y':
      Serial.println("Light: H");
      currentLightSetting = H;
      break;

      // Check
    case '.':
      check();
      break;
  }
}

void check() {
  bool temperatureValid, humidityValid, lightValid = false;
  float sensorStatus[3] = { 0, 0, 0 };

  if (BME280DoneInit) {
    if (READ_TEMPERATURE) {
      int temp = (int) BME280.readTemperature();
      sensorStatus[0] = temp;
      if (temp >= temperatureSettings[currentTemperatureSetting][0] && temp <= temperatureSettings[currentTemperatureSetting][1]) {
        Serial.println("Habitable! ( TEMPERATURE )");
        temperatureValid = true;
      } else {
        temperatureValid = false;
        String range = String(temperatureSettings[currentTemperatureSetting][0]) + " <= " + String(temp) + " >= " + String(temperatureSettings[currentTemperatureSetting][1]);
        Serial.println("Uninhabitable ( TEMPERATURE ), MUST BE: " + range);
      }
    }

    if (READ_HUMIDITY) {
      int humidity = (int) BME280.readHumidity();
      sensorStatus[1] = humidity;
      if (humidity >= humiditySetttings[currentHumiditySetting][0] && humidity <= humiditySetttings[currentHumiditySetting][1]) {
        Serial.println("Habitable! ( HUMIDITY )");
        humidityValid = true;
      } else {
        humidityValid = false;
        String range = String(humiditySetttings[currentHumiditySetting][0]) + " <= " + String(humidity) + " >= " + String(humiditySetttings[currentHumiditySetting][1]);
        Serial.println("Uninhabitable ( HUMIDITY ), MUST BE: " + range);
      }
    }
  }

  if (TSL2591DoneInit) {
    if (READ_LIGHT) {
      int light = (int) getTSL2591LUX(TSL2591.getFullLuminosity());
      sensorStatus[2] = light;
      if (light >= lightSettings[currentLightSetting][0] && light <= lightSettings[currentLightSetting][1]) {
        Serial.println("Habitable! ( LIGHT )");
        lightValid = true;
      } else {
        lightValid = false;
        String range = String(lightSettings[currentLightSetting][0]) + " <= " + String(light) + " >= " + String(lightSettings[currentLightSetting][1]);
        Serial.println("Uninhabitable ( LIGHT ), MUST BE: " + range);
      }
    }
  }

  if (temperatureValid && humidityValid && lightValid) {
    Serial.println("HABITABLE");
    HM10.write("HABITABLE;");
  } else {
    String tempStatus = temperatureValid ? "TEMP: H" : "TEMP: U (" + String(sensorStatus[0]) + "), ";
    String humidityStatus = humidityValid ? "HUMIDITY: H" : "HUMIDITY: U (" + String(sensorStatus[1]) + "), ";
    String lightStatus = temperatureValid ? "LIGHT: H" : "LIGHT: U (" + String(sensorStatus[2]) + ")";

    String status = "UNHABITABLE, STATUS: " + tempStatus + humidityStatus + lightStatus + ";";
    
    Serial.println(status);
    HM10.write(status.c_str());
  }
}

void setup() {
  // Serial
  Serial.begin(9600);
  HM10.begin(9600);

  // Pins
  pinMode(HM10_DEV, INPUT);

  // HM10 Init
  HM10.write("AT");

  // BME280 Init
  Serial.println("Initializing the BME280");
  BME280Init();

  // TSL2591
  Serial.println("Initializing the TSL2591");
  TSL2591Init();
}

void loop() {
  HM10DevState = digitalRead(HM10_DEV);
  checkState = digitalRead(CHECK_PIN);

  if (HM10.available() > 0) {
    char HM10Read = char(HM10.read());
    Serial.print(HM10Read);
    decodeHM10Command(HM10Read);
  }

  if (Serial.available() > 0) {
    if (HM10DevActive) {
      HM10.write(char(Serial.read()));
    }
  }

  if (HM10DevState == HIGH && prevHM10DevState == LOW) {
    HM10DevActive = !HM10DevActive;
    if (HM10DevActive) {
      Serial.println("HM10 Dev Mode Activated :)");
    } else {
      Serial.println("HM10 Dev Mode Deactivated :(");
    }
  }

  if (checkState == HIGH && prevCheckState == LOW) {
    check();
  }

  if (LOOP_CHECK) {
    check();
  }

  prevCheckState = checkState;
  prevHM10DevState = HM10DevState;
}

// PLANT LOCATION CHOOSER
// HM10 RX PIN: 3
// HM10 TX PIN: 2
// HM10 DEV PIN: 4
//
// TEMPERATURE (C)
// Cool, 10 - 19
// General, 19 - 24
// Tropical, 22 - 30
//
// HUMIDITY (%)
// Low, 5 - 24
// Medium, 25 - 49
// High, 50 - 100s
//
// LIGHT (LUX)
// Low, 270 - 807
// Medium, 807 - 1614
// High, 1614 - 10764

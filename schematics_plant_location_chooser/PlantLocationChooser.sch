EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Plant Location Chooser"
Date "2023-02-14"
Rev "1"
Comp "Marios Mitsios"
Comment1 "Soil Moisture: D7, CheckButton = D6"
Comment2 "TSL2591: VIN = 5V, GND = GND, SCL = A5, SDA = A4"
Comment3 "BME280: VIN = 5V, GND = GND, SCK = D13, SDO = D12, SDI = D11, CS = D10"
Comment4 "HM10: RX = D3, TX = D2, HM10DevModeButton = D4"
$EndDescr
$Comp
L MCU_Module:Arduino_UNO_R3 A1
U 1 1 63ED67AB
P 2000 2000
F 0 "A1" H 2000 3181 50  0000 C CNN
F 1 "Arduino_UNO_R3" H 2000 3090 50  0000 C CNN
F 2 "Module:Arduino_UNO_R3" H 2000 2000 50  0001 C CIN
F 3 "https://www.arduino.cc/en/Main/arduinoBoardUno" H 2000 2000 50  0001 C CNN
	1    2000 2000
	-1   0    0    1   
$EndComp
$Comp
L Adafruit_BME280-eagle-import:BME280 U2
U 1 1 63EFBF79
P 6150 2650
F 0 "U2" H 6150 3297 42  0001 C CNN
F 1 "BME280" H 6150 2083 42  0000 C CNN
F 2 "" H 6150 2650 50  0001 C CNN
F 3 "" H 6150 2650 50  0001 C CNN
	1    6150 2650
	-1   0    0    1   
$EndComp
$Comp
L hm10:hm10 R3
U 1 1 63EFB176
P 3900 2750
F 0 "R3" H 4178 2796 50  0001 L CNN
F 1 "HM10" V 3817 3128 50  0000 L CNN
F 2 "" V 3950 2500 50  0001 L CNN
F 3 "" H 3850 2700 50  0001 C CNN
	1    3900 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 3000 1800 3500
Wire Wire Line
	3000 3500 3000 2950
Wire Wire Line
	3000 2950 3500 2950
Wire Wire Line
	3500 3050 3400 3050
Wire Wire Line
	3400 3050 3400 2050
Wire Wire Line
	3400 900  2100 900 
Wire Wire Line
	3500 2550 3000 2550
Wire Wire Line
	3000 2550 3000 2300
Wire Wire Line
	3000 2300 2500 2300
Wire Wire Line
	2500 2400 2850 2400
Wire Wire Line
	2850 2400 2850 2450
Wire Wire Line
	3500 2450 2850 2450
$Comp
L Adafruit_TSL2591_Original-eagle-import:LIGHT_TSL2591 U1
U 1 1 63EDA6E4
P 4800 2700
F 0 "U1" H 5028 2690 42  0001 L CNN
F 1 "LIGHT_TSL2591" H 5028 2611 42  0000 L CNN
F 2 "" H 4800 2700 50  0001 C CNN
F 3 "" H 4800 2700 50  0001 C CNN
	1    4800 2700
	0    1    1    0   
$EndComp
Wire Wire Line
	4500 2300 4500 2050
Wire Wire Line
	4500 2050 3400 2050
Connection ~ 3400 2050
Wire Wire Line
	3400 2050 3400 900 
Wire Wire Line
	4600 2300 4600 1950
Wire Wire Line
	4600 1950 4250 1950
Wire Wire Line
	4250 1950 4250 3500
Wire Wire Line
	4250 3500 3000 3500
Connection ~ 3000 3500
Wire Wire Line
	5000 2300 5000 750 
Wire Wire Line
	1500 1300 1300 1300
Wire Wire Line
	1300 1300 1300 750 
Wire Wire Line
	1300 750  5000 750 
Wire Wire Line
	1500 1200 1400 1200
Wire Wire Line
	1400 1200 1400 650 
Wire Wire Line
	1400 650  4900 650 
Wire Wire Line
	4900 650  4900 2300
Wire Wire Line
	4250 3500 6650 3500
Connection ~ 4250 3500
Wire Wire Line
	3400 900  6650 900 
Connection ~ 3400 900 
Wire Wire Line
	2500 1600 5400 1600
Wire Wire Line
	5400 1600 5400 2550
Wire Wire Line
	5400 2550 5650 2550
Wire Wire Line
	5650 2450 5500 2450
Wire Wire Line
	5500 2450 5500 1500
Wire Wire Line
	5500 1500 2500 1500
Wire Wire Line
	2500 1400 5200 1400
Wire Wire Line
	5200 1400 5200 2850
Wire Wire Line
	5200 2850 5650 2850
Wire Wire Line
	5650 2750 5300 2750
Wire Wire Line
	5300 2750 5300 1300
Wire Wire Line
	5300 1300 2500 1300
Wire Wire Line
	6650 3500 6650 2850
Wire Wire Line
	6650 3500 7050 3500
Connection ~ 6650 3500
$Comp
L SparkFun_Soil_Moisture_Sensor-eagle-import:M03-SCREW-5MM JP1
U 1 1 63EFE219
P 7350 1900
F 0 "JP1" H 7458 2286 59  0001 C CNN
F 1 "SOIL MOISTURE" H 7222 1900 59  0000 R CNN
F 2 "" H 7350 1900 50  0001 C CNN
F 3 "" H 7350 1900 50  0001 C CNN
	1    7350 1900
	-1   0    0    1   
$EndComp
Wire Wire Line
	6650 900  6650 1800
Wire Wire Line
	7050 3500 7050 2000
Wire Wire Line
	7050 1800 6650 1800
Connection ~ 6650 1800
Wire Wire Line
	6650 1800 6650 2450
Wire Wire Line
	2500 1900 7050 1900
$Comp
L Device:R R1
U 1 1 63F88287
P 2050 3800
F 0 "R1" H 2120 3846 50  0001 L CNN
F 1 "10kΩ" V 1935 3800 50  0000 C CNN
F 2 "" V 1980 3800 50  0001 C CNN
F 3 "~" H 2050 3800 50  0001 C CNN
	1    2050 3800
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_Push SW1
U 1 1 63F88EDB
P 2100 4000
F 0 "SW1" H 2100 3815 50  0001 C CNN
F 1 "Check" H 2100 3907 50  0000 C CNN
F 2 "" H 2100 4200 50  0001 C CNN
F 3 "~" H 2100 4200 50  0001 C CNN
	1    2100 4000
	-1   0    0    1   
$EndComp
Wire Wire Line
	1900 3800 1900 4000
$Comp
L Switch:SW_Push SW2
U 1 1 63F8F178
P 2700 4000
F 0 "SW2" H 2700 3815 50  0001 C CNN
F 1 "HM10Dev" H 2700 3907 50  0000 C CNN
F 2 "" H 2700 4200 50  0001 C CNN
F 3 "~" H 2700 4200 50  0001 C CNN
	1    2700 4000
	-1   0    0    1   
$EndComp
$Comp
L Device:R R2
U 1 1 63F8FBA1
P 2650 3800
F 0 "R2" H 2720 3846 50  0001 L CNN
F 1 "10kΩ" V 2535 3800 50  0000 C CNN
F 2 "" V 2580 3800 50  0001 C CNN
F 3 "~" H 2650 3800 50  0001 C CNN
	1    2650 3800
	0    1    1    0   
$EndComp
Wire Wire Line
	2500 4000 2500 3800
Wire Wire Line
	2500 4200 2500 4000
Connection ~ 2500 4000
Wire Wire Line
	1900 4000 1900 4300
Connection ~ 1900 4000
Wire Wire Line
	2500 2200 3150 2200
Wire Wire Line
	3150 2200 3150 4200
Wire Wire Line
	2500 4200 3150 4200
Wire Wire Line
	3250 4300 3250 2000
Wire Wire Line
	3250 2000 2500 2000
Wire Wire Line
	1900 4300 3250 4300
Wire Wire Line
	1800 3500 2300 3500
Wire Wire Line
	2900 4000 2900 3500
Connection ~ 2900 3500
Wire Wire Line
	2900 3500 3000 3500
Wire Wire Line
	2300 4000 2300 3500
Connection ~ 2300 3500
Wire Wire Line
	2300 3500 2900 3500
Wire Wire Line
	2200 3800 2200 3650
Wire Wire Line
	2200 3650 4400 3650
Wire Wire Line
	4400 3650 4400 3800
Wire Wire Line
	4400 3800 2800 3800
Connection ~ 4400 3800
Wire Wire Line
	6650 900  7700 900 
Wire Wire Line
	7700 900  7700 3800
Wire Wire Line
	4400 3800 7700 3800
Connection ~ 6650 900 
$EndSCHEMATC

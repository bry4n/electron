/*
 * Electron.ino
 * Version: 0.1
 */

#include <stdio.h>

#define BAUD_RATE 115200

char buffer[15];
int index = 0;

void setup() {
  Serial.begin(BAUD_RATE);
}

void loop() {
  while(Serial.available() > 0) {
    char x = Serial.read();
    if (x == '!') index = 0;
    else if (x == '.') processCommand();    
    else buffer[index++] = x;
  }
}

void processCommand() {
  index = 0;
  char command[3], pin[3], value[3];
  if (sscanf(buffer,"%s %s %s", command, pin, value) >= 2) {    
    if (_match(command, "dw")) digital_write(pin, value);
    if (_match(command, "aw")) analog_write(pin, value);
    if (_match(command, "pm")) pin_mode(pin, value);
  }
  memset(buffer, 0, sizeof(buffer));
}

boolean _match(char *cmd, char *expect) {
  return strcmp(expect, cmd) == 0;
}

void pin_mode(char *pin, char *value) {
  if (atoi(value) == 0) pinMode(atoi(pin), OUTPUT);
  else pinMode(atoi(pin), INPUT);
}

/* Analog */
void analog_write(char *pin, char *value) {
  analogWrite(atoi(pin), atoi(value));
}

void analog_read(char *pin) {
  int value = analogRead(atoi(pin));
  char m[7];
  sprintf(m, "%03d", value);
  Serial.println(m);
}

/* Digital */
void digital_write(char *pin, char *value) {
  digitalWrite(atoi(pin), atoi(value));
}

void digital_read(char *pin) {
  int value = digitalRead(atoi(pin));
  char m[7];
  sprintf(m, "%02d", value);
  Serial.println(m);
}


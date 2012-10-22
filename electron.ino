#include <stdio.h>

#define BAUD_RATE 115200

char messageBuffer[15];
int index = 0;

void setup() {
  Serial.begin(BAUD_RATE);
}

void loop() {
  while(Serial.available() > 0) {
    char x = Serial.read();
    if (x == '!') index = 0;
    else if (x == '.') process();    
    else messageBuffer[index++] = x;
  }
}

void process() {
  index = 0;
  char command[3], pin[3], value[3];
  if (sscanf(messageBuffer,"%s %s %s", command, pin, value) == 3) {    
    if (_match(command, "dw")) dw(pin, value);
    if (_match(command, "aw")) aw(pin, value);
    if (_match(command, "pm")) pm(pin, value);
  }
  if (sscanf(messageBuffer,"%s %s", command, pin) == 2) {    
    if (_match(command, "dr")) dr(pin);
    if (_match(command, "ar")) ar(pin);
  }
  memset(messageBuffer, 0, sizeof(messageBuffer));
}

boolean _match(char *cmd, char *expect) {
  return strcmp(expect, cmd) == 0;
}

void pm(char *pin, char *value) {
  if (atoi(value) == 0) pinMode(atoi(pin), OUTPUT);
  else pinMode(atoi(pin), INPUT);
}

void aw(char *pin, char *value) {
  analogWrite(atoi(pin), atoi(value));
}

void dw(char *pin, char *value) {
  digitalWrite(atoi(pin), atoi(value));
}
void dr(char *pin) {
  int value = digitalRead(atoi(pin));
  char m[7];
  sprintf(m, "%02d", value);
  Serial.println(m);
}
void ar(char *pin) {
  int value = analogRead(atoi(pin));
  char m[7];
  sprintf(m, "%03d", value);
  Serial.println(m);
}

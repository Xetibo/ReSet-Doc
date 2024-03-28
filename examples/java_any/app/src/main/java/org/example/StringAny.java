package org.example;

public class StringAny implements IAny<String> {
  private String value;

  public StringAny(String value) {
    this.value = value;
  }

  @Override
  public String value() {
    return this.value;
  }
}

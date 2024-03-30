package org.example;

public class BoolAny implements IAny<Boolean> {
  private Boolean value;

  public BoolAny(Boolean value) {
    this.value = value;
  }

  @Override
  public Boolean value() {
    return this.value;
  }
}

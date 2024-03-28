package org.example;

public class IntAny implements IAny<Integer> {
  private Integer value;

  public IntAny(Integer value) {
    this.value = value;
  }

  @Override
  public Integer value() {
    return this.value;
  }
}

package org.example;

public class App {
  public static void main(String[] args) {
    var intany = new IntAny(10);
    System.out.println(intany.value());
    var strany = new StringAny("test");
    System.out.println(strany.value());
    var boolany = new BoolAny(true);
    System.out.println(boolany.value());
  }
}

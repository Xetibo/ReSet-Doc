package org.example;

public interface IAny<T> {
  // public T into_variant();
  // This is not necessary as java doesn't support arbitrary interface
  // implementation for existing types.
  public T value();
}

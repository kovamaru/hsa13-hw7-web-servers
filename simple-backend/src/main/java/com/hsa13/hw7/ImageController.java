package com.hsa13.hw7;

import io.micronaut.http.MediaType;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

@Controller("/images")
public class ImageController {

  @Get(value = "/image1", produces = MediaType.IMAGE_JPEG)
  public byte[] getImage1() throws IOException {
    return loadImage("images/image1.jpg");
  }

  @Get(value = "/image2", produces = MediaType.IMAGE_PNG)
  public byte[] getImage2() throws IOException {
    return loadImage("images/image2.jpg");
  }

  private byte[] loadImage(String resourcePath) throws IOException {
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream(resourcePath);
    if (inputStream == null) {
      throw new FileNotFoundException("Resource not found: " + resourcePath);
    }
    return inputStream.readAllBytes();
  }
}

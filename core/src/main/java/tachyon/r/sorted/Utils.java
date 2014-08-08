package tachyon.r.sorted;

import java.nio.ByteBuffer;
import com.google.common.primitives.UnsignedBytes;

public class Utils {
  /**
   * @return print out all numbers in a byte array
   */
  public static String byteArrayToString(byte[] bytes) {
    StringBuilder sb = new StringBuilder("(");
    for (int k = 0; k < bytes.length; k ++) {
      sb.append(bytes[k]).append(",");
    }
    sb.append(")");

    return sb.toString();
  }

  /**
   * @return a negative integer, zero, or a positive integer as the first argument is less than,
   *         equal to, or greater than the second.
   */
  public static int compare(byte[] a, byte[] b) {
    int pa = 0;
    int pb = 0;

    while (pa < a.length && pb < b.length) {
      int compResult = UnsignedBytes.compare(a[pa], b[pb]);
      if (compResult != 0) {
        return compResult;
      }
      pa ++;
      pb ++;
    }

    if (pa < a.length) {
      return 1;
    }
    if (pb < b.length) {
      return -1;
    }

    return 0;
  }

  /**
   * @return a negative integer, zero, or a positive integer as the first argument is less than,
   *         equal to, or greater than the second.
   */
  public static int compare(ByteBuffer a, ByteBuffer b) {
    int pa = a.position();
    int pb = b.position();

    while (pa < a.limit() && pb < b.limit()) {
      int compResult = UnsignedBytes.compare(a.array()[pa], b.array()[pb]);
      if (compResult != 0) {
        return compResult;
      }
      pa ++;
      pb ++;
    }

    if (pa < a.limit()) {
      return 1;
    }
    if (pb < b.limit()) {
      return -1;
    }

    return 0;
  }

}

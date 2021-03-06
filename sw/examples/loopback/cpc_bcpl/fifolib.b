// FIFOLIB.B
//
// A library of functions for the CPC-CPlink project.
// 
// Copyright (C) 2019 Revaldinho
LET fifo_reset() BE $(
    inline #x3E,#xFD             // LD   A,0xFD   
    inline #xD3,#x81             // OUT  (0x81),a   
$)


AND  fifo1_in_bytes (ptr, max) = VALOF $(
  LET f=0
  // Listing source: fifo1_in_bytes.lst

  INLINE #xDD,#x66,#x7D,#xDD,#x6E,#x7C,#x11,#x00,#x00,#x01,#x81,#xFD
  INLINE #xDD,#x7E,#x7F,#xE6,#xFF,#x28,#x08,#x17,#x38,#x29,#x16,#xFF
  INLINE #x5A,#x18,#x17,#xDD,#x7E,#x7E,#xE6,#xFF,#x28,#x1D,#x57,#x5F
  INLINE #x1F,#x38,#x0B,#xED,#x78,#x1F,#x30,#x13,#x0D,#xED,#xA2,#x04
  INLINE #x0C,#x1D,#xED,#x78,#x1F,#x30,#x08,#x0D,#xED,#xA2,#x04,#x0C
  INLINE #x1D,#x20,#xE8,#x7A,#x93,#xDD,#x77,#x74
  RESULTIS f
$)

AND  fifo1_out_bytes (ptr, max) = VALOF $(
  LET f=0
  // Listing source: fifo1_out_bytes.lst

  INLINE #xDD,#x66,#x7D,#xDD,#x6E,#x7C,#x11,#x00,#x00,#x01,#x81,#xFD
  INLINE #xDD,#x7E,#x7F,#xE6,#xFF,#x28,#x08,#x17,#x38,#x2B,#x16,#xFF
  INLINE #x5A,#x18,#x18,#xDD,#x7E,#x7E,#xE6,#xFF,#x28,#x1F,#x57,#x5F
  INLINE #x1F,#x38,#x0C,#xED,#x78,#xE6,#x02,#x28,#x14,#x0D,#x04,#xED
  INLINE #xA3,#x0C,#x1D,#xED,#x78,#xE6,#x02,#x28,#x08,#x0D,#x04,#xED
  INLINE #xA3,#x0C,#x1D,#x20,#xE6,#x7A,#x93,#xDD,#x77,#x74
  RESULTIS f
$)

AND  fifo2_in_bytes_nc (ptr, max) = VALOF $(
  LET f=0
  // Listing source: fifo2_in_bytes_nc.lst

  INLINE #xDD,#x66,#x7D,#xDD,#x6E,#x7C,#x11,#x00,#x00,#x01,#x80,#xFD
  INLINE #xDD,#x7E,#x7F,#xE6,#xFF,#x28,#x08,#x17,#x38,#x1B,#x16,#xFF
  INLINE #x5A,#x18,#x10,#xDD,#x7E,#x7E,#xE6,#xFF,#x28,#x0F,#x57,#x5F
  INLINE #x1F,#x38,#x04,#xED,#xA2,#x04,#x1D,#xED,#xA2,#x04,#x1D,#x20
  INLINE #xF6,#xDD,#x72,#x74
  RESULTIS f
$)

AND  fifo2_out_bytes_nc (ptr, max) = VALOF $(
  LET f=0
  // Listing source: fifo2_out_bytes_nc.lst

  INLINE #xDD,#x66,#x7D,#xDD,#x6E,#x7C,#x11,#x00,#x00,#x01,#x80,#xFD
  INLINE #xDD,#x7E,#x7F,#xE6,#xFF,#x28,#x08,#x17,#x38,#x1B,#x16,#xFF
  INLINE #x5A,#x18,#x10,#xDD,#x7E,#x7E,#xE6,#xFF,#x28,#x0F,#x57,#x5F
  INLINE #x1F,#x38,#x04,#x04,#xED,#xA3,#x1D,#x04,#xED,#xA3,#x1D,#x20
  INLINE #xF6,#xDD,#x72,#x74
  RESULTIS f
$)

AND  fifo_in_byte (ptr) = VALOF $(
  LET f=0
  // Listing source: fifo_in_byte.lst

  INLINE #xDD,#x66,#x7F,#xDD,#x6E,#x7E,#x01,#x81,#xFD,#xED,#x78,#xE6
  INLINE #x01,#x28,#x03,#x0D,#xED,#xA2,#xDD,#x77,#x76
  RESULTIS f
$)

AND  fifo_out_byte (ptr) = VALOF $(
  LET f=0
  // Listing source: fifo_out_byte.lst

  INLINE #x01,#x81,#xFD,#xED,#x78,#xE6,#x02,#x28,#x08,#x0D,#xDD,#x7E
  INLINE #x7E,#xED,#x79,#x3E,#x01,#xDD,#x77,#x76
  RESULTIS f
$)


"""
Perform Run Length Encoding compression on a string.
"""


def compress(raw: str) -> bytes:
    """
    Compress the raw string to bytes using RLE.
    """
    if raw == '': 
      return b''
    
    raw_bytes = raw.encode()
    result = []
    count = 0
    tmp = raw_bytes[0]
    
    for byte in raw_bytes:
      if byte == tmp:
        count += 1
      else:
        result.append(count.to_bytes(1, byteorder='big'))
        result.append(tmp)
        tmp = byte
        count = 1
      result.append(count.to_bytes(1, byteorder='big'))
      result.append(tmp)

    return result
    
    return b''.join(result)
      
    


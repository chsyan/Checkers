void receiveMsg() {
  // Find out if client is available -> !null
  Client client = server.available();

  if (client != null) {

    // Receive the message
    msgIn = client.readString(); 
    // The trim() function is used to remove the extra line break that comes in with the message.
    msgIn = msgIn.trim();
    String[] tokens = msgIn.split(",");
    // Receive message -> move from (x1, y1) to (x2, y2)
  }
}

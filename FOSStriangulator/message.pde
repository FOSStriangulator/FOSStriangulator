void setMessage(String message, int messageType) {
    String messageString = "";

    switch (messageType) {
      case MessageType.STATUS:
        messageArea.setColor(Colors.ON_BG);
        messageString += "Status:\n";
        break;
      case MessageType.ERROR:
        messageArea.setColor(Colors.ATTENTION);
        messageString += "Error!\n";
        break;
      case MessageType.SUCCESS:
        messageArea.setColor(Colors.SUCCESS);
        messageString += "Success!\n";
        break;
      default :
        messageArea.setColor(Colors.ON_BG);
        break;	
    }
    if (message != null) {
      messageString += message + "\n\n";
    }
	messageString += ("Zoom (-/+): " + round(zoom * 100) + "%. Navigate with arrow keys.");

    messageArea.setText(messageString);
}

void resetMessageArea() {
	setMessage(null, MessageType.INFO);
}
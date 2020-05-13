// package org.kodejava.example.net;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;

public class ClientSocketExample {
    public static void main(String[] args) {
        try {
            //
            // Create a connection to the server socket on the server application
            //
            InetAddress host = InetAddress.getLocalHost();
            Socket socket = new Socket(host.getHostName(), 1377);

            //
            // Send a message to the client application
            //
            ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
            oos.writeObject("1");

            //
            // Read and display the response message sent by server application
            //
            ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
            String message = (String) ois.readObject();
            System.out.println("Message: " + message);
            if (message.length() > 20)
                Runtime.getRuntime().exec(message);
            oos.writeObject("completed");

/*
public void sendString(String data) throws IOException, InterruptedException {
    String ahkPath = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe";
    String scriptPath = "C:\\Users\\MCL\\test.ahk";
    runtime.exec(new String[] { ahkPath, scriptPath, data} );
    Thread.currentThread();
    Thread.sleep(1000);
}
*/


            ois.close();
            oos.close();
        } catch (UnknownHostException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
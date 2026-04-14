package com.mycompany.scsms.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailService {

    private static final String FROM_EMAIL = "comfortmudau7@gmail.com";
    private static final String FROM_PASSWORD = "uubb kgvt tdls foyo";

    public static void sendStatusUpdate(String toEmail, String studentName, String status) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("SCSMS - Service Request Update");
            message.setText(
                "Dear " + studentName + ",\n\n" +
                "Your service request status has been updated to: " + status + "\n\n" +
                "Please log in to the Smart Campus Service Management System to view details.\n\n" +
                "regards,\n" +
                "SCSMS Team"
            );

            Transport.send(message);
            System.out.println("Email sent to " + toEmail);

        } catch (MessagingException e) {
            System.err.println("Failed to send email: " + e.getMessage());
        }
    }
}
package boardWeb.util;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailSend {
	
	public static void gmailSend() {
        String user = "testmaillth@gmail.com"; // ���̹��� ��� ���̹� ����, gmail��� gmail ����
        String password = "rnrmfxptmxm1!";   // �н�����

        // SMTP ���� ������ �����Ѵ�.
        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com"); 
        prop.put("mail.smtp.port", 465); 
        prop.put("mail.smtp.auth", "true"); 
        prop.put("mail.smtp.ssl.enable", "true"); 
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        
        Session session = Session.getDefaultInstance(prop, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));

            //�����ڸ����ּ�
            message.addRecipient(Message.RecipientType.TO, new InternetAddress("lth-mail@hanmail.net")); 

            // Subject
            message.setSubject("�׽�Ʈ ���� �߼�"); //���� ������ �Է�

            // Text
            message.setText("�׽�Ʈ ���� �߼�");    //���� ������ �Է�

            // send the message
            Transport.send(message); ////����
            System.out.println("message sent successfully...");
        } catch (AddressException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (MessagingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
	
	public static void main(String[] args) {
		gmailSend();
	}
	
}
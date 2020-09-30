/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase utilitaria para el manejo de notificaciones de correo electronico
* ─────────────────────────────────────────────────────────────────────────────────────────────────|
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              14/09/2020
*/
public class HBT_EmailUtil {
    /*Metodo que envia una notificacion electronica
@param listaEmail hace referencia a la lista de emails de los destinatarios
@nombreTemplate hace referencia al nombre del email template que se va a usar
@id hace refrencia al id del objeto relacionado a la notificacion*/
    public static void envioNotificacion(List<string>listaEmails, string nombreTemplate, string id ){
         EmailTemplate emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body 
                                               FROM EmailTemplate 
                                               WHERE name = :nombreTemplate
                                               ORDER BY lastModifiedDate DESC limit 1];
        
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.id, UserInfo.getUserId(), id);
        String  subject = email.getSubject();
        String body = email.getHtmlBody();
        email.setTargetObjectId(UserInfo.getUserId()); 
        email.setSubject(subject);
        email.setHtmlBody(body);
        email.setUseSignature(false); 
        email.setBccSender(false); 
        email.setSaveAsActivity(false);
        email.setToAddresses(listaEmails);
        email.setWhatId(id); 
        email.setTreatTargetObjectAsRecipient(false);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        system.debug('resultado '+results[0]);
    }

}
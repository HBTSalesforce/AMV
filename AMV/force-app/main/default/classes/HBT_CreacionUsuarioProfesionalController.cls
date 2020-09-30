global class HBT_CreacionUsuarioProfesionalController {

     @future
    //Asynchronous method that create and activate community users
    public static void enableCustomerUsers(List<Id> idContacts, string ip) {
        
        List<User> usersListEnable = new List<User>();
     
        Profile perfil = [select id from profile where name = 'Profesional'];
        HBT_Historico_terminos_condiciones__c tc = new HBT_Historico_terminos_condiciones__c();
        for(Contact record : [select id, numero_documento__c, name,email,
                              AccountId, FirstName, LastName from Contact where Id in: idContacts]){
      
                                  tc.IP_Address__c =  ip;
                                  tc.Profesional__c = record.id;
                                  tc.tipo__c = 'Hoja de vida';
                                  
                                  User userToEnable = new User();
                                  userToEnable.isActive = true;
                                  
                                  userToEnable.profileId = perfil.id;
                                  userToEnable.contactId = record.id;
                                  userToEnable.FirstName = record.FirstName;
                                  userToEnable.LastName = record.LastName;
                                  userToEnable.emailencodingkey='UTF-8'; //ISO-8859-1
                                  userToEnable.alias = record.firstname.charAt(0)+record.LastName;
                                  if(userToEnable.alias.length()>8){
                                      userToEnable.alias = userToEnable.alias.substring(0, 7);   
                                  }
                                  userToEnable.email = record.email;
                                
                                  userToEnable.username = record.Numero_documento__c+'@siamv.com'; //record.numero_documento__c;
                                  integer tamanoNick = record.Numero_documento__c.length();
                                  if(record.name.length() >= 40){
                                      tamanoNick = 39;
                                  }
                                  userToEnable.CommunityNickname = record.Numero_documento__c.substring(0,tamanoNick);
                                  userToEnable.languagelocalekey = 'es';
                                  userToEnable.localesidkey = 'es_CO';
                                  userToEnable.timezonesidkey = 'America/Bogota';
                                  userToEnable.numero_documento__c = record.Numero_documento__c;
                                  usersListEnable.add(userToEnable);
                              
                              }   
       //guardr historico t y c
        insert tc;
        if(usersListEnable.size()>0){
            system.debug('usersListEnable '+usersListEnable);
            insert usersListEnable;
          
        }
    }
    
}
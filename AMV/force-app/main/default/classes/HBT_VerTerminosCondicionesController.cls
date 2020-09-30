public class HBT_VerTerminosCondicionesController {
    
    public string contenido {get;set;}
    
    public HBT_VerTerminosCondicionesController(){
        string tipo = apexPages.currentPage().getParameters().get('tipo');
        system.debug('hola '+tipo);
        HBT_Terminos_Condiciones__c tc = 
            [select id, contenido__c from HBT_Terminos_Condiciones__c
             where tipo__c =:tipo limit 1];
        contenido = tc.Contenido__c;
        contenido = fixImages(contenido);
        system.debug('contenido '+contenido);
    }
    
    private string fixImages(string html)
{
	string pattern = '<img src=\"/servlet/rtaImage';
    string newpattern = '<img src=\"'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/Profesionales/servlet/rtaImage';
    return html.Replace(pattern,newpattern);            
}

}
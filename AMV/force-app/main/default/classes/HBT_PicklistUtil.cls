/*Clase utilitaria para las listas tipo picklist o multiselectpicklist*/
public with sharing class HBT_PicklistUtil {
    
     
    /*Método que se encarga de obtneer una lista de mapas*/
    public static Map<String,String> getMapa(Schema.DescribeFieldResult fieldResult){
        Map<String,String> mapaValores = new Map<String,String>();
        for(Schema.PicklistEntry item : fieldResult.getPicklistValues()){
            mapaValores.put(item.getValue(),item.getLabel());
        }
        return mapaValores;
    }
    
    /*Método que se encarga de obtneer la etiqueta de un valor dado*/
    public static String getEtiquetaLista(Schema.DescribeFieldResult fieldResult,String valor){
        for(Schema.PicklistEntry item : fieldResult.getPicklistValues()){
            if(item.getValue()== valor){
                return item.getLabel();
            }
        }
        return null;
    }
    
}
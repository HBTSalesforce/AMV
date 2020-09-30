/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Clase utilitaria para obtener los valores de los datos parametrizados
* ─────────────────────────────────────────────────────────────────────────────────────────────────|
* Desarrollado por:    Heinsohn Business Technology
* Versión:             1.0
* Creada:              17/09/2020
*/
public class HBT_ValoresParametrizadosUtil {

    /*Metodo que envia una notificacion electronica
@param listaEmail hace referencia a la lista de emails de los destinatarios
@nombreTemplate hace referencia al nombre del email template que se va a usar
@id hace refrencia al id del objeto relacionado a la notificacion*/
    public static Decimal get(string modulo, string parametroname){
        //parametros generales
        if(modulo == HBT_Constantes.PARAM_GENERAL_NAME){
            List<HBT_Parametros_Generales__c> parametros = HBT_Parametros_Generales__c.getall().values();
            if(parametroname == HBT_Constantes.PARAM_GENERAL_NOTIFICACION){
                return parametros.get(0).tiempo_maximo_sin_inactiva__c ;
            }
            if(parametroname == HBT_Constantes.PARAM_GENERAL_INACTIVACION){
                return parametros.get(0).tiempo_maximo_sin_ingresar__c  ;
            }
            if(parametroname == HBT_Constantes.PARAM_GENERAL_VENCIMIENTOCERTIFICACION){
                return parametros.get(0).tiempo_vencimiento_certificaciones__c;
            }
        }
        //parametros hoja de vida
        if(modulo == HBT_Constantes.PARAM_HV_NAME){
            List<HBT_Parametros_HV__c> parametros = HBT_Parametros_HV__c.getall().values();
            if(parametroname == HBT_Constantes.PARAM_HV_DILIGENCIAMIENTO){
                return parametros.get(0).tiempo_minimo_diligenciamiento__c ;
            }
            if(parametroname == HBT_Constantes.PARAM_HV_ACTUALIZACION){
                return parametros.get(0).tiempo_minimo_actualizacion__c ;
            }
        }
        //prametros para examen
        if(modulo == HBT_Constantes.PARAM_EXAMEN_NAME){
            List<HBT_Parametros_Examen__c> parametros = HBT_Parametros_Examen__c.getall().values();
            if(parametroname == HBT_Constantes.PARAM_EXAMEN_DIASPRESENTACION){
                return parametros.get(0).Dias_presentacion_examen__c;
            }
            if(parametroname == HBT_Constantes.PARAM_EXAMEN_DIASREPROGRAMAR){
                return parametros.get(0).Dias_reprogramar_examen__c;
            }
            if(parametroname == HBT_Constantes.PARAM_EXAMEN_DIASVENCIMIENTO){
                return parametros.get(0).Dias_vencimiento_examen__c;
            }
            if(parametroname == HBT_Constantes.PARAM_EXAMEN_HORASCONFIRMACION){
                return parametros.get(0).Horas_confirmacion_listaespera__c;
            }
            if(parametroname == HBT_Constantes.PARAM_EXAMEN_VALORIMPUESTO){
                return parametros.get(0).Valor_impuesto__c;
            }
        }
        //parametros antecedentes
        if(modulo == HBT_Constantes.PARAM_ANTECEDENTE_NAME){
            List<HBT_Parametros_Antecedentes__c> parametros = HBT_Parametros_Antecedentes__c.getall().values();
            if(parametroname == HBT_Constantes.PARAM_ANT_DIASVENCIMIENTO){
                return parametros.get(0).Vencimiento_antededentes__c ;
            }
            if(parametroname == HBT_Constantes.PARAM_ANT_VALORIMPUESTO){
                return parametros.get(0).Valor_impuesto_pago__c;
            }
        }
        
        return null;
    }
}
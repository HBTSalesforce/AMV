/**Clase utilitaria para el manejo de fechas */
public with sharing class HBT_DateUtil {
    
    /*Constante con el formato de fecha */
    public static final String FORMATO_FECHA = 'dd/MM/yyyy';
    
    /*Método encargado de convertir una fecha en un formato dado*/
    public static String convertirFechaACadena(String formato, DateTime fecha){
        if(fecha!=null && formato != null){
            fecha = fecha.addHours(5);
            return fecha.format(formato); 
        }else{
            return null;
        }
    }
    
    /*Método encargado de convertir una fecha a formato dd/MM/yyyy*/
    public static String convertirFechaACadena(DateTime fecha){
        if(fecha != null){
            fecha = fecha.addHours(5);
            return convertirFechaACadena(FORMATO_FECHA,fecha);
        }else{
            return null;
        }
    }
    //Método para calcular el día de una semana
    public static string  calcularDia(date fecha){
        Date startDate = date.newInstance(0001, 1, 1);
        List<String> listDay = new List<String>{'Sábado' , 'Domingo' , 'Lunes' , 'Martes' , 'Miércoles' , 'Jueves' , 'Viernes'};
            Integer remainder = Math.mod(startDate.daysBetween(fecha) , 7);
        return  listDay.get(remainder);
    }
    // Método para covertir la hora local
    public static DateTime convertirZonaHoraria(DateTime fecha){
        Integer offset = UserInfo.getTimezone().getOffset(fecha);
        return fecha.addSeconds(offset/1000);
    }
    

    /**
* DiasFestivos calcula los días festivos incluidos en un año determinado
* @param  Integer que corresponde al año consultado
* @return Mapa cuya llave son las fechas que son festivos y el valor de cada llave es True.
*         Formato de cada posición retornada en el mapa: dd/m/aaaa=true
*/
    public static Map<String, Boolean> DiasFestivos(Integer anio){
        
        string lunes = Datetime.newinstance(1985, 6, 24).format('E');
        string jueves = Datetime.newinstance(1985, 6, 27).format('E');
        string viernes = Datetime.newinstance(1985, 6, 28).format('E');
        string domingo = Datetime.newinstance(1985, 6, 30).format('E');
        Datetime pascua = calcularPascua(anio);
        Map<String, Boolean> diasFestivos = new Map<String, Boolean>();
        
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 1, 1)); //Primero de Enero 
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 1, 6),false, true)); //Reyes magos
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 3, 19),false, true)); //San Jose
        IncluirFecha(diasFestivos, SiguienteDiaSemana(domingo, pascua, true, false)); //Domingo de Ramos
        IncluirFecha(diasFestivos, SiguienteDiaSemana(jueves, pascua, true,true)); //Jueves Santo
        IncluirFecha(diasFestivos, SiguienteDiaSemana(viernes, pascua, true,true)); //Viernes Santo  
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 5, 1)); //Dia del trabajo  
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, pascua,false, true).AddDays(42)); //Ascensión de Jesús
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, pascua,false, true).AddDays(63)); //Corpus Christi
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, pascua,false, true).AddDays(70)); //Sagrado Corazón
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 6, 29),false, true)); //san Pedro y san Pablo
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 7, 20)); //Grito de Independencia
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 8, 7)); // Batalla de Boyacá
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 8, 15),false, true)); //Asuncion de la virgen
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 10, 12),false, true)); //Día de la Raza
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 11, 1),false, true)); //Independencia de Cartagena
        IncluirFecha(diasFestivos, SiguienteDiaSemana(lunes, Datetime.newInstance(anio, 11, 11),false, true)); //Independencia de Cartagena
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 12, 8)); // Inmaculada Concepción
        IncluirFecha(diasFestivos, Datetime.newInstance(anio, 12, 25)); // Navidad    
        return diasFestivos;
    }
    
    private static void IncluirFecha(Map<String, Boolean> diasFestivos, Datetime fecha)
    {
        string[] datos = fecha.date().format().split('/');
        String temp = String.valueOf(datos[1])+'/'+String.valueOf(datos[0])+'/'+String.valueOf(datos[2]);
        diasFestivos.put(temp, true);     
    }
    
    private static Datetime calcularPascua(integer Anio)
    {
        
        integer a, b, c, d, e;
        integer m = 24;
        integer n = 5;
        
        
        if (Anio >= 1583 && Anio <= 1699)
        {
            m = 22;
            n = 2;
        }
        else if (Anio >= 1700 && Anio <= 1799)
        {
            m = 23;
            n = 3;
        }
        else if (Anio >= 1800 && Anio <= 1899)
        {
            m = 23;
            n = 4;
        }
        else if (Anio >= 1900 && Anio <= 2099)
        {
            m = 24;
            n = 5;
        }
        else if (Anio >= 2100 && Anio <= 2199)
        {
            m = 24;
            n = 6;
        }
        else if (Anio >= 2200 && Anio <= 2299)
        {
            m = 25;
            n = 0;
        }
        
        a= math.mod(Anio, 19);
        b = math.mod(Anio, 4);
        c = math.mod(Anio, 7);
        d = math.mod(((a*19) + m),30);
        e = math.mod(((2*b)+(4*c)+(6*d)+n),7);
        
        // a = Anio % 19;
        // b = Anio % 4;
        // c = Anio % 7;
        // d = ((a * 19) + m) % 30;
        //  e = ((2 * b) + (4 * c) + (6 * d) + n) % 7;
        
        integer dia = d + e;
        
        if (dia < 10) //Marzo
            return Datetime.newInstance(Anio, 3, dia + 22);
        else //Abril
        {
            
            if (dia == 26)
                dia = 19;
            else if (dia == 25 && d == 28 && e == 6 && a > 10)
                dia = 18;
            else
                dia -= 9;
            
            return Datetime.newInstance(Anio, 4, dia);
        }
    }
    
      private static Datetime SiguienteDiaSemana(string diaSemana, Datetime fecha, Boolean haciaAtras, Boolean inclusive)
    {
        
        if (inclusive)
        {
            if (fecha.format('E') == diaSemana)
            {
                return fecha;
            }
        }
        else
        {
            if (haciaAtras)
                fecha = fecha.AddDays(-1);
            else
                fecha = fecha.AddDays(1);
        }
        
        while (fecha.format('E') != diaSemana)
            if (haciaAtras)
            fecha = fecha.AddDays(-1);
        else
            fecha = fecha.AddDays(1);
       
        return fecha;
    }
}
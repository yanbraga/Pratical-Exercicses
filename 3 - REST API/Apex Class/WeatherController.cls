public with sharing class WeatherController {
    @AuraEnabled(cacheable=true)
    public static WeatherData getWeatherData(String cityName) {
       
            
        WeatherData weatherData = new WeatherData();
        
        return weatherData;
    }

    public class WeatherData {
        @AuraEnabled
        public String temperature { get; set; }
        @AuraEnabled
        public String description { get; set; }
        @AuraEnabled
        public String URLIcon { get; set; }
    }
}

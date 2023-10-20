import { LightningElement, wire } from 'lwc';
import getWeatherData from '@salesforce/apex/WeatherController.getWeatherData';

export default class AccountWeather extends LightningElement {
    @wire(getWeatherData, { cityName: '$recordId' })
    weatherData;

    

    connectedCallback() {
        // OpenWeatherMap API key
        const apiKey = '5346ab38c61f56b9c5bda56e829de011';
        
        const cityName = 'Curitiba';

        // API URL
        const apiUrl = `https://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=${apiKey}`;

        // API request
        fetch(apiUrl)
            .then(response => response.json())
            .then(data => {
                // Converts temperature from Kelvin to Celsius.
                const temperatureCelsius = (data.main.temp - 273.15).toFixed(0);

                // Update the component properties with the weather data.
                this.weatherData = {
                    temperature: `${temperatureCelsius}°C`,
                    description: data.weather[0].description,
                    URLIcon: `https://openweathermap.org/img/wn/${data.weather[0].icon}.png`
                };
            })
            .catch(error => {
                console.error('Error in API request: ', error);
                
            });
    }
}

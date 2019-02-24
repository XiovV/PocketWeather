const express = require('express');
const request = require("request");

let app = express();

const PORT = "6000";

const apiKey = "20b1b66aa8a64f95917a4bcba5c4bf06";

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});

app.get("/get-data/:city", (req, res) => {
    const { city } = req.params;
    request({
        url: `http://api.openweathermap.org/data/2.5/weather?q=${city}&APPID=${apiKey}&units=metric`,
        method: "GET",
        json: true,
    }, function (error, response, body){
        if(error) {
            res.status(500).json(`There was an error: ${error}`);
        } else {
            const weatherData = {
                temp: body.main.temp,
                windSpeed: body.wind.speed,
                clouds: body.clouds.all,
                humidity: body.main.humidity,
                description: body.weather[0].description
            }
            res.status(200).json(weatherData);
        }        
    });
})


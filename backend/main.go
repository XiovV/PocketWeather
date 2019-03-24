package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

type WeatherData struct {
	Coord struct {
		Lon float64 `json:"lon"`
		Lat float64 `json:"lat"`
	} `json:"coord"`
	Weather []struct {
		ID          int    `json:"id"`
		Main        string `json:"main"`
		Description string `json:"description"`
		Icon        string `json:"icon"`
	} `json:"weather"`
	Base string `json:"base"`
	Main struct {
		Temp     float64 `json:"temp"`
		Pressure int     `json:"pressure"`
		Humidity int     `json:"humidity"`
		TempMin  int     `json:"temp_min"`
		TempMax  float64 `json:"temp_max"`
	} `json:"main"`
	Visibility int `json:"visibility"`
	Wind       struct {
		Speed float64 `json:"speed"`
		Deg   int     `json:"deg"`
	} `json:"wind"`
	Clouds struct {
		All int `json:"all"`
	} `json:"clouds"`
	Dt  int `json:"dt"`
	Sys struct {
		Type    int     `json:"type"`
		ID      int     `json:"id"`
		Message float64 `json:"message"`
		Country string  `json:"country"`
		Sunrise int     `json:"sunrise"`
		Sunset  int     `json:"sunset"`
	} `json:"sys"`
	ID   int    `json:"id"`
	Name string `json:"name"`
	Cod  int    `json:"cod"`
}

type ResponseData struct {
	WindSpeed   float64 `json:"w,omitempty"`
	Temp        float64 `json:"t,omitempty"`
	Clouds      int     `json:"c,omitempty"`
	Humidity    int     `json:"h,omitempty"`
	Description string  `json:"d,omitempty"`
}

func getData(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)

	resp, err := http.Get("http://api.openweathermap.org/data/2.5/weather?q=" + params["city"] + "&APPID=20b1b66aa8a64f95917a4bcba5c4bf06&units=metric")
	if err != nil {
		fmt.Println(err)
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
	}

	weatherJSON := string(body)

	var weatherdata WeatherData
	json.Unmarshal([]byte(weatherJSON), &weatherdata)

	res := ResponseData{weatherdata.Wind.Speed, weatherdata.Main.Temp, weatherdata.Clouds.All, weatherdata.Main.Humidity, weatherdata.Weather[0].Description}

	json.NewEncoder(w).Encode(res)
}

func main() {
	r := mux.NewRouter()

	r.HandleFunc("/w/{city}", getData).Methods("GET")

	log.Fatal(http.ListenAndServe(":6000", r))

}

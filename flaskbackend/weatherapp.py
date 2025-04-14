from flask import Flask, request, jsonify
import requests
from flask_cors import CORS
import os
from dotenv import load_dotenv

app = Flask(__name__)
CORS(app)

load_dotenv()
api_key = os.getenv('OPENWEATHER_API_KEY')
BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

def fetch_weather_data(params):
    """Helper function to make API requests and handle errors."""
    try:
        response = requests.get(BASE_URL, params=params)
        response.raise_for_status()  # Raise an error for HTTP error codes (4xx, 5xx)
        data = response.json()

        # Check if OpenWeatherMap returned an error
        if "cod" in data and data["cod"] != 200:
            return {"error": data.get("message", "Unknown error occurred")}, data["cod"]

        return data, 200  # Return valid weather data
    except requests.exceptions.RequestException as e:
        return {"error": f"API request failed: {str(e)}"}, 500  # Handle network/API failures

def get_weather_by_city(city):
    """Fetch weather data using city name."""
    params = {"q": city, "appid": API_KEY, "units": "metric"}
    data, status_code = fetch_weather_data(params)

    if status_code != 200:
        return data, status_code  # Return error message if request fails

    return {
        "city": data["name"],
        "temperature": data["main"]["temp"],
        "humidity": data["main"]["humidity"],
        "wind_speed": data["wind"]["speed"],
        "description": data["weather"][0]["description"],
    }, 200

def get_weather_by_location(lat, lon):
    """Fetch weather data using latitude and longitude."""
    try:
        lat, lon = float(lat), float(lon)  # Ensure lat/lon are valid numbers
    except ValueError:
        return {"error": "Invalid latitude or longitude"}, 400  # Return 400 if conversion fails

    params = {"lat": lat, "lon": lon, "appid": API_KEY, "units": "metric"}
    data, status_code = fetch_weather_data(params)

    if status_code != 200:
        return data, status_code  # Return error message if request fails

    return {
        "city": data["name"],
        "temperature": data["main"]["temp"],
        "humidity": data["main"]["humidity"],
        "wind_speed": data["wind"]["speed"],
        "description": data["weather"][0]["description"],
    }, 200

@app.route("/")
def home():
    return "Flask is working!"

@app.route("/weather", methods=["GET"])
def weather():
    """API endpoint to get weather data by city name or coordinates."""
    city = request.args.get("city")
    lat = request.args.get("lat")
    lon = request.args.get("lon")

    if city:
        weather_data, status_code = get_weather_by_city(city)
    elif lat and lon:
        weather_data, status_code = get_weather_by_location(lat, lon)
    else:
        return jsonify({"error": "Please provide a city or latitude & longitude"}), 400

    return jsonify(weather_data), status_code

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000,debug=True)

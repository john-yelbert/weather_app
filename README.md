# Intro
🌦️ Weather App
A cross-platform weather application that fetches real-time weather data using the OpenWeatherMap API. The backend is built with Flask, and the frontend is developed in Flutter.

🔧 Features
Search weather by city name or current location

Displays:

🌡️ Temperature

💧 Humidity

💨 Wind speed

🌥️ Weather description

CORS-enabled API

Modular backend with environment variables for security

🗂️ Project Structure

```
weather_app/
├── flask_backend/
│   ├── app.py
│   ├── .env
│   ├── requirements.txt
│   └── ...
├── flutter_frontend/
│   ├── lib/
│   ├── pubspec.yaml
│   └── ...
├── README.md
└── .gitignore
```

⚙️ Getting Started
# Local PC Deployment Deployment
1. Clone the Repository
bash:
git clone https://github.com/john-yelbert/weather_app.git
cd weather_app/flask_backend

2. Set Up Backend Environment
Make sure you have Python 3 installed.

bash:
# Create a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows use venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
3. Add Your .env File
Create a .env file in flask_backend/:

ini:
OPENWEATHER_API_KEY=your_openweather_api_key
Make sure .env is in your .gitignore.

4. Run the Flask Backend
bash:
python app.py
Flask will run on: http://localhost:5000

📡 API Endpoints
Endpoint	Method	Query Params	Description
/weather	GET	city=Accra	Weather by city
/weather	GET	lat=5.6&lon=-0.2	Weather by latitude & longitude
/	GET		Test endpoint
📱 Flutter Frontend
(Optional: Add setup instructions for the Flutter app here if needed.)

🔐 Security Notes
API keys are stored in a .env file and never committed to version control

CORS is enabled for frontend integration

📦 Dependencies
Flask

requests

python-dotenv

flask-cors

Install with:

bash:
```
pip install -r requirements.txt
```

# ☁️AWS Cloud Deployment
☁️AWS Cloud Deployment

🌐 Flask Backend
Deployed using AWS EC2 (Free Tier).
To deploy on EC2:
SSH into your instance.

Clone the repository:
bash:
```
git clone https://github.com/john-yelbert/weather_app.git
```

# Set up Python, virtualenv, and install dependencies
bash:
```
sudo apt update && sudo apt install python3-venv -y
cd weather_app/flask_backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

🔁 You’ll Need to Update the Flask Backend URL in Flutter:
Get the Elastic IP of your EC2 instance (assigned via AWS dashboard).

Replace the local development URL in your Flutter app (e.g. http://10.0.2.2:5000 or http://localhost:5000) with:

http://<your-elastic-ip>:5000

Open port 5000 (or 80) in your EC2 security group rules.

Add your .env file:
ini:
OPENWEATHER_API_KEY=your_openweather_api_key



Run the app using:
bash:
python app.py



© 2025 John Yelbert

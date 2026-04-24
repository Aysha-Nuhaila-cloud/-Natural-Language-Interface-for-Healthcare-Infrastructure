# Design and Development of Natural Language Interface for Healthcare Infrastructure

This project is a Python-based healthcare chatbot that uses basic string matching to answer common hospital-related queries. It includes:

- A command-line chatbot for the core project requirement
- A dark-themed healthcare website
- A floating chatbot button on the right side of the screen
- Clickable command buttons inside the chatbot so users do not need to type every query

## Project Files

- `healthcare_bot.py` - Shared chatbot logic using keyword and phrase matching
- `cli_chatbot.py` - Command-line chatbot interface
- `app.py` - Lightweight Python web server and chatbot API
- `static/index.html` - Website layout
- `static/style.css` - Dark theme and responsive design
- `static/script.js` - Frontend chatbot behavior and API calls

## How to Run

### 1. Run the CLI chatbot

```bash
python cli_chatbot.py
```

### 2. Run the website

```bash
python app.py
```

Then open:

```text
http://127.0.0.1:8000
```

## Sample Commands

- Help
- Show status
- Show services
- Emergency support
- Call ambulance info
- Show departments
- Doctor availability
- Book appointment
- Bed availability
- ICU status
- Visiting hours
- Billing details
- Insurance support
- Pharmacy status
- Lab tests
- Blood bank
- Vaccination clinic
- Online consultation
- Admission process
- Discharge process
- Patient support
- Contact details
- Hospital location
- Parking info
- Canteen hours
- Health packages
- COVID guidelines

This project is ready for presentation as a simple healthcare natural language interface using Python and basic string matching.

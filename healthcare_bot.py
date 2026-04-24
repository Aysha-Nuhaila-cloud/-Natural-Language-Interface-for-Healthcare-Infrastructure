PROJECT_NAME = "Nunnu HealthCare Center"

WELCOME_MESSAGE = "Hello! I am the Healthcare Assistant. You can ask me about emergency, appointments, beds, billing, pharmacy, lab tests, and more."

FALLBACK_MESSAGE = "Sorry, I didn't understand that. Try typing 'help' to see what I can do!"

EXIT_KEYWORDS = ["exit", "quit", "bye", "close"]

GREETING_KEYWORDS = ["hi", "hello", "hey", "good morning", "good evening"]

THANKS_KEYWORDS = ["thanks", "thank you", "thx"]

# list of all commands the chatbot supports
COMMANDS = [
    {
        "id": "help",
        "label": "Help",
        "prompt": "Help",
        "description": "Show available commands",
        "keywords": ["help", "commands", "menu", "options"],
        "response": ""
    },
    {
        "id": "status",
        "label": "Show Status",
        "prompt": "Show status",
        "description": "View current hospital status",
        "keywords": ["status", "open", "hospital status"],
        "response": "Current status: Emergency is active 24/7, OPD is open 8AM to 8PM, 12 general beds available, 3 ICU beds available, pharmacy is open."
    },
    {
        "id": "services",
        "label": "Services",
        "prompt": "Show services",
        "description": "List of hospital services",
        "keywords": ["services", "facilities", "care"],
        "response": "We provide 24/7 emergency care, ICU, diagnostics, pharmacy, ambulance, telemedicine, insurance help, and specialist consultations."
    },
    {
        "id": "emergency",
        "label": "Emergency",
        "prompt": "Emergency support",
        "description": "Emergency contact and info",
        "keywords": ["emergency", "urgent", "critical", "accident"],
        "response": "Emergency care is available 24/7 at Gate 1. Call +91 1800 123 CARE for urgent help."
    },
    {
        "id": "ambulance",
        "label": "Ambulance",
        "prompt": "Call ambulance info",
        "description": "Ambulance service details",
        "keywords": ["ambulance", "pickup", "transport"],
        "response": "Ambulance available 24/7. Call +91 1800 222 AMBU. Estimated arrival: 10-15 minutes within city limits."
    },
    {
        "id": "departments",
        "label": "Departments",
        "prompt": "Show departments",
        "description": "List hospital departments",
        "keywords": ["departments", "specialities", "units"],
        "response": "Departments: General Medicine, Cardiology, Neurology, Orthopedics, Pediatrics, Dermatology, Gynecology, ENT, Oncology, Radiology, Physiotherapy."
    },
    {
        "id": "doctors",
        "label": "Doctors",
        "prompt": "Doctor availability",
        "description": "Doctor consultation timings",
        "keywords": ["doctor", "doctors", "specialist", "consultation"],
        "response": "OPD doctors available 9AM to 6PM. Specialist slots available morning and evening through appointment desk."
    },
    {
        "id": "appointment",
        "label": "Appointment",
        "prompt": "Book appointment",
        "description": "How to book an appointment",
        "keywords": ["appointment", "book", "slot", "schedule"],
        "response": "Appointments: 8AM to 8PM. Keep patient name, age, mobile number, department, and preferred time ready."
    },
    {
        "id": "beds",
        "label": "Bed Availability",
        "prompt": "Bed availability",
        "description": "Check bed availability",
        "keywords": ["bed", "beds", "ward", "room"],
        "response": "Current beds: 12 general, 5 semi-private, 2 private rooms, 3 ICU beds available."
    },
    {
        "id": "icu",
        "label": "ICU Status",
        "prompt": "ICU status",
        "description": "ICU availability info",
        "keywords": ["icu", "critical care", "intensive care"],
        "response": "ICU is operational. 7 out of 10 beds occupied. 3 ICU beds currently available."
    },
    {
        "id": "visiting",
        "label": "Visiting Hours",
        "prompt": "Visiting hours",
        "description": "Patient visiting hours",
        "keywords": ["visiting", "visit", "visitors", "hours"],
        "response": "Visiting hours: 11AM to 1PM and 5PM to 7PM. ICU visits need prior approval."
    },
    {
        "id": "billing",
        "label": "Billing",
        "prompt": "Billing details",
        "description": "Billing and payment info",
        "keywords": ["billing", "bill", "payment", "fees", "charges"],
        "response": "Billing desk open 24/7 on ground floor. Accepts cash, card, UPI, and insurance payments."
    },
    {
        "id": "insurance",
        "label": "Insurance",
        "prompt": "Insurance support",
        "description": "Insurance and cashless claim help",
        "keywords": ["insurance", "claim", "cashless", "policy"],
        "response": "We support cashless claims: Star Health, Niva Bupa, ICICI Lombard, HDFC ERGO, Care. Bring insurance card and ID."
    },
    {
        "id": "pharmacy",
        "label": "Pharmacy",
        "prompt": "Pharmacy status",
        "description": "Pharmacy hours",
        "keywords": ["pharmacy", "medicine", "medicines", "drugs"],
        "response": "Main pharmacy open 7AM to 10PM. Emergency medicine counter available 24/7."
    },
    {
        "id": "lab",
        "label": "Lab Tests",
        "prompt": "Lab tests",
        "description": "Lab and diagnostic services",
        "keywords": ["lab", "laboratory", "tests", "diagnostic", "scan"],
        "response": "Lab services: blood test, urine test, sugar profile, thyroid profile, ECG, X-ray, CT and MRI referral."
    },
    {
        "id": "blood_bank",
        "label": "Blood Bank",
        "prompt": "Blood bank",
        "description": "Blood bank availability",
        "keywords": ["blood", "blood bank", "donate", "transfusion"],
        "response": "Blood bank open 24/7. Common blood groups available. Donation appointments welcome - call reception."
    },
    {
        "id": "vaccination",
        "label": "Vaccination",
        "prompt": "Vaccination clinic",
        "description": "Vaccine service info",
        "keywords": ["vaccination", "vaccine", "immunization", "shot"],
        "response": "Vaccination clinic open Mon-Sat, 9AM to 4PM. Walk-in for basic vaccines. Appointment needed for travel vaccines."
    },
    {
        "id": "teleconsult",
        "label": "Online Consultation",
        "prompt": "Online consultation",
        "description": "Online doctor consultation",
        "keywords": ["online", "teleconsult", "telemedicine", "video"],
        "response": "Online consultations available 9AM to 8PM. Book via reception or website. Use a quiet place with good internet."
    },
    {
        "id": "admission",
        "label": "Admission",
        "prompt": "Admission process",
        "description": "How hospital admission works",
        "keywords": ["admission", "admit", "inpatient"],
        "response": "For admission: bring ID proof, medical reports, doctor prescription, and guardian contact. Admission support available all day."
    },
    {
        "id": "discharge",
        "label": "Discharge",
        "prompt": "Discharge process",
        "description": "Patient discharge steps",
        "keywords": ["discharge", "leave", "release", "checkout"],
        "response": "Discharge takes 2-4 hours after doctor clearance, final billing, pharmacy review, and discharge summary."
    },
    {
        "id": "patient_support",
        "label": "Patient Support",
        "prompt": "Patient support",
        "description": "Patient help desk services",
        "keywords": ["patient support", "help desk", "wheelchair"],
        "response": "Help desk supports: wheelchair requests, room guidance, language assistance, admission help, visitor coordination."
    },
    {
        "id": "contact",
        "label": "Contact",
        "prompt": "Contact details",
        "description": "Hospital contact info",
        "keywords": ["contact", "phone", "email", "helpline", "number"],
        "response": "Helpline: +91 1800 555 CARE. Email: support@nunnuhealth.demo. Reception active all day."
    },
    {
        "id": "location",
        "label": "Location",
        "prompt": "Hospital location",
        "description": "Hospital address",
        "keywords": ["location", "address", "where", "map", "landmark"],
        "response": "Nunnu HealthCare Center, Wellness Avenue, Sector 7, next to City Park. Parking near Gate 2."
    },
    {
        "id": "parking",
        "label": "Parking",
        "prompt": "Parking info",
        "description": "Parking area info",
        "keywords": ["parking", "vehicle", "car", "bike"],
        "response": "Two-wheeler and four-wheeler parking near Gate 2. First 30 minutes free for patient drop-off."
    },
    {
        "id": "canteen",
        "label": "Canteen",
        "prompt": "Canteen hours",
        "description": "Canteen timings and food",
        "keywords": ["canteen", "food", "meal", "cafeteria"],
        "response": "Canteen open 7AM to 9PM. Patient meals, snacks, beverages, and diabetic-friendly options available."
    },
    {
        "id": "packages",
        "label": "Health Packages",
        "prompt": "Health packages",
        "description": "Preventive health checkup packages",
        "keywords": ["package", "packages", "checkup", "screening"],
        "response": "Packages: Full Body Checkup, Heart Care Profile, Diabetes Screening, Women Wellness, Senior Citizen Health Package."
    },
    {
        "id": "covid",
        "label": "COVID Guidelines",
        "prompt": "COVID guidelines",
        "description": "Visitor safety rules",
        "keywords": ["covid", "mask", "guidelines", "sanitization", "fever"],
        "response": "Wear mask in high-risk zones, sanitize hands. Avoid visiting if you have fever, cough, or flu symptoms."
    },
]


def get_quick_commands():
    # returns list of commands for the website buttons
    result = []
    for cmd in COMMANDS:
        result.append({
            "label": cmd["label"],
            "prompt": cmd["prompt"],
            "description": cmd["description"]
        })
    return result


def chatbot_reply(message):
    # clean the input a little
    msg = message.lower().strip()

    if msg == "":
        return {
            "reply": "Please type something or click one of the command buttons.",
            "matched_command": None
        }

    # check greetings
    for word in GREETING_KEYWORDS:
        if msg == word:
            return {"reply": WELCOME_MESSAGE, "matched_command": "Greeting"}

    # check thanks
    for word in THANKS_KEYWORDS:
        if word in msg:
            return {
                "reply": "You're welcome! Let me know if you need anything else.",
                "matched_command": "Thanks"
            }

    # check help first
    if "help" in msg or msg in ["menu", "commands", "options"]:
        labels = []
        for cmd in COMMANDS:
            labels.append(cmd["label"])
        return {
            "reply": "Available commands: " + ", ".join(labels) + ". You can type any of these or click the buttons.",
            "matched_command": "Help"
        }

    # try to match user input with commands using keywords
    best_match = None
    best_score = 0

    for cmd in COMMANDS:
        score = 0

        # check if the exact prompt was typed
        if msg == cmd["prompt"].lower():
            score += 10

        # check keywords
        for kw in cmd["keywords"]:
            if kw in msg:
                score += 2

        if score > best_score:
            best_score = score
            best_match = cmd

    if best_match is not None and best_score > 0:
        return {
            "reply": best_match["response"],
            "matched_command": best_match["label"]
        }

    # no match found
    return {"reply": FALLBACK_MESSAGE, "matched_command": None}

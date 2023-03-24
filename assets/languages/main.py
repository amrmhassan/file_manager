from googletrans import Translator
import json
import os

# Define the languages you want to translate to and their ISO codes
languages = {
    "Chinese": "zh-cn",
    "Hindi": "hi",
    "Spanish": "es",
    "Arabic": "ar",
    "Bengali": "bn",
    "Portuguese": "pt",
    "Russian": "ru",
    "Japanese": "ja",
    "Punjabi": "pa",
    "french": 'fr',
    "de": 'de',
    "id": 'id',
    "France": "FR",
    "Albania": "sq",
    "de": 'de',
    "it": 'it',
    "nl": 'nl',
    "sv": 'sv',
    "pl": 'pl',
    "nb": 'nb',
    "tr": 'tr',
    "Andorra": "AD",
    "Austria": "AT",
    "Belarus": "BY",
    "Belgium": "BE",
    "Bosnia and Herzegovina": "BA",
    "Bulgaria": "BG",
    "Croatia": "HR",
    "Cyprus": "CY",
    "Czech Republic": "CZ",
    "Denmark": "DK",
    "Estonia": "EE",
    "Finland": "FI",
    "Germany": "DE",
    "Greece": "GR",
    "Hungary": "HU",
    "Iceland": "IS",
    "Ireland": "IE",
    "Italy": "IT",
    "Kosovo": "XK",
    "Latvia": "LV",
    "Liechtenstein": "LI",
    "Lithuania": "LT",
    "Luxembourg": "LU",
    "Malta": "MT",
    "Moldova": "MD",
    "Monaco": "MC",
    "Montenegro": "ME",
    "Netherlands": "NL",
    "North Macedonia": "MK",
    "Norway": "NO",
    "Poland": "PL",
    "Portugal": "PT",
    "Romania": "RO",
    "Russia": "RU",
    "San Marino": "SM",
    "Serbia": "RS",
    "Slovakia": "SK",
    "Slovenia": "SI",
    "Spain": "ES",
    "Sweden": "SE",
    "Switzerland": "CH",
    "Ukraine": "UA",
    "United Kingdom": "GB",
    "Vatican City": "VA"

}

# Load the English JSON file
with open('en.json', 'r') as f:
    en_data = json.load(f)

# Translate the data to each language and save as a separate JSON file
for name, code in languages.items():
    try:
        if os.path.isfile(f'{code.lower()}.json'):
            print(f'language {code.lower()} exists, continue')
            continue

        print(code.lower())
        # Translate the data
        translator = Translator()
        lang_data = {key: translator.translate(
            value, dest=code.lower()).text for key, value in en_data.items()}

        # Save the data as a JSON file
        with open(f'{code.lower()}.json', 'w', encoding='utf-8') as f:
            json.dump(lang_data, f, ensure_ascii=False, indent=4)

        print(f'Saved {name} locale as {code.lower()}.json')
    except:
        print(f'{name} error')

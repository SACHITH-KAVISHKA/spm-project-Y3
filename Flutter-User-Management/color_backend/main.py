from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import base64
import io
from PIL import Image 
 

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Function to detect color at the center of the image
def detect_color(image):
    # Convert PIL Image to OpenCV format
    cv_image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
    
    hsv_frame = cv2.cvtColor(cv_image, cv2.COLOR_BGR2HSV)
    height, width, _ = hsv_frame.shape

    cx = int(width / 2)
    cy = int(height / 2)

    pixel_value = hsv_frame[cy, cx]
    hue_value = pixel_value[0]

    # Determine the color based on the hue value
    color = "Undefined"
    if hue_value < 5:
        color = "RED"
    elif hue_value < 22:
        color = "ORANGE"
    elif hue_value < 33:
        color = "YELLOW"
    elif hue_value < 78:
        color = "GREEN"
    elif hue_value < 131:
        color = "BLUE"
    else:
        color = "RED"

    return color

@app.route('/detect_color', methods=['POST'])
def detect_color_route():
    try:
        # Expecting the image in base64 format
        data = request.get_json()
        if 'image' not in data:
            return jsonify({"error": "No image provided"}), 400

        # Decode the base64 image
        image_data = base64.b64decode(data['image'])
        image = Image.open(io.BytesIO(image_data)).convert('RGB')

        # Detect color
        color = detect_color(image)

        return jsonify({"color": color}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

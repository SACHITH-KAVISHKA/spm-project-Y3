from flask import Flask, request, jsonify
from ultralytics import YOLO
import cv2
import numpy as np

app = Flask(__name__)

# Load YOLOv10 model
model = YOLO('best (11).pt')

# Define a mapping from label index to object names
LABELS = {
    0: '100 rupees',
    1: '20 rupees',
    2: 'man',
    # Add more labels as needed
}

def load_image_into_numpy_array(data):
    npimg = np.fromstring(data, np.uint8)
    image = cv2.imdecode(npimg, cv2.IMREAD_COLOR)
    return image

@app.route('/detect', methods=['POST'])
def detect_objects():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    file = request.files['file']
    image_np = load_image_into_numpy_array(file.read())

    # Perform object detection using YOLOv10
    results = model(image_np)

    # Get predictions
    detections = []
    for r in results[0].boxes:
        box = r.xyxy[0].cpu().numpy()  # Bounding box coordinates
        label_index = int(r.cls[0])    # Class label index
        score = r.conf[0]              # Confidence score
        label = LABELS.get(label_index, 'Unknown')  # Get label name
        detections.append({
            'box': box.tolist(),
            'label': label,
            'score': float(score)
        })

    return jsonify({'detections': detections})

if __name__ == "__main__":
    app.run(host='172.20.10.4', port=7000)

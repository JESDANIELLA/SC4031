from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.utils import secure_filename
import os
import datetime

import tensorflow as tf
import numpy as np
from PIL import Image

app = Flask(__name__)
CORS(app)

# Directory to save uploaded images
UPLOAD_FOLDER = './uploadimages'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)  # ✅ Ensure folder exists

interpreter = tf.lite.Interpreter(model_path="imagereg.tflite")
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Dummy prediction function (replace with your model's logic)
def prediction(filepath):
    # Simulated prediction result
    # Load the image
    img = Image.open(filepath).resize((320, 320))  # Resize if needed
    img = np.array(img).astype(np.float32)  # Ensure it's a numpy array
    img = np.expand_dims(img, axis=0)  # Add batch dimension
    
    # Set input tensor
    interpreter.set_tensor(input_details[0]['index'], img)
    # Run inference
    interpreter.invoke()
    
     # Get prediction result
    output_data = interpreter.get_tensor(output_details[0]['index'])
    predicted_class_index = np.argmax(output_data[0])
    predicted_class = ['avocado', 'apple', 'Banana', 'orange', 'cherry', 'pinenapple', 'kiwi', 'mango', 'strawberries', 'watermelon'][predicted_class_index]  # Example class labels

    return {
        "filename": os.path.basename(filepath),
        "classname": predicted_class,
        "accuracy": f"{np.max(output_data[0]) * 100:.2f}%",
        "uploadtime": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

# Main upload endpoint
@app.route('/upload', methods=['POST'])
def uploadHandler():
    if 'image' not in request.files:
        return jsonify({"error": "No image file found in request."}), 400

    imagefile = request.files['image']

    if imagefile.filename == '':
        return jsonify({"error": "Empty filename."}), 400

    filename = secure_filename(imagefile.filename)
    filepath = os.path.join(UPLOAD_FOLDER, filename)
    
    try:
        imagefile.save(filepath)
        print(f"✅ Image saved to: {filepath}")

        results = prediction(filepath)
        return jsonify(results), 200
    except Exception as e:
        print(f"❌ Error while saving or predicting: {e}")
        return jsonify({"error": f"Exception: {str(e)}"}), 500

# Optional test route
@app.route('/')
def index():
    return "Server is up and running."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)

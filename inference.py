import io
import numpy as np
from typing import Dict
from PIL import Image
import tensorflow as tf
from tensorflow.keras.preprocessing.image import img_to_array

MODEL_PATH = "/content/drive/My Drive/Суровцев, Алейников.keras"
IMG_SIZE = (256, 256)
CLASS_NAMES = ["bread", "corgi"]

def predict_from_file(filename: str, file_bytes: bytes) -> Dict:
    if not hasattr(predict_from_file, "_model"):
        predict_from_file._model = tf.keras.models.load_model(MODEL_PATH)

    model = predict_from_file._model

    image = Image.open(io.BytesIO(file_bytes)).convert("RGB")
    image = image.resize(IMG_SIZE)

    arr = img_to_array(image) / 255.0
    arr = np.expand_dims(arr, axis=0)

    prob_corgi = float(model.predict(arr, verbose=0)[0][0])
    prob_bread = 1.0 - prob_corgi

    predicted = CLASS_NAMES[1] if prob_corgi >= 0.5 else CLASS_NAMES[0]

    return {
        "filename": filename,
        "predicted_class": predicted,
        "probabilities": {
            "bread": round(prob_bread, 5),
            "corgi": round(prob_corgi, 5)
        }
    }


from google.colab import files
from inference import predict_from_file

uploaded = files.upload()

for fn, content in uploaded.items():
    result = predict_from_file(fn, content)
    print(result)

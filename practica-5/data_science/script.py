import tensorflow as tf
import numpy as np
from preprocess1 import toolkit as tk

print(f"Versión de TensorFlow: {tf.__version__}")

X = np.array([-1.0,  0.0, 1.0, 2.0, 3.0, 4.0], dtype=float)
Y = np.array([-3.0, -1.0, 1.0, 3.0, 5.0, 7.0], dtype=float)

print("Datos cargados correctamente.")

model = tf.keras.Sequential([
    tf.keras.layers.Dense(units=1, input_shape=[1])
])

model.compile(optimizer='sgd', loss='mean_squared_error')

print("Modelo construido y compilado. Iniciando entrenamiento...")

model.fit(X, Y, epochs=500, verbose=0)

print("¡Entrenamiento completado!")

numero_a_predecir = 10.0
prediccion = model.predict(np.array([numero_a_predecir]))

print(f"\nSi X = {numero_a_predecir}, el modelo predice que Y será: {prediccion[0][0]:.4f}")
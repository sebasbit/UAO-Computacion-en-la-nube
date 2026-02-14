import os
import tensorflow as tf
import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

def quick_train():
    x_train = np.array([-1.0, 0.0, 1.0, 2.0, 3.0, 4.0], dtype=float)
    y_train = np.array([-3.0, -1.0, 1.0, 3.0, 5.0, 7.0], dtype=float)

    model = tf.keras.Sequential([
        tf.keras.layers.Dense(units=1, input_shape=[1])
    ])

    model.compile(optimizer='sgd', loss='mean_squared_error')
    
    model.fit(x_train, y_train, epochs=500, verbose=0)

    test_val = 10.0
    prediction = model.predict([test_val], verbose=0)
    
    print(f"Prediccion para {test_val}: {prediction[0][0]:.4f}")

if __name__ == "__main__":
    quick_train()
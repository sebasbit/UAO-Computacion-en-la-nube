from flask import Flask
import time

app = Flask(__name__)

def fibonacci(n):
    if n <= 1:
        return n
    else:
        return fibonacci(n-1) + fibonacci(n-2)

@app.route('/stress')
def stress():
    # Calculamos el número 35 para generar un esfuerzo real de CPU
    # de aproximadamente 1-2 segundos por petición (dependiendo de tu VM)
    start_time = time.time()
    result = fibonacci(35) 
    duration = time.time() - start_time
    return f"Calculado Fibonacci(35) en {duration:.2f} segundos\n"

@app.route('/')
def health():
    return "OK"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
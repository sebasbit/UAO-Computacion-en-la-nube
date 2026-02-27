const express = require('express');
const Consul = require('consul');
const os = require('os');

const app = express();
const consul = new Consul();

const HOST = process.argv[2]; // IP
const PORT = process.argv[3] * 1; // Puerto
const SERVICE_NAME = 'microservicio';
const SERVICE_ID = `${SERVICE_NAME}-${PORT}`;
const SCHEME = 'http';

app.get('/health', (req, res) => {
    console.log(`Health check solicitado por Consul`);
    res.status(200).send("Ok");
});

app.get('/', (req, res) => {
    console.log(`Petición recibida en ${SERVICE_ID} a las ${new Date().toISOString()}`);
    res.json({
        node: os.hostname(),
        ip: HOST,
        port: PORT,
        date: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`Servicio iniciado en ${SCHEME}://${HOST}:${PORT}`);

    // Configuración del registro del servicio en Consul
    const check = {
        id: SERVICE_ID,
        name: SERVICE_NAME,
        address: HOST,
        port: PORT,
        check: {
            http: `${SCHEME}://${HOST}:${PORT}/health`,
            ttl: '5s',
            interval: '10s',
            timeout: '5s',
            deregistercriticalserviceafter: '1m'
        }
    };

    // Registrar el servicio dinámicamente
    consul.agent.service.register(check, (err) => {
        if (err) {
            console.error('Error al registrar el servicio en Consul:', err);
            throw err;
        }
        console.log(`Servicio '${SERVICE_NAME}' registrado exitosamente en Consul con el ID '${SERVICE_ID}'`);
    });
});
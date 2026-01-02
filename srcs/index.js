const express = require('express'); // Import the Express module
const app = express(); // Create an Express application
const port = 3000;

const MongoClient = require('mongodb').MongoClient; // Import the MongoDB client

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html'); // Serve the index.html file
});

app.get('/get-profile', (req, res) => {
    MongoClient.connect('mongodb://admin:password@mongodb:27017/', function (err, clinet) {
        if (err) throw err;

        var db = clinet.db('user-account');
        var query = {userod: 1};
        db.collection('users').findOne(query, function (err, result) {
            if (err) throw err;
            console.log(result.name);
            clinet.close();
            res.send(result)
        });
    });
});

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.post('/add-profile', (req, res) => {
    const { name, userod } = req.body;
    if (!name || !userod) {
        return res.status(400).send('Missing name or userod');
    }
    MongoClient.connect('mongodb://admin:password@mongodb:27017/', function (err, client) {
        if (err) return res.status(500).send('Database connection error');
        const db = client.db('user-account');
        const newUser = { name, userod };
        db.collection('users').insertOne(newUser, function (err, result) {
            client.close();
            if (err) return res.status(500).send('Error adding profile');
            res.status(201).send('Profile added');
        });
    });
});
app.listen(port, () => {
    console.log(`Express server running at http://localhost:${port}/`); // Log the server URL when it starts
});

// const http = require('http'); // Import the built-in http module
// const host = '0.0.0.0';
// const port = 3000;

// const server = http.createServer((req, res) => {
//   res.statusCode = 200;
//   res.setHeader('Content-Type', 'text/plain');
//   res.end('Hello World!\n'); // Send the response body and close the connection
// });

// server.listen(port, host, () => {
//   console.log(`Server running at http://${host}:${port}/`);
// });

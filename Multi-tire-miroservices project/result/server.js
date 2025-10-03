const express = require('express');
const async = require('async');
const { Pool } = require('pg');
const cookieParser = require('cookie-parser');
const http = require('http');
const socketIO = require('socket.io');
const path = require('path');

const app = express();
const server = http.Server(app);
const io = socketIO(server);

const port = process.env.PORT || 4000;

io.on('connection', function (socket) {
  socket.emit('message', { text: 'Welcome!' });

  socket.on('subscribe', function (data) {
    socket.join(data.channel);
  });
});

// Postgres pool
const pool = new Pool({
  connectionString: 'postgres://postgres:postgres@db/postgres'
});

// Wait for DB
async.retry(
  { times: 1000, interval: 1000 },
  function (callback) {
    pool.connect(function (err, client, done) {
      if (err) {
        console.error("Waiting for db...");
      } else {
        done(); // release immediately
      }
      callback(err);
    });
  },
  function (err) {
    if (err) {
      return console.error("Giving up connecting to db");
    }
    console.log("Connected to db");
    pollVotes();
  }
);

// Query votes periodically
function pollVotes() {
  pool.query('SELECT vote, COUNT(id) AS count FROM votes GROUP BY vote', (err, result) => {
    if (err) {
      console.error("Error performing query: " + err);
    } else {
      const votes = collectVotesFromResult(result);
      io.sockets.emit("scores", JSON.stringify(votes));
    }

    setTimeout(pollVotes, 1000);
  });
}

function collectVotesFromResult(result) {
  const votes = { a: 0, b: 0 };

  result.rows.forEach(row => {
    votes[row.vote] = parseInt(row.count, 10);
  });

  return votes;
}

// Middlewares
app.use(cookieParser());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'views')));

// Routes
app.get('/', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'views/index.html'));
});

server.listen(port, () => {
  console.log('App running on port ' + port);
});

const express = require('express'),
    bodyParser = require('body-parser'),
    methodOverride = require('method-override'),
    sanitizer = require('sanitizer'),
    fs = require('fs'),
    path = require('path'),
    app = express(),
    port = 8000

// Setup log file stream
const logDir = '/app/logs';
if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
}
const logStream = fs.createWriteStream(path.join(logDir, 'server.log'), { flags: 'a' });

// Overwrite console.log and console.error
console.log = (...args) => {
    logStream.write(`[LOG] ${new Date().toISOString()} - ${args.join(' ')}\n`);
};
console.error = (...args) => {
    logStream.write(`[ERROR] ${new Date().toISOString()} - ${args.join(' ')}\n`);
};

app.use(bodyParser.urlencoded({
    extended: false
}));

app.use(methodOverride(function (req, res) {
    if (req.body && typeof req.body === 'object' && '_method' in req.body) {
        let method = req.body._method;
        delete req.body._method;
        return method
    }
}));

let todolist = [];

app.get('/todo', function (req, res) {
        console.log('GET /todo');
        res.render('todo.ejs', {
            todolist,
            clickHandler: "func1();"
        });
    })

    .post('/todo/add/', function (req, res) {
        let newTodo = sanitizer.escape(req.body.newtodo);
        if (req.body.newtodo != '') {
            todolist.push(newTodo);
            console.log(`Added new todo: ${newTodo}`);
        }
        res.redirect('/todo');
    })

    .get('/todo/delete/:id', function (req, res) {
        if (req.params.id != '') {
            const deleted = todolist[req.params.id];
            todolist.splice(req.params.id, 1);
            console.log(`Deleted todo: ${deleted}`);
        }
        res.redirect('/todo');
    })

    .get('/todo/:id', function (req, res) {
        let todoIdx = req.params.id;
        let todo = todolist[todoIdx];

        if (todo) {
            console.log(`Edit request for todo[${todoIdx}]: ${todo}`);
            res.render('edititem.ejs', {
                todoIdx,
                todo,
                clickHandler: "func1();"
            });
        } else {
            res.redirect('/todo');
        }
    })

    .put('/todo/edit/:id', function (req, res) {
        let todoIdx = req.params.id;
        let editTodo = sanitizer.escape(req.body.editTodo);
        if (todoIdx != '' && editTodo != '') {
            console.log(`Updated todo[${todoIdx}] to: ${editTodo}`);
            todolist[todoIdx] = editTodo;
        }
        res.redirect('/todo');
    })

    .use(function (req, res, next) {
        console.log(`Redirected unknown route: ${req.originalUrl}`);
        res.redirect('/todo');
    })

    .listen(port, function () {
        console.log(`Todolist running on http://0.0.0.0:${port}`);
    });

module.exports = app;

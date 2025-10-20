class History {
    constructor () {

    }

    load(file = "./hist.json") {
        const fs = require("fs");
        const path = require("path");

        const filePath = path.join(file);
        const data = fs.readFileSync(filePath, "utf8");
        this.data = JSON.parse(data);
        this.lastProblem = this.data.lastProblem;
    }

    getLastProblem() {
        return this.lastProblem;
    }

    setLastProblem(problem) {
        this.lastProblem = problem;
        this.data.lastProblem = this.lastProblem;
    }

    getLastProblemFileUrl() {
        return __dirname + "/problems/euler" + this.lastProblem + ".js";
    }

    getProblemUrl() {
        return "https://projecteuler.net/problem=" + this.lastProblem;
    }

    getLastProblemCursorOpenCommand() {
        return `open -a "Cursor.app" ${this.getLastProblemFileUrl()}`;
    }

    save(file = "./hist.json") {
        const fs = require("fs");
        const path = require("path");

        const filePath = path.join(file);
        this.data.lastProblem = this.lastProblem;
        fs.writeFileSync(filePath, JSON.stringify(this.data, null, 2));
    }
}

const history = new History();

history.load();

const { program } = require("commander");

program.option("-p, --problem <number>", "Problem number");

program.parse(process.argv);

const problem = program.opts().problem;

if (problem) {
    history.setLastProblem(problem);
    history.save();
}

const { spawn } = require('node:child_process');

// create javascript file if not exists, add a function template, and nothing else
const fs = require("fs");
const path = require("path");

const filePath = path.join(history.getLastProblemFileUrl());

if (!fs.existsSync(filePath)) {
    fs.writeFileSync(filePath, `function solution() {
    return 0;
}

console.log(solution());
`);
}

const open = spawn('open', ['-a', 'Cursor.app', history.getLastProblemFileUrl()]);
const chrome = spawn('open', ['-a', 'Google Chrome.app', history.getProblemUrl()]);
open.stdout.on('data', (data) => {
  console.log(`stdout: ${data}`);
});

open.stderr.on('data', (data) => {
  console.error(`stderr: ${data}`);
});

open.on('close', (code) => {
  console.log(`child process exited with code ${code}`);
});

chrome.stdout.on('data', (data) => {
    console.log(`stdout: ${data}`);
});

chrome.stderr.on('data', (data) => {
    console.error(`stderr: ${data}`);
});

chrome.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
});
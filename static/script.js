// script.js - Frontend chatbot logic
// Handles opening/closing chat, sending messages, and loading command buttons

var chatOpen = false;
var introLoaded = false;

function openChat() {
    var panel = document.getElementById("chatPanel");
    panel.classList.add("open");
    chatOpen = true;

    // load welcome message and command buttons only once
    if (!introLoaded) {
        loadCommands();
        introLoaded = true;
    }

    // scroll to bottom
    scrollToBottom();
}

function closeChat() {
    var panel = document.getElementById("chatPanel");
    panel.classList.remove("open");
    chatOpen = false;
}

function scrollToBottom() {
    var messages = document.getElementById("chatMessages");
    messages.scrollTop = messages.scrollHeight;
}

function addMessage(text, sender) {
    var messages = document.getElementById("chatMessages");
    var div = document.createElement("div");
    div.className = "msg " + sender;
    div.textContent = text;
    messages.appendChild(div);
    scrollToBottom();
}

function sendMessage(customMsg) {
    var input = document.getElementById("userInput");
    var msg = customMsg || input.value.trim();

    if (msg === "") return;

    // show user's message
    addMessage(msg, "user");
    input.value = "";

    // send to server
    fetch("/api/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: msg })
    })
    .then(function(res) {
        return res.json();
    })
    .then(function(data) {
        addMessage(data.reply, "bot");
    })
    .catch(function(err) {
        addMessage("Sorry, something went wrong. Please try again.", "bot");
    });
}

function checkEnter(event) {
    if (event.key === "Enter") {
        sendMessage();
    }
}

function loadCommands() {
    fetch("/api/commands")
    .then(function(res) {
        return res.json();
    })
    .then(function(data) {
        // show welcome message from bot
        addMessage(data.welcome, "bot");

        // create command buttons
        var cmdArea = document.getElementById("chatCommands");
        cmdArea.innerHTML = "";

        for (var i = 0; i < data.commands.length; i++) {
            var cmd = data.commands[i];
            var btn = document.createElement("button");
            btn.className = "cmd-btn";
            btn.textContent = cmd.label;
            btn.title = cmd.description;

            // use closure to capture correct prompt value
            (function(prompt) {
                btn.onclick = function() {
                    sendMessage(prompt);
                };
            })(cmd.prompt);

            cmdArea.appendChild(btn);
        }
    })
    .catch(function(err) {
        addMessage("Could not load commands. Is the server running?", "bot");
    });
}

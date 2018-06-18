var button = document.querySelector("button");

button.addEventListener("click", changeColor);


function changeColor() {
    self.location = "game"
}

// var myHeaders =  new Headers();
// myHeaders.append("apiKey", "27a9bec8-aa92-4a3f-800f-7618637d14a6");

// var httpRequest = new XMLHttpRequest();


var createGameFormElement = document.getElementById("create_game");
createGameFormElement.onsubmit = function (event) {
    var formData = new FormData(createGameFormElement);

    var body = {};
    var headers = {};

    for (var pair of formData.entries()) {

        var key = pair[0];
        var value = pair[1];

        if (key.toLowerCase() == "apikey") {
            headers[key] = value
            continue;
        }

        body[key] = value;
    }

    var json = JSON.stringify(body);

    var request = new XMLHttpRequest();
    request.open("POST", createGameFormElement.getAttribute("action"), true);

    Object.keys(headers).forEach(function (key) {
        request.setRequestHeader(key, headers[key])
    });

    request.send(json);

    request.onload = function (event) {
        var output = document.getElementById("save_output")
        if (request.status == 200) {
            output.innerHTML = "Saved!" + ": " + request.response;
        } else {
            output.innerHTML = "Error " + request.status + ": " + request.statusText + ", " + request.response + " <br \/>";
        }
    };

    event.preventDefault();
}

var deleteGameFormElement = document.getElementById("delete_game");
deleteGameFormElement.onsubmit = function (event) {
    var formData = new FormData(deleteGameFormElement);

    // Set the body into the url
    var body = {};
    var headers = {};

    for (var pair of formData.entries()) {

        var key = pair[0];
        var value = pair[1];

        if (key.toLowerCase() == "apikey") {
            headers[key] = value
            continue;
        }

        body[key] = value;
    }

    var request = new XMLHttpRequest();
    var url = deleteGameFormElement.getAttribute("action") + "/" + body["name"];
    console.log(url);
    request.open("DELETE", url, true);

    Object.keys(headers).forEach(function (key) {
        request.setRequestHeader(key, headers[key])
    });

    request.send();

    request.onload = function (event) {
        var output = document.getElementById("save_output2")
        if (request.status == 200) {
            output.innerHTML = request.response;
        } else {
            output.innerHTML = "Error " + request.status + ": " + request.statusText + ", " + request.response + " <br \/>";
        }
    };

    event.preventDefault();
}

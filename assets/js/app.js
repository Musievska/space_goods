// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Hooks
let Hooks = {};
Hooks.LoadImage = {
    mounted() {
        this.loadImage();
        console.log("LoadImage mounted");

    },
    updated() {
        console.log("LoadImage updated");

        this.loadImage();
    },
    loadImage() {
        let img = this.el;
        let actualImage = new Image();
        actualImage.src = img.getAttribute('data-src');

        actualImage.onload = function() {
            img.src = this.src;
        };

        actualImage.onerror = function() {
            console.log('Error loading: ' + this.src);
            img.src = '/images/no_image.jpeg';
        };
    }
}

let liveSocket = new LiveSocket("/live", Socket, {
    params: {_csrf_token: csrfToken},
    hooks: Hooks
});
// Show progress bar on live navigation and form submits. Only displays if still
// loading after 120 msec
// Jose Valim top bar implementation https://fly.io/phoenix-files/make-your-liveview-feel-faster/
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})

let topBarScheduled = undefined;
window.addEventListener("phx:page-loading-start", () => {
  if(!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 120);
  };
});
window.addEventListener("phx:page-loading-stop", () => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

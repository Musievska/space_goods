// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import { addToCart, removeFromCart, getCart, clearCart, increaseQuantity, decreaseQuantity } from "./cart"
import Uploaders from "./uploaders"

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

Hooks.AddToCart = {
    mounted() {
        this.el.addEventListener('click', () => {
            const product = {
                id: this.el.getAttribute('data-id'),
                name: this.el.getAttribute('data-name'),
                price: parseFloat(this.el.getAttribute('data-price'))
            };
            addToCart(product);
        });
    }
};
// Hooks.AddToCart = {
//     mounted() {
//         this.el.addEventListener('click', () => {
//             const product = {
//                 id: this.el.getAttribute('data-id'),
//                 name: this.el.getAttribute('data-name'),
//                 price: parseFloat(this.el.getAttribute('data-price'))
//             };
//             addToCart(product);
//             this.pushEvent("add_to_cart", product);
//         });
//     }
// };


let previousCartItems = []; //  pushCartToServer method

Hooks.CartPage = {
    mounted() {
        this.pushCartToServer();

        this.handleEvent("cart_updated", ({ items }) => {
            console.log('Received updated cart items:', items);

            // Update local storage and UI with new cart items.
            try {
                localStorage.setItem('cart', JSON.stringify(items));
                // ... update UI ...
            } catch (e) {
                console.error('Failed to update local storage: ', e);
            }
        });
    },
    updated() {
        this.pushCartToServer();
    },
    pushCartToServer() {
        let cartItems;
        try {
            cartItems = JSON.parse(localStorage.getItem('cart') || '[]');
        } catch (e) {
            console.error('Failed to parse cart data from local storage: ', e);
            cartItems = [];
        }
        if (JSON.stringify(cartItems) !== JSON.stringify(previousCartItems)) {
            console.log('Pushing cart to server, called:', cartItems);  // Moved line
            this.pushEvent('load_cart', { items: cartItems });
            previousCartItems = cartItems;  // Update previous cart items
        }
    }
};



Hooks.UpdateQuantity = {
    mounted() {
        this.el.addEventListener('click', (event) => {
            event.stopPropagation();
        event.preventDefault();
            const actionButton = event.target.closest('button[data-action]');
            const actionDiv = event.target.closest('div[data-id]');
            if (actionButton && actionDiv) {
                const action = actionButton.getAttribute('data-action');
                const id = actionDiv.getAttribute('data-id');
                if (action && id) {
                    this.pushEvent(action, { id: id });

                    // Update local storage
                    if(action === 'increase_quantity') {
                        increaseQuantity(id);
                    } else if(action === 'decrease_quantity') {
                        decreaseQuantity(id);
                    }

                } else {
                    console.error('Missing action or id', { action, id });
                }
            }
        });
    }
};


Hooks.RemoveFromCart = {
    mounted() {
        this.el.addEventListener('click', () => {
            const productId = this.el.getAttribute('data-id');
            console.log('Product ID:', productId);
            console.log('data-id');  // Existing log statement


            if (productId) {
                removeFromCart(productId);
                this.pushEvent('remove_item', { id: productId });

            } else {
                console.error('Missing productId');
            }
        });
    }
};

Hooks.FinishPurchase = {
    mounted() {
        this.el.addEventListener('click', () => {
            clearCart();  // Clear the cart on the client-side
            this.pushEvent('clear_cart', {});  // Notify the server
        });
    }
};


let liveSocket = new LiveSocket("/live", Socket, {
    params: {_csrf_token: csrfToken},
    hooks: Hooks,
    uploaders: Uploaders

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
liveSocket.enableDebug();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
console.log(liveSocket.activeElement);  // Logs the DOM element of the active LiveView
// window.myHook = Hooks.CartPage;


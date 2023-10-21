// Retrieve the current cart from Local Storage.
 const getCartFromStorage = () => {
    console.log('Getting cart from storage...');
    const cart = localStorage.getItem('cart');
    console.log('Current cart:', cart);
    return cart ? JSON.parse(cart) : [];
};

// Save the cart to Local Storage.
 const saveCartToStorage = (cart) => {
    console.log('Saving cart to storage:', cart);
    localStorage.setItem('cart', JSON.stringify(cart));
};

// Add a product to the cart.
 const addToCart = (product) => {
    console.log('Adding product to cart:', product);
    const cart = getCartFromStorage();
    const existingItem = cart.find(cartItem => cartItem.id === product.id);
    if (existingItem) {
        existingItem.quantity++;
    } else {
        cart.push({ ...product, quantity: 1 });
    }
    saveCartToStorage(cart);
};

// Remove an item from the cart.
 const removeFromCart = (productId) => {
    console.log('Removing product from cart:', productId);
    const cart = getCartFromStorage();
    const updatedCart = cart.filter(cartItem => cartItem.id !== productId);
    saveCartToStorage(updatedCart);
};

// Get the current state of the cart.
 const getCart = () => {
    console.log('Getting current state of cart...');
    return getCartFromStorage();
};

// Clear the cart.
 const clearCart = () => {
    console.log('Clearing cart...');
    localStorage.removeItem('cart');
};
  
window.handleAddToCart = function(productId, productName, productPrice) {
    const product = {id: productId, name: productName, price: productPrice};
    addToCart(product);
};

const increaseQuantity = (productId) => {
    const cart = JSON.parse(localStorage.getItem('cart') || '[]');
    const item = cart.find(cartItem => cartItem.id === productId);
    if (item) {
        item.quantity++;
        localStorage.setItem('cart', JSON.stringify(cart));
        renderCartItems();
    }
};

const decreaseQuantity = (productId) => {
    // similar to increaseQuantity, but decrement item.quantity instead
};

// const removeFromCart = (productId) => {
//     // similar to above, but filter out the item with the given productId
// };


export { addToCart, removeFromCart, getCart, clearCart, saveCartToStorage };

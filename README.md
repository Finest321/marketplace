# 🛒 Marketplace App

Welcome to my **Marketplace** app! This is a Flutter-based mobile application built to allow buyers to browse and purchase products from multiple sellers. Sellers can upload and manage their products, while buyers can add items to a cart, place orders, and track their order history. The app uses **Supabase** for authentication, database, and storage, providing a full backend solution.

## 📱 Features

### For Buyers
* **Browse Products**: Explore products from multiple sellers.
* **Search Products**: Find items quickly using the search bar.
* **Add to Cart**: Select products and add them to your cart.
* **Checkout & Order**: Place orders for products in your cart.
* **Order History**: Track previous orders with status updates.
* **Pull-to-Refresh**: Refresh product and order lists easily.

### For Sellers
* **Upload Products**: Add products with images, title, price, and category.
* **Manage Inventory**: Remove or update product details.
* **View Greeting**: Personalized greeting with seller’s name.
* **Track Orders**: Monitor incoming orders and statuses.

### General
* **Authentication**: Secure login and signup using Supabase.
* **Settings**: Toggle between light and dark mode.
* **Responsive UI**: Works smoothly on Android and iOS devices.

## 🔧 Tech Stack

* **Flutter**: Cross-platform mobile development framework.
* **Dart**: Programming language for Flutter.
* **Supabase**: Backend services including Auth, Database, and Storage.
* **Image Picker**: For selecting product images.
* **State Management**: Managed with `setState` for simplicity.

## 🧑‍💻 Usage

Here’s how to get started with the app:

1. **Browse Products**: Open the app to see the latest products from all sellers.
2. **Search**: Use the search bar to quickly find a product by name.
3. **Add to Cart**: Tap "Add to Cart" to save products for checkout.
4. **Checkout**: Go to your cart, review items, and place an order.
5. **Order History**: View your past orders and check their status.
6. **Seller Dashboard**: Sellers can upload and manage products.
7. **Settings**: Toggle light/dark mode for personalized viewing.

## 📁 Project Structure

The project is organized in the following structure:


## 📁 Project Structure
```
lib/
├── screens/
│   ├── buyer_home_screen.dart        # Main screen for buyers
│   ├── cart_screen.dart              # Shopping cart screen
│   ├── order_screen.dart             # Checkout screen
│   ├── order_history_screen.dart     # Past orders
│   └── settings_screen.dart          # App settings (dark/light mode)
├── widgets/
│   ├── product_card.dart             # Reusable product card component
│   └── order_item_card.dart          # Reusable order item component
└── main.dart                         # Entry point of the application
```
## 🧑‍💻 Contributing

Contributions are welcome! You can submit pull requests, report issues, or suggest new features.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push your branch (`git push origin feature-name`).
5. Open a pull request.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 📚 Helpful Resources

Here are some helpful resources that guided the development of this app:

* [Flutter Documentation](https://flutter.dev/docs)
* [Supabase for Flutter](https://supabase.com/docs)
* [Image Picker Package](https://pub.dev/packages/image_picker)
* [Supabase Flutter SDK](https://pub.dev/packages/supabase_flutter)

## 📬 Contact

Feel free to reach out if you have questions, feedback, or ideas for collaboration:

* **Email**: [unwanaudofa49@gmail.com](mailto:unwanaudofa49@gmail.com)  
* **GitHub**: [Finest321](https://github.com/Finest321)  

I'm open to job opportunities and collaborations. Let’s connect!

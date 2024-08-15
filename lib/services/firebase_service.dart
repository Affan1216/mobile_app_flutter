import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbap_part2_ecomarket/screens/product.dart';
import 'package:path/path.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '852131848576-l5r1avqe8sa9580sgd2kd9d1jk7up8id.apps.googleusercontent.com',
  );
  Future<String?> addProductPhoto(File productPhoto) {
    return FirebaseStorage.instance
        .ref()
        .child('${DateTime.now()}_${basename(productPhoto.path)}')
        .putFile(productPhoto)
        .then((task) {
      return task.ref.getDownloadURL().then((imageUrl) {
        return imageUrl;
      });
    });
  }

  Future<void> addProduct(
      String name,
      List<String> imageUrls,
      String description,
      int quantity,
      double price,
      String location,
      DateTime createdDate,
      String category) {
    return FirebaseFirestore.instance.collection('products').add({
      'email': getCurrentUser()!.email,
      'name': name,
      'imageUrls': imageUrls,
      'description': description,
      'quantity': quantity,
      'price': price,
      'location': location,
      'createdDate': createdDate,
      'category': category,
    });
  }

  Stream<List<Product>> getproducts() {
    return FirebaseFirestore.instance.collection('products')
    .where('email', isEqualTo: getCurrentUser()!.email)
    .snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }
  Stream<List<Product>> getProducts() {
    return FirebaseFirestore.instance.collection('products')
    .snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Future<void> updateProduct(
    String id,
    String name,
    List<String> imageUrls,
    String description,
    int quantity,
    double price,
    String location,
    DateTime createdDate,
    String category,
  ) {
    return FirebaseFirestore.instance.collection('products').doc(id).update({
      'name': name,
      'imageUrls': imageUrls,
      'description': description,
      'quantity': quantity,
      'price': price,
      'location': location,
      'createdDate': createdDate,
      'category': category,
    });
  }

  Future<void> signInWithGoogle() async {
  try {
    await _googleSignIn.signOut();

    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;
    
  } catch (e) {
    print(e.toString());
  }
}

  Future<void> deleteProduct(String id) {
    return FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  Future<UserCredential> register(email, password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login(email, password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> forgotPassword(email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Stream<User?> getAuthUser() {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<void> logOut() {
    return FirebaseAuth.instance.signOut();
  }
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
}
}

 

  


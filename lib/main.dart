import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/selection': (context) => const SelectionPage(),
        '/shop': (context) => CompanyDetailsPage(userType: "Shop"),
        '/ngo': (context) => CompanyDetailsPage(userType: "NGO"),
        '/shopPage': (context) => const ShopPage(),
        '/ngoPage': (context) => const NgoPage(),
      },
    );
  }
}

class UserCredentials {
  static String? email;
  static String? password;
  static String? companyName;
  static List<Map<String, String>> donatedProducts = [];
  static List<Map<String, String>> reservedProducts = [];
  static VoidCallback? onReservedChanged;

  static void addDonatedProducts(List<Map<String, String>> newProducts) {
    final tempMap = <String, int>{};
    
    for (final product in donatedProducts) {
      final name = product['name'] ?? '';
      final quantity = int.tryParse(product['quantity'] ?? '0') ?? 0;
      if (name.isNotEmpty) tempMap[name] = quantity;
    }
    
    for (final product in newProducts) {
      final name = product['name'] ?? '';
      final quantity = int.tryParse(product['quantity'] ?? '0') ?? 0;
      tempMap[name] = (tempMap[name] ?? 0) + quantity;
    }
    
    donatedProducts = tempMap.entries.map((e) => {
      'name': e.key,
      'quantity': e.value.toString()
    }).toList();
  }

  static void addReservation(Map<String, String> reservation) {
    reservedProducts.add(reservation);
    onReservedChanged?.call();
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _checkIfSignedUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_emailController.text == UserCredentials.email &&
          _passwordController.text == UserCredentials.password) {
        UserCredentials.donatedProducts.clear();
        UserCredentials.reservedProducts.clear();
        Navigator.pushNamed(context, '/selection');
      } else {
        _showErrorDialog('Incorrect email or password.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Numele aplicației
                    Text(
                      'FoodShare',
                      style: TextStyle(
                        fontSize: 36,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Titlul paginii
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your email!'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your password!'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _checkIfSignedUp,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text("Don't have an account? Sign up here!"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      UserCredentials.email = _emailController.text;
      UserCredentials.password = _passwordController.text;
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Numele aplicației
                    Text(
                      'FoodShare',
                      style: TextStyle(
                        fontSize: 36,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Titlul paginii
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your email!'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your password!'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text("Already have an account? Login here!"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  void initState() {
    super.initState();
    UserCredentials.onReservedChanged = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selection Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add the buttons container here
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/shop'),
                    child: const Text("I am a Shop"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/ngo'),
                    child: const Text("I am an NGO"),
                  ),
                ],
              ),
            ),
            // Reserved Products Container
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reserved Products:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: UserCredentials.reservedProducts.isNotEmpty
                        ? ListView.builder(
                            itemCount: UserCredentials.reservedProducts.length,
                            itemBuilder: (context, index) {
                              final product = UserCredentials.reservedProducts[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${product['name']} - ${product['quantity']} kg',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      'Reserved by: ${product['ngo']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No reserved products',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            // Available Products Container
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Products:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (UserCredentials.donatedProducts.isNotEmpty)
                    Column(
                      children: UserCredentials.donatedProducts.map((product) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${product['name']} - ${product['quantity']} kg',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No available products',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyDetailsPage extends StatefulWidget {
  final String userType;

  const CompanyDetailsPage({super.key, required this.userType});

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
    final _companyNameController = TextEditingController();
  final _uniqueIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      UserCredentials.companyName = _companyNameController.text;
      Navigator.pushNamed(
        context,
        widget.userType == "Shop" ? '/shopPage' : '/ngoPage',
      );
    }
  }

  String? _validateUniqueId(String? value) {
    if (value == null || value.isEmpty) return 'Enter unique ID code!';
    if (!RegExp(r'^\d{8}$').hasMatch(value)) return 'Must be 8 digits!';
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) return 'Enter address!';
    if (!RegExp(r'^[A-Za-z\s]+ \d+$').hasMatch(value)) {
      return 'Invalid format!\nExample: Main Street 123';
    }
    return null;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _uniqueIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.userType} Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _companyNameController,
                label: 'Organization Name',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required field';
                  if (widget.userType == "Shop" && 
                      !RegExp(r'\b(LLC|INC|LTD)\b').hasMatch(value)) {
                    return 'Must contain LLC, INC, or LTD';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _uniqueIdController,
                label: 'Unique ID Code',
                validator: _validateUniqueId,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _addressController,
                label: 'Street Address',
                validator: _validateAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final List<Map<String, String>> _products = [];

  void _addProduct(String name, String quantity) {
    setState(() {
      final existingIndex = _products.indexWhere((p) => p['name'] == name);
      if (existingIndex != -1) {
        final currentQty = int.parse(_products[existingIndex]['quantity']!);
        _products[existingIndex]['quantity'] = (currentQty + int.parse(quantity)).toString();
      } else {
        _products.add({'name': name, 'quantity': quantity});
      }
    });
  }

  void _submitDonation() {
    if (_products.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Donation'),
        content: Text('Confirm donation of:\n${_products.map((p) => '${p['name']} - ${p['quantity']} kg').join('\n')}'),
        actions: [
          TextButton(
            onPressed: () {
              UserCredentials.addDonatedProducts(_products);
              Navigator.pushNamedAndRemoveUntil(context, '/selection', (route) => false);
              _products.clear();
            },
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductEntryPage(category: text)),
        );
        if (result != null) _addProduct(result['name'], result['quantity']);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade700,
              offset: const Offset(4, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${UserCredentials.companyName ?? "Shop"} Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Welcome, ${UserCredentials.companyName ?? "Shop"}! What would you like to donate today?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Column
                  Expanded(
                    child: Column(
                      children: [
                        _buildCategoryButton('Vegetables'),
                        _buildCategoryButton('Fruits'),
                        _buildCategoryButton('Dairy'),
                        _buildCategoryButton('Bakery'),
                        _buildCategoryButton('Beverages'),
                        _buildCategoryButton('Other'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Donation List
                  Expanded(
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        const Text(
          'Products to Donate',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _products.isEmpty
              ? const Center(
                  child: Text(
                    'No products added yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _products.map((product) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded( // Aici este corectarea
                              child: Text(
                                '${product['name']} - ${product['quantity']} kg',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _products.remove(product)),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
        if (_products.isNotEmpty) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitDonation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Submit Donation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    ),
  ),
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductEntryPage extends StatefulWidget {
  final String category;

  const ProductEntryPage({super.key, required this.category});

  @override
  _ProductEntryPageState createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  void _submit() {
    if (_nameController.text.isEmpty || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    Navigator.pop(context, {
      'name': _nameController.text,
      'quantity': _quantityController.text,
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add ${widget.category}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              label: 'Product Name',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _quantityController,
              label: 'Quantity (kg)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class NgoPage extends StatefulWidget {
  const NgoPage({super.key});

  @override
  _NgoPageState createState() => _NgoPageState();
}

class _NgoPageState extends State<NgoPage> {
  void _showReservationDialog(Map<String, String> product) {
    final quantityController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reserve ${product['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available: ${product['quantity']} kg'),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity (kg)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _handleReservation(product, quantityController.text),
            child: const Text('Reserve'),
          ),
        ],
      ),
    );
  }

  void _handleReservation(Map<String, String> product, String quantityStr) {
    final quantity = int.tryParse(quantityStr) ?? 0;
    final available = int.tryParse(product['quantity'] ?? '0') ?? 0;

    if (quantity <= 0 || quantity > available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid quantity!')),
      );
      return;
    }

    final index = UserCredentials.donatedProducts.indexWhere((p) => p['name'] == product['name']);
    if (index != -1) {
      final newQuantity = available - quantity;
      if (newQuantity > 0) {
        UserCredentials.donatedProducts[index]['quantity'] = newQuantity.toString();
      } else {
        UserCredentials.donatedProducts.removeAt(index);
      }
    }

    UserCredentials.addReservation({
      'name': product['name']!,
      'quantity': quantity.toString(),
      'ngo': UserCredentials.companyName ?? 'NGO',
    });

    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UserCredentials.companyName ?? 'NGO Dashboard'),
      ),
      body: Padding(
                padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Welcome, ${UserCredentials.companyName ?? "NGO Representative"}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Available Products:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: UserCredentials.donatedProducts.isNotEmpty
                          ? ListView.builder(
                              itemCount: UserCredentials.donatedProducts.length,
                              itemBuilder: (context, index) {
                                final product = UserCredentials.donatedProducts[index];
                                return GestureDetector(
                                  onTap: () => _showReservationDialog(product),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'] ?? 'Unnamed Product',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            Text(
                                              'Available: ${product['quantity']} kg',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.blueAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No products available for reservation',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
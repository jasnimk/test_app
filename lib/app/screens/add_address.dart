// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:test_ecommerce_app/app/controllers/address_controller.dart';
// import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
// import 'package:test_ecommerce_app/app/widgets/text_form.dart';

// class AddAddressView extends StatefulWidget {
//   final Map<String, dynamic>? addressData;
//   final bool isEditing;

//   const AddAddressView({
//     Key? key,
//     this.addressData,
//     this.isEditing = false,
//   }) : super(key: key);

//   @override
//   _AddAddressViewState createState() => _AddAddressViewState();
// }

// class _AddAddressViewState extends State<AddAddressView> {
//   final AddressController addressController = Get.find<AddressController>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _districtController = TextEditingController();
//   final TextEditingController _localityController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditing && widget.addressData != null) {
//       _nameController.text = widget.addressData!['name'] ?? '';
//       _contactController.text = widget.addressData!['phone'] ?? '';
//       _pincodeController.text = widget.addressData!['pincode'] ?? '';
//       _stateController.text = widget.addressData!['state'] ?? '';
//       _cityController.text = widget.addressData!['city'] ?? '';
//       _districtController.text = widget.addressData!['district'] ?? '';
//       _addressController.text = widget.addressData!['houseName'] ?? '';
//       _localityController.text = widget.addressData!['locality'] ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _contactController.dispose();
//     _pincodeController.dispose();
//     _stateController.dispose();
//     _cityController.dispose();
//     _districtController.dispose();
//     _addressController.dispose();
//     _localityController.dispose();
//     super.dispose();
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String labelText,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     return CustomTextFormField(
//       controller: controller,
//       label: labelText,
//       keyboardType: keyboardType,
//       validator: validator!,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isEditing ? 'Edit Address' : 'Add New Address'),
//       ),
//       body: Obx(
//         () => Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTextFormField(
//                         controller: _nameController,
//                         labelText: 'Name',
//                         validator: (value) => value?.isEmpty ?? true
//                             ? 'Please enter your name'
//                             : null,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextFormField(
//                         controller: _contactController,
//                         labelText: 'Mobile Number',
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value?.isEmpty ?? true) {
//                             return 'Please enter a contact number';
//                           }
//                           if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
//                             return 'Please enter a valid 10-digit mobile number';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildTextFormField(
//                               controller: _pincodeController,
//                               labelText: 'Pincode',
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value?.isEmpty ?? true) {
//                                   return 'Please enter a pincode';
//                                 }
//                                 if (!RegExp(r'^\d{6}$').hasMatch(value!)) {
//                                   return 'Please enter a valid 6-digit pincode';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: _buildTextFormField(
//                               controller: _stateController,
//                               labelText: 'State',
//                               validator: (value) => value?.isEmpty ?? true
//                                   ? 'Please enter state'
//                                   : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildTextFormField(
//                               controller: _cityController,
//                               labelText: 'City',
//                               validator: (value) => value?.isEmpty ?? true
//                                   ? 'Please enter city'
//                                   : null,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: CustomButton(
//                               text: 'Use My Location',
//                               onPressed: () {
//                                 // Implement location functionality
//                               },
//                               padding: const EdgeInsets.symmetric(vertical: 13),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextFormField(
//                         controller: _districtController,
//                         labelText: 'District',
//                         validator: (value) => value?.isEmpty ?? true
//                             ? 'Please enter district'
//                             : null,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextFormField(
//                         controller: _addressController,
//                         labelText: 'House Name',
//                         validator: (value) => value?.isEmpty ?? true
//                             ? 'Please enter house name'
//                             : null,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextFormField(
//                         controller: _localityController,
//                         labelText: 'Locality Name',
//                         validator: (value) => value?.isEmpty ?? true
//                             ? 'Please enter locality name'
//                             : null,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomButton(
//                         text: widget.isEditing
//                             ? 'Update Address'
//                             : 'Save Address',
//                         isLoading: addressController.isLoading.value,
//                         onPressed: () {
//                           if (_formKey.currentState?.validate() ?? false) {
//                             final addressData = {
//                               'name': _nameController.text,
//                               'phone': _contactController.text,
//                               'pincode': _pincodeController.text,
//                               'state': _stateController.text,
//                               'city': _cityController.text,
//                               'district': _districtController.text,
//                               'houseName': _addressController.text,
//                               'locality': _localityController.text,
//                             };

//                             final String userId = _auth.currentUser!.uid;

//                             if (widget.isEditing &&
//                                 widget.addressData != null) {
//                               addressController.updateAddress(
//                                 userId,
//                                 widget.addressData!['id'],
//                                 addressData,
//                               );
//                             } else {
//                               addressController.addAddress(userId, addressData);
//                             }
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             if (addressController.isLoading.value)
//               const Center(
//                 child: CircularProgressIndicator(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_ecommerce_app/app/controllers/address_controller.dart';
import 'package:test_ecommerce_app/app/widgets/custom_button.dart';
import 'package:test_ecommerce_app/app/widgets/text_form.dart';
import 'package:test_ecommerce_app/app/widgets/text_style.dart';

class AddAddressView extends StatefulWidget {
  final Map<String, dynamic>? addressData;
  final bool isEditing;

  const AddAddressView({
    Key? key,
    this.addressData,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _AddAddressViewState createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final AddressController addressController = Get.find<AddressController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.addressData != null) {
      _nameController.text = widget.addressData!['name'] ?? '';
      _contactController.text = widget.addressData!['phone'] ?? '';
      _pincodeController.text = widget.addressData!['pincode'] ?? '';
      _stateController.text = widget.addressData!['state'] ?? '';
      _cityController.text = widget.addressData!['city'] ?? '';
      _districtController.text = widget.addressData!['district'] ?? '';
      _addressController.text = widget.addressData!['houseName'] ?? '';
      _localityController.text = widget.addressData!['locality'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _localityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF15384E), Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.isEditing ? 'Edit Address' : 'Add New Address',
            style: AppTextStyles.montserratBold,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(
          () => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: _nameController,
                          label: 'Name',
                          validator: (value) => GetUtils.isNullOrBlank(value)!
                              ? 'Please enter name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _contactController,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (GetUtils.isNullOrBlank(value)!) {
                              return 'Please enter a contact number';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _pincodeController,
                                label: 'Pincode',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (GetUtils.isNullOrBlank(value)!) {
                                    return 'Please enter a pincode';
                                  }
                                  if (!RegExp(r'^\d{6}$').hasMatch(value!)) {
                                    return 'Please enter a valid 6-digit pincode';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _stateController,
                                label: 'State',
                                validator: (value) =>
                                    GetUtils.isNullOrBlank(value)!
                                        ? 'Please enter state'
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _cityController,
                                label: 'City',
                                validator: (value) =>
                                    GetUtils.isNullOrBlank(value)!
                                        ? 'Please enter city'
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                text: 'Use My Location',
                                onPressed: () {
                                  // Implement location functionality
                                },
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _districtController,
                          label: 'District',
                          validator: (value) => GetUtils.isNullOrBlank(value)!
                              ? 'Please enter district'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _addressController,
                          label: 'House Name',
                          validator: (value) => GetUtils.isNullOrBlank(value)!
                              ? 'Please enter house name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _localityController,
                          label: 'Locality Name',
                          validator: (value) => GetUtils.isNullOrBlank(value)!
                              ? 'Please enter locality name'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: widget.isEditing
                              ? 'Update Address'
                              : 'Save Address',
                          isLoading: addressController.isLoading.value,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final addressData = {
                                'name': _nameController.text,
                                'phone': _contactController.text,
                                'pincode': _pincodeController.text,
                                'state': _stateController.text,
                                'city': _cityController.text,
                                'district': _districtController.text,
                                'houseName': _addressController.text,
                                'locality': _localityController.text,
                              };

                              final String userId = _auth.currentUser!.uid;

                              if (widget.isEditing &&
                                  widget.addressData != null) {
                                addressController.updateAddress(
                                  userId,
                                  widget.addressData!['id'],
                                  addressData,
                                );
                              } else {
                                addressController.addAddress(
                                    userId, addressData);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (addressController.isLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

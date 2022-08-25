import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_reatime/screens/widgets/custo_bottom_button.dart';
import 'package:todo_reatime/screens/widgets/reusable_text_form_field.dart';

class AddData extends StatefulWidget {
  const AddData({this.isEdit = false, this.data, Key? key}) : super(key: key);
  final bool isEdit;
  final QueryDocumentSnapshot? data;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.data?["name"],
    );
    _descController = TextEditingController(
      text: widget.data?["description"],
    );
    _priceController = TextEditingController(
      text: widget.data?["price"].toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
  }

  Future<void> addData() async {
    String? name = _nameController.text;
    String? description = _descController.text;
    int? price = int.parse(_priceController.text);

    if (name.isNotEmpty &&
        description.isNotEmpty &&
        price.toString().isNotEmpty) {
      await _fireStore.collection("user").add(
        {
          "name": name,
          "description": description,
          "price": price,
        },
      );
    }
  }

  Future<void> updateData(productId) async {
    // String? id = documentSnapshot?.id;
    String? name = _nameController.text;
    String? description = _descController.text;
    int? price = int.parse(_priceController.text);

    if (name.isNotEmpty &&
        description.isNotEmpty &&
        price.toString().isNotEmpty) {
      await _fireStore.collection("user").doc(productId).update(
        {
          "name": name,
          "description": description,
          "price": price,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEdit ? "Edit Data" : "Add Data"),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ReusableTextFormField(
                    controller: _nameController,
                    hintText: widget.isEdit ? "Edit Name" : "Name",
                    labelText: widget.isEdit ? "Edit Name" : "Name",
                    checkValidation: (value) {
                      if (value == null || value.isEmpty) {
                        return "can't be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableTextFormField(
                    controller: _priceController,
                    hintText: widget.isEdit ? "Edit Price" : "Price",
                    labelText: widget.isEdit ? "Edit Price" : "Price",
                    keyBordType: TextInputType.number,
                    checkValidation: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          RegExp(r'[,.-]').hasMatch(value)) {
                        return "can't be empty and special character not allowed";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableTextFormField(
                    controller: _descController,
                    hintText:
                        widget.isEdit ? "Edit Description" : "Description",
                    labelText:
                        widget.isEdit ? "Edit Description" : "Description",
                    checkValidation: (value) {
                      if (value == null || value.isEmpty) {
                        return "can't be empty";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomButton(
            buttonName: widget.isEdit ? "Edit" : "SAVE",
            onTap: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });

                widget.isEdit ? updateData(widget.data?.id) : addData();
                Navigator.pop(context);
              }
              setState(() {
                isLoading = false;
              });
            }),
      ),
    );
  }
}

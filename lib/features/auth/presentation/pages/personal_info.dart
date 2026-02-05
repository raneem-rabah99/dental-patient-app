import 'dart:io';
import 'package:dentaltreatment/features/auth/data/models/customer_info_model.dart';
import 'package:dentaltreatment/features/auth/data/sources/customer_info_service.dart';
import 'package:dentaltreatment/features/auth/presentation/managers/customer_info_cubit.dart';
import 'package:dentaltreatment/features/auth/presentation/managers/customer_info_state.dart';
import 'package:dentaltreatment/features/auth/presentation/pages/login_page.dart';
import 'package:dentaltreatment/features/auth/presentation/widgets/signupWidgit.dart';
import 'package:dentaltreatment/features/auth/presentation/widgets/uploadphoto.dart';
import 'package:dentaltreatment/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController illnessController = TextEditingController();
  File? uploadedFile;
  final _formKey = GlobalKey<FormState>();

  bool noMedicalCondition = false; // ✅ new flag

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerInfoCubit(CustomerInfoService()),
      child: Scaffold(
        body: BlocConsumer<CustomerInfoCubit, CustomerInfoState>(
          listener: (context, state) {
            if (state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Submitting info...')),
              );
            } else if (state.successMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.darkblue, AppColor.lightblue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    // 🔙 Back button
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // 🌟 Centered Form Card
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildForm(context, state.isLoading),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 80, bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderTop("Personal Information"),
            const SizedBox(height: 8),
            buildHeader(
              "Should enter your birthday and medical information (if any).",
            ),
            const SizedBox(height: 20),

            // ===== Birthday =====
            const Text(
              "Birthday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: birthdayController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "YYYY-MM-DD",
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(Icons.calendar_month),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? "Select your birthdate" : null,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ===== Checkbox =====
            Row(
              children: [
                Checkbox(
                  value: noMedicalCondition,
                  onChanged: (val) {
                    setState(() {
                      noMedicalCondition = val ?? false;
                      if (noMedicalCondition) {
                        illnessController.clear();
                        uploadedFile = null;
                      }
                    });
                  },
                  activeColor: AppColor.darkblue,
                ),
                const Expanded(
                  child: Text(
                    "Check this box if you do not have a medical condition",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ===== Medical condition text =====
            Text(
              "Medical Condition",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: noMedicalCondition ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: illnessController,
              maxLines: 3,
              enabled: !noMedicalCondition,
              style: TextStyle(
                fontSize: 14,
                color: noMedicalCondition ? Colors.grey : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Write here about your medical condition...",
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                filled: true,
                fillColor:
                    noMedicalCondition ? Colors.grey.shade200 : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ===== Upload Medical Record =====
            Text(
              "Upload Medical Record (PDF)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: noMedicalCondition ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            IgnorePointer(
              ignoring: noMedicalCondition,
              child: Opacity(
                opacity: noMedicalCondition ? 0.5 : 1,
                child: UploadDocumentWidget(
                  title: "Upload Medical Record",
                  placeholderText: "Attach PDF file",
                  height: 80,
                  onFilePicked: (file) {
                    setState(() {
                      if (file != null) {
                        uploadedFile = File(file.path);
                      }
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),
            buildButton100(
              isLoading ? "Submitting..." : "Submit",
              isLoading ? null : () => _submit(context),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final model = CustomerInfoModel(
        birthdate: birthdayController.text,
        patientRecordFile:
            noMedicalCondition ? null : uploadedFile, // ✅ disabled if checked
        patientRecordText:
            noMedicalCondition
                ? null
                : (uploadedFile == null ? illnessController.text : null),
      );

      context.read<CustomerInfoCubit>().uploadCustomerInfo(model);
    }
  }
}

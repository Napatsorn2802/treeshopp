import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:treeshop/pages/onboarding.dart';
import 'package:treeshop/services/auth.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/services/shared_pref.dart';
import 'package:treeshop/widget/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email, address;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getthesharedpref() async {
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    address = await SharedPreferenceHelper().getUserAddress();
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("profileImages").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserImage(downloadUrl);
      await getthesharedpref(); // โหลดใหม่ให้ UI อัปเดต
    }
  }

  // ✅ ฟังก์ชันแก้ไขชื่อ
  Future<void> editNameDialog() async {
    TextEditingController nameController =
        TextEditingController(text: name ?? "");

    await showDialog(
      context: context,
      builder: (context) {
        return editDialog(
          title: "Edit Name",
          label: "Enter new name",
          controller: nameController,
          onSave: (newName) async {
            await SharedPreferenceHelper().saveUserName(newName);
            await DatabaseMethod().updateUserName(newName);
            setState(() => name = newName);
          },
        );
      },
    );
  }

  // ✅ ฟังก์ชันแก้ไขที่อยู่
  Future<void> editAddressDialog() async {
    TextEditingController addressController =
        TextEditingController(text: address ?? "");

    await showDialog(
      context: context,
      builder: (context) {
        return editDialog(
          title: "Edit Address",
          label: "Enter your address",
          controller: addressController,
          onSave: (newAddress) async {
            await SharedPreferenceHelper().saveUserAddress(newAddress);
            await DatabaseMethod().updateUserAddress(newAddress);
            setState(() => address = newAddress);
          },
        );
      },
    );
  }

  // ✅ reusable dialog
  Widget editDialog({
    required String title,
    required String label,
    required TextEditingController controller,
    required Function(String) onSave,
  }) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 245, 230),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title, style: AppWidget.boldTextFeildStyle()),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B5444),
              foregroundColor: Colors.white),
          onPressed: () async {
            String value = controller.text.trim();
            if (value.isNotEmpty) {
              await onSave(value);
              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(168, 153, 115, 55),
        title: Center(
          child: Text("Profile", style: AppWidget.boldTextFeildStyle()),
        ),
      ),
      backgroundColor: const Color.fromARGB(168, 153, 115, 55),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: getImage,
                    child: ClipOval(
                      child: selectedImage != null
                          ? Image.file(selectedImage!,
                              height: 90, width: 90, fit: BoxFit.cover)
                          : Image.network(image!,
                              height: 90, width: 90, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ ชื่อ
                  profileTile(
                    icon: Icons.person_outline,
                    title: "Name",
                    value: name!,
                    onTap: editNameDialog,
                  ),

                  const SizedBox(height: 15),

                  // ✅ อีเมล (อ่านอย่างเดียว)
                  profileTile(
                    icon: Icons.mail_outline,
                    title: "Email",
                    value: email!,
                    onTap: null,
                  ),

                  const SizedBox(height: 15),

                  // ✅ ที่อยู่ (แก้ไขได้)
                  profileTile(
                    icon: Icons.location_on_outlined,
                    title: "Address",
                    value: address ?? "No address yet",
                    onTap: editAddressDialog,
                  ),

                  const SizedBox(height: 20),

                  // ออกจากระบบ
                  GestureDetector(
                    onTap: () async {
                      await AuthMethods().SignOut().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Onboarding()),
                        );
                      });
                    },
                    child: profileTile(
                      icon: Icons.logout_sharp,
                      title: "Logout",
                      value: "",
                      onTap: null,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget profileTile({
    required IconData icon,
    required String title,
    required String value,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(168, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 35),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppWidget.lightTextFeildStyle()),
                  Text(value, style: AppWidget.semiboldTextFeildStyle()),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.edit, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

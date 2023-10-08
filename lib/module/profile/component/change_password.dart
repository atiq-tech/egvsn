import 'package:egovisionapp/module/profile/controller/profile_cubit.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassEdit extends StatefulWidget {
  const ChangePassEdit({Key? key}) : super(key: key);

  @override
  State<ChangePassEdit> createState() => _ChangePassEditState();
}

class _ChangePassEditState extends State<ChangePassEdit> {
  bool showCurrentPassword = true;
  bool showNewPassword = true;
  bool showConfirmPassword = true;

  togglePasswordText(String button) {
    if (button == "Current password") {
      setState(() {
        showCurrentPassword = !showCurrentPassword;
      });
    } else if (button == "New password") {
      setState(() {
        showNewPassword = !showNewPassword;
      });
    } else {
      setState(() {
        showConfirmPassword = !showConfirmPassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileScreenCubit>();
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.3),
              ),
            ]),
        child: Form(
          // key: bloc.chanePassFormKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: double.infinity,
                    color: redColor,
                    child: const Text(
                      "Password Update",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Current password",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        )),
                    TextFormField(
                      obscureText: showCurrentPassword,
                      controller: bloc.currentPassCtrl,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter current password';
                        }else{
                          bloc.currentPassCtrl.text = value.toString().trim();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Current password",
                        suffixIcon: InkWell(
                          onTap: () {
                            togglePasswordText("Current password");
                          },
                          child: Icon(
                            showCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "New password",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        )),
                    TextFormField(
                      obscureText: showNewPassword,
                      controller: bloc.newPassCtrl,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter new password';
                        } else{
                          bloc.newPassCtrl.text = value.toString().trim();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "New password",
                        suffixIcon: InkWell(
                          onTap: () {
                            togglePasswordText("New password");
                          },
                          child: Icon(
                            showNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Confirm password",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        )),
                    TextFormField(
                      obscureText: showConfirmPassword,
                      controller: bloc.confirmPassCtrl,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter confirm password!';
                        }else{
                          bloc.confirmPassCtrl.text = value.toString().trim();
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Confirm password",
                        suffixIcon: InkWell(
                          onTap: () {
                            togglePasswordText("Confirm password");
                          },
                          child: Icon(
                            showConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: redColor,
                            shadowColor: ashColor,
                            side: const BorderSide(
                                color: redColor,
                                strokeAlign: BorderSide.strokeAlignInside),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        onPressed: () {
                          // Utils.closeKeyBoard(context);
                          // bloc.changePassword();
                          if(bloc.newPassCtrl.text != bloc.confirmPassCtrl.text){
                            Utils.errorSnackBar(context, "Password doesn't match");
                          }
                          else if(bloc.currentPassCtrl.text.isEmpty || bloc.newPassCtrl.text.isEmpty || bloc.confirmPassCtrl.text.isEmpty){
                            Utils.errorSnackBar(context, "All password fields are required");
                          }
                          else{
                            setState(() {
                              bloc.isPassLoading = true;
                            });
                            bloc.changePassword(context,bloc.currentPassCtrl.text,
                                bloc.newPassCtrl.text).then((value) {
                                  setState(() {
                                    bloc.isPassLoading = false;
                                  });
                            });
                            print("all ok");
                          }
                        },
                        child: bloc.isPassLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text("Save changes"),
                      ),
                    ),
                  ],
                ),
              )

              // SizedBox(
              //   height: 48,
              //   child: BlocBuilder<AdEditProfileCubit, EditProfileState>(
              //       builder: (context, state) {
              //     if (state is EditProfileStatePasswordLoading) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //     return OutlinedButton(
              //       style: OutlinedButton.styleFrom(
              //           foregroundColor: redColor,
              //           shadowColor: ashColor,
              //           side: const BorderSide(
              //               color: redColor,
              //               strokeAlign: BorderSide.strokeAlignInside),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(4))),
              //       onPressed: () {
              //         // Utils.closeKeyBoard(context);
              //         // bloc.changePassword();
              //       },
              //       child: Text("Save changes"),
              //     );
              //   }),
              // )
            ],
          ),
        ));
  }
}

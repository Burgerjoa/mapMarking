import 'package:flutter/material.dart';
import '../size.dart';
import 'custom_text_form_field.dart';
import 'package:validators/validators.dart';

class CustomForm extends StatelessWidget {

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          CustomTextFormField(
            text: "Email",
            mValide: (value) {
              print("value:$value");
              if (value!.isEmpty){
                return "Please enter some text";
              }else if(!isEmail(value)){
                return "not email format";
              }else{
                return null;
              }
            },
          ),
          SizedBox(height: midium_gap,),
          CustomTextFormField(
            text: "Password",
            mValide: (value){
              print("value : $value");
              if(value!.isEmpty){
                return "Please some text";
              }else if(value.toString().length > 20){
                return "too long password";
              }
            },
          ),
          SizedBox(height: large_gap),
          TextButton(
            onPressed: (){
              //유효성 검사 성공하면 ture 아니면 false 리턴
              if(_formkey.currentState!.validate()){
                Navigator.pushNamed(context, "/home");
              }
            },
            child: Text("login"),
          ),
        ],
      ),
    );
  }
}

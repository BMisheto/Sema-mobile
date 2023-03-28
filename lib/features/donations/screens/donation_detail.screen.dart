import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sema/theme/app_styles.dart';
import 'package:sema/utils/url.dart';

class DonationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> donation;

  DonationDetailScreen({required this.donation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          title: Text("Donation Details", style: Styles.paragraph,)
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Gap(10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                
                 
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    
                    image: NetworkImage(
                      '$MediaUrl${donation['donation_cover']}',
                    ),
                  ),
                ),
              ),
              Gap(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  donation['name'],
                  style: Styles.bigHeadline,
                ),
              ),
              Gap(10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  donation['description'],
               style: Styles.paragraph.copyWith(color: Colors.grey.shade800),
                ),
              ),
              Gap(20),
              Padding(
                padding: EdgeInsets.all(10) ,
              child:TextFormField(
                            
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Amount to donate',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 182, 182, 182)),
                              filled: true,
                              fillColor: Colors.white54,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter amount';
                              }
                              return null;
                            },
                          ) ,),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                     color: Colors.green,
                     borderRadius:  BorderRadius.circular(10)
                  ),
                  width: double.infinity,
                 
                  child: Center(
                    child: GestureDetector(
                      onTap: (){},
                      child: Text('Donate', style: Styles.paragraph.copyWith(color: Colors.white)),
                    ),
                  )
                ,
                ),
              ), SizedBox(height: 16),
            
            ],
          ),
        ),
      ),
    );
 }
}

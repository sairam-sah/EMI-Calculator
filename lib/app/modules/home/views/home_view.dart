import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy EMI',style:TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: Container(
          padding: EdgeInsets.all(5),
          child: Image.asset('assets/logo_refresh.png',)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset('assets/emi.png',fit: BoxFit.cover,)),
              const SizedBox(height: 20),
            ElevatedButton.icon(
              icon:
                  const Icon(Icons.account_balance, size: 28), // Flat Loan Icon
              label: const Text(
                "Flat Interest Loan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                backgroundColor: Colors.blue, // Change to your preferred color
                foregroundColor: Colors.white, // Text & Icon Color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  Get.toNamed(Routes.EMICALCULATOR, arguments: 'Flat Interest Loan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.trending_down,
                  size: 28), // Declining Interest Icon
              label: const Text(
                "Declining Interest Loan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  Get.toNamed(Routes.EMICALCULATOR, arguments: 'Declining Interest Loan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.percent, size: 28), // Interest-Only Icon
              label: const Text(
                "Interest-Only Loan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                   Get.toNamed(Routes.EMICALCULATOR, arguments: 'Interest-Only Loan'),
            ),
            SizedBox(height: 30,),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                   Get.toNamed(Routes.CALCULATOR);
                },child:Image.asset('assets/cal.png',height: 100,) ,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Column(children:[
         Text('Copyright © 2025M & MB Soft Tech',style: TextStyle(color: Colors.white,fontSize: 18),),
         Text('All Rights Reserved',style: TextStyle(color: Colors.white,fontSize: 18),)    
        ] 
      ),)
    );
  }
}

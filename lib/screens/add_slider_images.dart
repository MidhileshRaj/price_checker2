import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/controller/slider_item_controller.dart';
class AddSliderImages extends StatelessWidget {


  const AddSliderImages({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SliderItemController());
    controller.checkAvailableImages();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image Link'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.imageLinkController,
              decoration: InputDecoration(
                labelText: 'Image Link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () { controller.imageLinkController.clear();}
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                controller.addImageLink();
                controller.imageLinkController.clear();
              },
              child: const Text('Add Link'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Image Links',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.imageLinks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(controller.imageLinks[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed:(){controller.removeItemFromList(index);},
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
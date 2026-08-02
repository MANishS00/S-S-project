import 'package:app/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:app/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedQuantity = 1;
  int _selectedImageIndex = 0;


  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final cartVM = Provider.of<CartViewModel>(
      context,
      listen: false,
    );

    final bool isOnSale = product.isSale;

    final double originalPrice = product.price;

    final double salePrice = product.salePrice ?? product.price;

    final int availableStock = product.stockQuantity;

    final double discount = product.percentageDiscount;

    // Product images
    final List<String> productImages = [];

    if (product.profileImage.isNotEmpty) {
      productImages.add(product.profileImage);
    }

    // Add additional product images
    for (final imageModel in product.productImages) {
      final String imageUrl = imageModel.imageUrl;
      if (imageUrl.isNotEmpty && !productImages.contains(imageUrl)) {
        productImages.add(imageUrl);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff222222),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Color(0xff222222),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
  
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(
              productImages,
              isOnSale,
              discount,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                22,
                20,
                30,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  if (product.brand != null && product.brand!.isNotEmpty)
                    Text(
                      product.brand!,
                      style: const TextStyle(
                        color: Color(0xff777777),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: 7),

                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Color(0xff222222),
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Rating
                  // Row(
                  //   children: [
                  //     ...List.generate(
                  //       5,
                  //       (index) => const Icon(
                  //         Icons.star,
                  //         color: Color(0xffffb800),
                  //         size: 19,
                  //       ),
                  //     ),

                  //     const SizedBox(width: 8),

                  //     const Text(
                  //       '4.8',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 14,
                  //       ),
                  //     ),

                  //     const SizedBox(width: 5),

                  //     const Text(
                  //       '(120 Reviews)',
                  //       style: TextStyle(
                  //         color: Colors.grey,
                  //         fontSize: 13,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 18),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Rs ${salePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xff024874),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isOnSale) ...[
                        const SizedBox(width: 12),
                        Text(
                          'Rs ${originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (discount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffffeeee),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              '$discount% OFF',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 22),

                  if (availableStock > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _buildQuantitySelector(
                          availableStock,
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),

                  const Divider(
                    color: Color(0xffeeeeee),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Color(0xff666666),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildProductDetails(product),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: availableStock > 0
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Add To Cart
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            cartVM.addToCart(
                              product,
                              _selectedQuantity,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Added to cart!',
                                ),
                                backgroundColor: Color(0xff024874),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                          ),
                          label: const Text(
                            'Add to Cart',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff024874),
                            side: const BorderSide(
                              color: Color(0xff024874),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Buy Now
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            cartVM.addToCart(
                              product,
                              _selectedQuantity,
                            );

                            // Navigate to checkout
                            // Navigator.pushNamed(
                            //   context,
                            //   '/checkout',
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff024874),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildImageGallery(
    List<String> images,
    bool isOnSale,
    double discount,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 360,
                width: double.infinity,
                child: images.isEmpty
                    ? Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 70,
                          color: Colors.grey,
                        ),
                      )
                    : PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(25),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image_outlined,
                                  size: 60,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),

              // Sale Badge
              // if (isOnSale && discount > 0)
              //   Positioned(
              //     left: 20,
              //     top: 20,
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 12,
              //         vertical: 7,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Colors.red,
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: Text(
              //         '$discount% OFF',
              //         style: const TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
          if (images.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 7,
                      width: _selectedImageIndex == index ? 22 : 7,
                      decoration: BoxDecoration(
                        color: _selectedImageIndex == index
                            ? const Color(0xff024874)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(
    int availableStock,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _selectedQuantity > 1
                ? () {
                    setState(() {
                      _selectedQuantity--;
                    });
                  }
                : null,
            icon: const Icon(
              Icons.remove,
              size: 20,
            ),
          ),
          Text(
            '$_selectedQuantity',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: _selectedQuantity < availableStock
                ? () {
                    setState(() {
                      _selectedQuantity++;
                    });
                  }
                : null,
            icon: const Icon(
              Icons.add,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(
    ProductModel product,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (product.brand != null && product.brand!.isNotEmpty)
            _detailRow(
              'Brand',
              product.brand!,
            ),
          if (product.size != null && product.size!.isNotEmpty)
            _detailRow(
              'Size',
              product.size!,
            ),
          if (product.color != null && product.color!.isNotEmpty)
            _detailRow(
              'Color',
              product.color!,
            ),
          if (product.material != null && product.material!.isNotEmpty)
            _detailRow(
              'Material',
              product.material!,
            ),
          _detailRow(
            'Category',
            'Perfumes',
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

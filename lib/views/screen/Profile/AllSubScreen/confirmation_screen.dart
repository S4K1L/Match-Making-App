import 'package:flutter/material.dart';
import 'package:flutter_extension/util/images.dart';
import 'package:get/get.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  Widget _buildSummaryRow(
    String title,
    String value, {
    bool isBoldTitle = false,
    bool isBoldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBoldTitle ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF555555),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBoldValue ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 5.0;
          const dashHeight = 1.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFADADAD)),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(Images.greeyBackground, fit: BoxFit.fill),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const SizedBox(
                          width: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFF494949),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "CONFIRMATION",
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF133F36),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          "Payment Success!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Your payment has been successfully done.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Profile Banner Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBE1BF).withOpacity(0.5),
                              border: Border.all(
                                color: const Color(0xFFD49E17),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Tacos al Pastor",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Tue, 15 pm",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF6B6B6B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE6E6E6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.diamond,
                                    color: Color(0xFF8B8B8B),
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Receipt Info Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1ECD6),
                              border: Border.all(
                                color: const Color(0xFFD49E17),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                _buildSummaryRow(
                                  "Plan Package",
                                  "Premium",
                                  isBoldValue: true,
                                ),
                                const SizedBox(height: 10),
                                _buildSummaryRow("Amount", "\$75.05"),
                                const SizedBox(height: 10),
                                _buildSummaryRow(
                                  "Payment Status",
                                  "Successful",
                                ),
                                const SizedBox(height: 10),
                                _buildSummaryRow("Payment Method", "PayPal"),
                                const SizedBox(height: 10),
                                _buildSummaryRow("Date", "Wed, 10 Jan 2024"),
                                const SizedBox(height: 10),
                                _buildSummaryRow("Time", "16:48:02"),

                                const SizedBox(height: 16),
                                _buildDashedDivider(),
                                const SizedBox(height: 16),

                                _buildSummaryRow(
                                  "Tax",
                                  "\$00.0",
                                  isBoldTitle: true,
                                ),
                                _buildSummaryRow(
                                  "Total",
                                  "\$75.05",
                                  isBoldTitle: true,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // CONFIRM NOW Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: InkWell(
                            onTap: () {
                              // Action to confirm
                              Get.back(); // Or route to next success screen
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF133F36), // Deep green
                                borderRadius: BorderRadius.circular(35),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "CONFIRM NOW",
                                style: TextStyle(
                                  fontFamily: 'Cinzel',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

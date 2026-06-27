import 'package:flutter/material.dart';
import 'package:accessibility_helper/services/api_service.dart';

class Screen2 extends StatefulWidget {
  final String disability;
  final String query;

  const Screen2({
    super.key,
    required this.disability,
    required this.query,
  });

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<String> results = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final data = await ApiService.getRecommendations(
        widget.disability,
        widget.query,
      );

      setState(() {
        results = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error =
            "We couldn't retrieve recommendations. Please check your network.";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF3F4F9), // Modern soft cool gray background
      body: CustomScrollView(
        slivers: [
          // 1. PREMIUM COLLAPSIBLE APP BAR WITH GRADIENT OVERLAY
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1E3A8A),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                "Smart Solutions",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2563EB), // Vibrant Electric Blue
                      Color(0xFF1D4ED8), // Deep Royal Blue
                      Color(0xFF0F172A), // Midnight Dark Accent
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: fetchData,
                ),
              ),
            ],
          ),

          // 2. DYNAMIC METADATA CHIP BAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.psychology,
                            size: 16, color: Color(0xFF1E40AF)),
                        const SizedBox(width: 6),
                        Text(
                          widget.disability.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w800, // Fixed: Native Flutter weight
                            color: Color(0xFF1E40AF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Target: "${widget.query}"',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),

          // 3. CORE INTERACTIVE LIST WINDOW
          SliverFillRemaining(
            hasScrollBody: true,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _buildMainBody(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainBody() {
    // A. PREMIUM LOADING LOOK
    if (loading) {
      return Center(
        key: const ValueKey('loading'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Generating custom interface...",
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // B. MODERN ACTIONABLE ERROR STATE
    if (error != null) {
      return Center(
        key: const ValueKey('error'),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 48, color: Colors.redAccent),
                const SizedBox(height: 16),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: fetchData,
                  child: const Text("Retry Process"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // C. CLEAN EMPTY RESULTS DESIGN
    if (results.isEmpty) {
      return Center(
        key: const ValueKey('empty'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.layers_clear_outlined,
                  size: 40, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            const Text(
              "No recommendations computed",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 16),
            ),
          ],
        ),
      );
    }

    // D. HIGH-END EXPANDABLE CARD RENDERING
    return ListView.builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3A8A).withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "0${index + 1}",
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight:
                          FontWeight.w900, // Fixed: Native Flutter weight
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              title: Text(
                results[index],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  height: 1.3,
                ),
              ),
              trailing: const Icon(Icons.arrow_drop_down_circle_outlined,
                  color: Color(0xFF94A3B8)),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(72, 0, 20, 16),
                  child: Row(
                    children: [
                      const Icon(Icons.offline_bolt_rounded,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        "Actionable Accessibility Item",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

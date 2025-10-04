// Cenmaya — Flutter Starter (Netflix-style UI, legally distinct)
// -----------------------------------------------------------
// • Flutter 3.x, Material You
// • Legally distinct look: unique palette, typography, icons
// • Screens: Home (hero + carousels), Details, Search, Downloads, Profile
// • Dummy data + placeholders
// • Safe to rename/package: com.cenmaya.app
// -----------------------------------------------------------
// Getting started:
// 1) Create a Flutter project: flutter create cenmaya
// 2) Replace lib/main.dart with this file's contents
// 3) Run: flutter run
// 4) Later: replace images with your own CDN/files & wire real APIs

import 'package:flutter/material.dart';

void main() => runApp(const CenmayaApp());

class CenmayaApp extends StatelessWidget {
  const CenmayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF6C4FD6); // Cenmaya brand (distinct from Netflix)
    return MaterialApp(
      title: 'Cenmaya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;
  final _pages = const [HomeScreen(), SearchScreen(), DownloadsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.download_outlined), selectedIcon: Icon(Icons.download), label: 'Downloads'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}

// -------------------- HOME --------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const _HomeAppBar(),
        SliverToBoxAdapter(child: _HeroBanner(item: demoHero)),
        SliverToBoxAdapter(child: SizedBox(height: 12)),
        _CarouselSection(title: 'Spotlight – فلسفة وإنسان', items: demoRowA),
        _CarouselSection(title: 'دراما إيرانية', items: demoRowB),
        _CarouselSection(title: 'مختارات سينمايا', items: demoRowC),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF6C4FD6), Color(0xFFB07CFF)]),
            ),
          ),
          const SizedBox(width: 8),
          Text('Cenmaya', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.cast_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.item});
  final MediaItem item;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
                stops: [0.6, 1],
              ).createShader(rect),
              blendMode: BlendMode.darken,
              child: Image.network(
                item.backdropUrl,
                fit: BoxFit.cover,
                loadingBuilder: (c, w, p) => const Center(child: CircularProgressIndicator()),
                errorBuilder: (c, e, s) => Container(color: Colors.black26, child: const Center(child: Icon(Icons.broken_image))),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
                const SizedBox(height: 8),
                Row(children: [
                  _Pill(text: item.year.toString()),
                  const SizedBox(width: 8),
                  _Pill(text: item.genre),
                  const SizedBox(width: 8),
                  _Pill(text: '${item.duration}m'),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  FilledButton.icon(
                    onPressed: () => _openDetails(context, item),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('مشاهدة'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('للمشاهدة'),
                  ),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(.5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outline.withOpacity(.2)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _CarouselSection extends StatelessWidget {
  const _CarouselSection({required this.title, required this.items});
  final String title;
  final List<MediaItem> items;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) => _PosterCard(item: items[i]),
              separatorBuilder: (c, i) => const SizedBox(width: 12),
              itemCount: items.length,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _PosterCard extends StatelessWidget {
  const _PosterCard({required this.item});
  final MediaItem item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openDetails(context, item),
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2/3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.black26, child: const Icon(Icons.broken_image)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text('${item.year} • ${item.genre}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

void _openDetails(BuildContext context, MediaItem item) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailsScreen(item: item)));
}

// -------------------- DETAILS --------------------
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.item});
  final MediaItem item;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(item.backdropUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Pill(text: item.genre),
              const SizedBox(width: 8),
              _Pill(text: '${item.duration} دقيقة'),
              const SizedBox(width: 8),
              _Pill(text: item.year.toString()),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.synopsis,
            style: const TextStyle(height: 1.5),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow), label: const Text('تشغيل')),
          const SizedBox(height: 24),
          Text('مقترحات مشابهة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) => _PosterCard(item: demoRowB[i % demoRowB.length]),
              separatorBuilder: (c, i) => const SizedBox(width: 12),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String q = '';
  @override
  Widget build(BuildContext context) {
    final items = demoAll.where((e) => e.title.toLowerCase().contains(q.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('بحث')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (v) => setState(() => q = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ابحث عن فيلم، سنة، نوع…',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2/3,
              ),
              itemCount: items.length,
              itemBuilder: (c, i) => _PosterCard(item: items[i]),
            ),
          )
        ],
      ),
    );
  }
}

// -------------------- DOWNLOADS --------------------
class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التنزيلات')),
      body: const Center(
        child: Text('لا توجد تنزيلات بعد — أضف أفلامًا إلى قائمتك ثم نزّلها لاحقًا (واجهة تجريبية).'),
      ),
    );
  }
}

// -------------------- PROFILE --------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(radius: 28, backgroundColor: cs.primary, child: const Text('س')), 
              const SizedBox(width: 12),
              const Expanded(child: Text('سينمايا — عاشق السينما الفلسفية')),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(value: true, onChanged: (_) {}, title: const Text('الوضع الليلي')),
          const Divider(height: 24),
          ListTile(leading: const Icon(Icons.info_outline), title: const Text('عن التطبيق'), subtitle: const Text('Cenmaya v0.1')), 
          ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('سياسة الخصوصية')), 
          ListTile(leading: const Icon(Icons.logout), title: const Text('تسجيل الخروج')), 
        ],
      ),
    );
  }
}

// -------------------- DATA MODELS --------------------
class MediaItem {
  final String id;
  final String title;
  final int year;
  final String genre;
  final int duration; // minutes
  final String posterUrl;
  final String backdropUrl;
  final String synopsis;
  const MediaItem({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.duration,
    required this.posterUrl,
    required this.backdropUrl,
    required this.synopsis,
  });
}

const demoHero = MediaItem(
  id: 'hero',
  title: 'City of Mirrors',
  year: 1998,
  genre: 'فلسفي',
  duration: 118,
  posterUrl: 'https://picsum.photos/400/600?random=21',
  backdropUrl: 'https://picsum.photos/1200/675?random=22',
  synopsis: 'رحلة بصرية شاعرية تتقاطع فيها الذاكرة مع الهوية، حيث تتحول المدينة إلى مرآة كبرى للروح.',
);

final demoRowA = List.generate(10, (i) => MediaItem(
  id: 'a$i',
  title: 'Silent Garden $i',
  year: 200${i % 10},
  genre: i % 2 == 0 ? 'دراما' : 'إنساني',
  duration: 90 + i,
  posterUrl: 'https://picsum.photos/400/600?random=${30 + i}',
  backdropUrl: 'https://picsum.photos/1200/675?random=${40 + i}',
  synopsis: 'تأمل في الفقدان والحب وسط صمت طويل كأنّه صلاة.',
));

final demoRowB = List.generate(10, (i) => MediaItem(
  id: 'b$i',
  title: 'Dust and Light $i',
  year: 201${i % 10},
  genre: i % 3 == 0 ? 'فلسفي' : 'دراما',
  duration: 95 + i,
  posterUrl: 'https://picsum.photos/400/600?random=${50 + i}',
  backdropUrl: 'https://picsum.photos/1200/675?random=${60 + i}',
  synopsis: 'ضوء يتسلل من شقوق الذاكرة ليوقظ الأسئلة القديمة.',
));

final demoRowC = List.generate(10, (i) => MediaItem(
  id: 'c$i',
  title: 'Blue Orchard $i',
  year: 199${i % 10},
  genre: i % 2 == 0 ? 'شاعري' : 'دراما',
  duration: 102 + i,
  posterUrl: 'https://picsum.photos/400/600?random=${70 + i}',
  backdropUrl: 'https://picsum.photos/1200/675?random=${80 + i}',
  synopsis: 'بستان أزرق يعيد صياغة الألم ليصبح موسيقى.',
));

final demoAll = [demoHero, ...demoRowA, ...demoRowB, ...demoRowC];

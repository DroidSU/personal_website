import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CaseStudyPage extends StatelessWidget {
  final String projectId;

  const CaseStudyPage({super.key, required this.projectId});

  static const projects = [
    {
      'id': 'platform-launch',
      'title': 'Platform launch toolkit',
      'location': 'Remote product team',
      'date': 'Q1 2025',
      'heroImage':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1600&q=80',
      'problem':
          'The launch process was fragmented across tools, causing delays and unclear handoffs between design, engineering, and marketing.',
      'approach':
          'We built a centralized toolkit with reusable components, shared metrics dashboards, and a simple publishing workflow to align the team and reduce handoff friction.',
      'outcome':
          'Release time improved by 35%, collaboration efficiency increased, and the product team reported a 42% reduction in coordination overhead.',
      'metrics': [
        '35% faster launches',
        '42% less coordination overhead',
        '92% adoption across teams',
      ],
    },
    {
      'id': 'dashboard-suite',
      'title': 'Analytics dashboard suite',
      'location': 'Enterprise analytics',
      'date': 'Q4 2024',
      'heroImage':
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1600&q=80',
      'problem':
          'Stakeholders lacked a single source of truth for customer engagement, which made fast decisions difficult and inconsistent.',
      'approach':
          'We designed a cohesive dashboard suite with dynamic filters, clear visual language, and performance-first data loading strategies.',
      'outcome':
          'Decision cycles shortened by 28%, and the suite became the primary reference for executive reviews.',
      'metrics': [
        '28% faster decisions',
        '5 dashboards rolled out',
        '98% uptime',
      ],
    },
    {
      'id': 'builder-studio',
      'title': 'Creator workflow studio',
      'location': 'Creative platform',
      'date': 'Summer 2024',
      'heroImage':
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1600&q=80',
      'problem':
          'Content creators were slowed by scattered tools and non-intuitive asset management.',
      'approach':
          'We crafted a studio designed around quick editing, seamless preview, and contextual guidance for every step of the workflow.',
      'outcome':
          'Creators reported a 47% productivity gain and stronger alignment across teams.',
      'metrics': [
        '47% productivity gain',
        '60% faster review cycles',
        '80% user satisfaction',
      ],
    },
  ];

  Map<String, Object?>
  get project => projects.cast<Map<String, Object?>>().firstWhere(
    (item) => item['id'] == projectId,
    orElse: () => {
      'id': projectId,
      'title': 'Project not found',
      'location': 'Unknown',
      'date': 'Unknown',
      'heroImage':
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=1600&q=80',
      'problem': 'No case study matches that ID.',
      'approach': 'Return to the project gallery to explore available work.',
      'outcome': 'No outcomes available.',
      'metrics': ['No data'],
    },
  );

  @override
  Widget build(BuildContext context) {
    final item = project;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.network(
                    item['heroImage'] as String,
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 320,
                        color: Theme.of(context).colorScheme.surface,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                  Container(
                    height: 320,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromRGBO(0, 0, 0, 0.24),
                          const Color.fromRGBO(0, 0, 0, 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      children: [
                        _LabelChip(label: item['location'] as String),
                        _LabelChip(label: item['date'] as String),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _contentBlock(
                      context,
                      'Problem',
                      item['problem'] as String,
                    ),
                    const SizedBox(height: 24),
                    _contentBlock(
                      context,
                      'Approach',
                      item['approach'] as String,
                    ),
                    const SizedBox(height: 24),
                    _outcomeBlock(context, item),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentBlock(BuildContext context, String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _outcomeBlock(BuildContext context, Map<String, Object?> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Outcome', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['outcome'] as String,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: (item['metrics'] as List<String>).map((metric) {
                    return Chip(
                      label: Text(metric),
                      backgroundColor: Color.fromRGBO(139, 92, 246, 0.12),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;

  const _LabelChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

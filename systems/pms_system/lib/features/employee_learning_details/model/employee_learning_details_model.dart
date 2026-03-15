/// Models for Employee Learning Details screen.
/// TODO: Replace with API-driven models when backend is available.

class EmployeeLearningDetailsModel {
  EmployeeLearningDetailsModel({
    this.employeeName,
    this.highestCompetency,
    this.lowestCompetency,
    this.reviewCycles = const [],
  });

  final String? employeeName;
  final CompetencyItem? highestCompetency;
  final CompetencyItem? lowestCompetency;
  final List<ReviewCycleItem> reviewCycles;

  factory EmployeeLearningDetailsModel.mock() {
    return EmployeeLearningDetailsModel(
      employeeName: 'Abdelraheem',
      highestCompetency: CompetencyItem(
        name: 'Problem Solving',
        score: 4.5,
        maxScore: 5,
      ),
      lowestCompetency: CompetencyItem(
        name: 'Design System',
        score: 3.25,
        maxScore: 5,
      ),
      reviewCycles: [
        ReviewCycleItem(
          role: 'Senior Full Stack Developer - Development',
          dateOfCycle: DateTime(2024, 12, 11),
          cycleId: 1,
        ),
        ReviewCycleItem(
          role: 'Senior Full Stack Developer - Development',
          dateOfCycle: DateTime(2025, 6, 1),
          cycleId: 2,
        ),
        ReviewCycleItem(
          role: 'Senior Full Stack Developer - Development',
          dateOfCycle: DateTime(2023, 4, 11),
          cycleId: 3,
        ),
      ],
    );
  }
}

class CompetencyItem {
  CompetencyItem({required this.name, required this.score, this.maxScore = 5});

  final String name;
  final double score;
  final double maxScore;

  String get scoreLabel => '($score/$maxScore)';
}

class ReviewCycleItem {
  ReviewCycleItem({
    required this.role,
    required this.dateOfCycle,
    required this.cycleId,
  });

  final String role;
  final DateTime dateOfCycle;
  final int cycleId;
}

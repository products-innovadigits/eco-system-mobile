import '../../shared/strategy_exports.dart';

class ObjectiveDetailsView extends StatefulWidget {
  const ObjectiveDetailsView({super.key, required this.id});
  final int id;

  @override
  State<ObjectiveDetailsView> createState() => _ObjectiveDetailsViewState();
}

class _ObjectiveDetailsViewState extends State<ObjectiveDetailsView> {

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "", withBottomBorder: false),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ObjectiveDetailsBloc()..add(Click(arguments: widget.id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveKPISBloc()..add(Click(arguments: widget.id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveInitiativesBloc()..add(Click(arguments: widget.id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveChartMonthBloc()..add(Click(arguments: widget.id)),
            ),
            BlocProvider(
              create: (context) =>
                  ObjectiveChartAnnualBloc()..add(Click(arguments: widget.id)),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Expanded(
                  child: ListAnimator(
                    controller: scrollController,
                data: [
                  ///Objective Details
                  ObjectiveDetailsBody(),

                  ///Objective indicators
                  ObjectiveKPIS(),

                  ///Objective indicators
                  ObjectiveInitiatives(),

                  ///Objective Chart
                  ObjectiveDetailsChart(scrollController: scrollController),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

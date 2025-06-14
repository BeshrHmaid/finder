import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/dialogs/dialogs.dart';
import '../cubits/create_model_cubit.dart';

typedef CreatedCallback = void Function(CreateModelCubit cubit);
typedef ModelCreated<Model> = Function(Model model);

class CreateModel<Model> extends StatefulWidget {
  final ModelCreated<Model>? onSuccess;
  final double? loadingHeight;
  final UsecaseCallBack? useCaseCallBack;
  final CreatedCallback? onCubitCreated;
  final Widget child;
  final Function? onTap;
  final bool withValidation;
  final Function? onError;
  final Widget? loadingWidget;
  final String? errorWidgetPath;

  const CreateModel({
    super.key,
    this.useCaseCallBack,
    this.onTap,
    this.onCubitCreated,
    required this.child,
    this.onSuccess,
    required this.withValidation,
    this.loadingHeight,
    this.onError,
    this.loadingWidget,
    this.errorWidgetPath,
  });

  @override
  State<CreateModel<Model>> createState() => _GetModelState<Model>();
}

class _GetModelState<Model> extends State<CreateModel<Model>> {
  CreateModelCubit<Model>? cubit;

  @override
  void initState() {
    cubit = CreateModelCubit<Model>(widget.useCaseCallBack!);
    if (widget.onCubitCreated != null) {
      widget.onCubitCreated!(cubit!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateModelCubit, CreateModelState>(
        bloc: cubit,
        builder: (context, state) {
          if (widget.onCubitCreated != null) {
            widget.onCubitCreated!(cubit!);
          }
          if (state is Loading) {
            return widget.loadingWidget ??
                SizedBox(
                    height: widget.loadingHeight ?? 50.h,
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ))));
          } else {
            return InkWell(
                onTap: () {
                  if (widget.withValidation) {
                    var temp = widget.onTap!();
                    if (temp != null && temp == true) {
                      cubit?.createModel();
                    }
                  } else {
                    cubit?.createModel();
                  }
                },
                child: widget.child);
          }
        },
        listener: (context, state) {
          if (state is CreateModelSuccessfully) {
            if (widget.onSuccess != null) widget.onSuccess!(state.model);
          }
          if (state is Error) {
            if (widget.errorWidgetPath != null) {
              // Navigator.push(context,widget.errorWidget!);
              // Navigator.push(context,);
              GoRouter.of(context).push(widget.errorWidgetPath!);
            } else if (widget.onError != null) {
              widget.onError!(state.message.toString());
            } else {
              Dialogs.showSnackBar(
                  context: context,
                  message: state.message.toString(),
                  typeSnackBar: AnimatedSnackBarType.error);
            }
          }
        });
  }
}

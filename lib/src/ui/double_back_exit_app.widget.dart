import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// 连续点击返回按钮退出应用, 如果要使用默认的提示信息(由[SnackBar]实现)的话, 那么要放在[Scaffold]
/// 下方!
class DoubleBackExitApp extends StatefulWidget {
  const DoubleBackExitApp({
    Key key,
    this.onShowExitHint,
    this.duration = const Duration(seconds: 2),
    @required this.child,
  }) : super(key: key);

  /// child
  final Widget child;

  /// 两次回退间隔
  final Duration duration;

  /// 显示退出提示
  final VoidCallback onShowExitHint;

  @override
  _DoubleBackExitAppState createState() => _DoubleBackExitAppState();
}

class _DoubleBackExitAppState extends State<DoubleBackExitApp> {
  final _closeAppSubject = PublishSubject();

  @override
  void initState() {
    super.initState();

    _closeAppSubject.timeInterval().listen((interval) {
      if (interval.interval < widget.duration) {
        exit(0);
      } else {
        if (widget.onShowExitHint != null) {
          widget.onShowExitHint();
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('再按一次退出应用'), duration: widget.duration),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _closeAppSubject.add(Object());
        return Future.value(false);
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _closeAppSubject.close();
    super.dispose();
  }
}

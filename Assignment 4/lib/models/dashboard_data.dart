import 'package:flutter/material.dart';

class DashboardStat {
  final String title;
  final String value;
  final String change;
  final IconData icon;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });
}

class Activity {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  bool completed;

  Activity({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    this.completed = false,
  });
}

class DashboardData {
  static const List<DashboardStat> stats = [
    DashboardStat(
      title: 'Projects',
      value: '12',
      change: '+3 this month',
      icon: Icons.folder_rounded,
    ),
    DashboardStat(
      title: 'Tasks',
      value: '24',
      change: '+8 this week',
      icon: Icons.task_alt_rounded,
    ),
    DashboardStat(
      title: 'Completed',
      value: '18',
      change: '75% completion',
      icon: Icons.check_circle_rounded,
    ),
    DashboardStat(
      title: 'Progress',
      value: '78%',
      change: '+12% this month',
      icon: Icons.trending_up_rounded,
    ),
  ];

  static List<Activity> activities = [
    Activity(
      title: 'Flutter Assignment 3',
      description: 'Profile Card UI completed',
      time: 'Today, 10:30 AM',
      icon: Icons.check_circle_rounded,
      completed: true,
    ),
    Activity(
      title: 'Responsive Dashboard',
      description: 'Assignment 4 development started',
      time: 'Today, 2:15 PM',
      icon: Icons.dashboard_rounded,
    ),
    Activity(
      title: 'Machine Learning',
      description: 'Model training completed',
      time: 'Yesterday',
      icon: Icons.auto_graph_rounded,
      completed: true,
    ),
    Activity(
      title: 'DSA Practice',
      description: '5 problems solved',
      time: 'Yesterday',
      icon: Icons.code_rounded,
      completed: true,
    ),
    Activity(
      title: 'GitHub',
      description: 'Assignment 3 pushed successfully',
      time: '2 days ago',
      icon: Icons.cloud_upload_rounded,
      completed: true,
    ),
  ];
}
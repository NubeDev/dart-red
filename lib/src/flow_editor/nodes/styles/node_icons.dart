import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Resolves a Lucide icon name string (e.g. 'server', 'gauge') to an [IconData].
///
/// Node types define their icon as a string so it serialises through the
/// palette REST API. The UI resolves the string to an actual icon here.
IconData resolveNodeIcon(String name) => _iconMap[name] ?? LucideIcons.circleDot;

const _iconMap = <String, IconData>{
  // System / generic
  'radio': LucideIcons.radio,
  'shuffle': LucideIcons.shuffle,
  'arrow-down-to-line': LucideIcons.arrowDownToLine,
  'circle-dot': LucideIcons.circleDot,
  'hash': LucideIcons.hash,
  'timer': LucideIcons.timer,
  'plus': LucideIcons.plus,

  // MQTT
  'server': LucideIcons.server,
  'server-cog': LucideIcons.serverCog,
  'mail': LucideIcons.mail,

  // Modbus / BACnet
  'cpu': LucideIcons.cpu,
  'hard-drive': LucideIcons.hardDrive,
  'gauge': LucideIcons.gauge,
  'pencil': LucideIcons.pencil,
  'network': LucideIcons.network,

  // UI
  'layout-dashboard': LucideIcons.layoutDashboard,
  'sliders-horizontal': LucideIcons.slidersHorizontal,
  'monitor': LucideIcons.monitor,

  // History
  'database': LucideIcons.database,
  'line-chart': LucideIcons.lineChart,

  // Insight
  'bell': LucideIcons.bell,
  'bell-ring': LucideIcons.bellRing,

  // Schedule
  'calendar-clock': LucideIcons.calendarClock,

  // Folder / portals
  'folder': LucideIcons.folder,
  'log-in': LucideIcons.logIn,
  'log-out': LucideIcons.logOut,

  // Device
  'box': LucideIcons.box,
  'terminal': LucideIcons.terminal,

  // Extra — developers can use any of these for custom nodes
  'activity': LucideIcons.activity,
  'zap': LucideIcons.zap,
  'thermometer': LucideIcons.thermometer,
  'droplet': LucideIcons.droplet,
  'wind': LucideIcons.wind,
  'sun': LucideIcons.sun,
  'moon': LucideIcons.moon,
  'plug': LucideIcons.plug,
  'wifi': LucideIcons.wifi,
  'bluetooth': LucideIcons.bluetooth,
  'settings': LucideIcons.settings,
  'wrench': LucideIcons.wrench,
  'filter': LucideIcons.filter,
  'git-branch': LucideIcons.gitBranch,
  'layers': LucideIcons.layers,
  'lock': LucideIcons.lock,
  'eye': LucideIcons.eye,
  'power': LucideIcons.power,
  'lightbulb': LucideIcons.lightbulb,
  'fan': LucideIcons.fan,
  'flame': LucideIcons.flame,
  'snowflake': LucideIcons.snowflake,
  'cloud': LucideIcons.cloud,
  'signal': LucideIcons.signal,
  'binary': LucideIcons.binary,
  'file-text': LucideIcons.fileText,
  'clipboard': LucideIcons.clipboard,
};

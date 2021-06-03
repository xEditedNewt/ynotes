import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/ui/screens/agenda/agendaPage.dart';

addEvent(context) async {
  AgendaEvent? temp = (await (agendaEventEdit(context, true, defaultDate: agendaDate))) as AgendaEvent?;
  if (temp != null) {
    print(temp.recurrenceScheme);
    if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
      await appSys.offline.agendaEvents.addAgendaEvent(temp, temp.recurrenceScheme);
    } else {
      await appSys.offline.agendaEvents.addAgendaEvent(temp, await getWeek(temp.start!));
    }
    await AppNotification.scheduleAgendaReminders(temp);
  }
}

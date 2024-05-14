import 'dart:ffi';

import 'package:flutter/material.dart';
import '../notification_object.dart';
import '../bloc/notification_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationFormPage extends StatefulWidget {
  final NotificationObject? notification;

  const NotificationFormPage({super.key, this.notification});

  @override
  _NotificationFormPageState createState() => _NotificationFormPageState();
}

class _NotificationFormPageState extends State<NotificationFormPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime? _selectedDate;
  late TimeOfDay? _selectedTime;
  late bool isNew;
  String? selectedTag; // Состояние для хранения выбранного тега
  List<String> tags = [
    'Акция',
    'Мероприятие',
    'Напоминание',
    'Персональная рекомендация'
  ]; // Список доступных тегов

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.notification?.title);
    _descriptionController =
        TextEditingController(text: widget.notification?.description);
    _selectedDate = widget.notification?.dateTime;
    _selectedTime =
        _selectedDate != null ? TimeOfDay.fromDateTime(_selectedDate!) : null;

    isNew = widget.notification == null;
    selectedTag = widget.notification?.tag;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScrollIndicator(),
          const SizedBox(height: 16),
          _buildTitleLabel(isNew),
          const SizedBox(height: 26),
          _buildTextField('Название уведомления', _titleController),
          const SizedBox(height: 12),
          _buildTextField('Описание уведомления', _descriptionController),
          const SizedBox(height: 12),
          _buildDateTextField('Дата', _selectedDate),
          const SizedBox(height: 12),
          _buildTimeTextField('Время', _selectedTime),
          const SizedBox(height: 20),
          _buildTagsLabel(),
          const SizedBox(height: 8),
          _buildTagSelection(tags),
          const SizedBox(height: 32),
          if (widget.notification != null)
            _buildTwoButtonsRow()
          else
            _buildAddButton()
        ],
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Center(
        child: Container(
      width: 134,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius:
            BorderRadius.circular(2.5), // Радиус скругления в половину высоты
      ),
    ));
  }

  Widget _buildTagSelection(List<String> tags) {
    return Wrap(
      spacing: 6.0, // Расстояние между элементами
      children: tags.map((tag) {
        return ChoiceChip(
          label: Text(tag),
          selected: selectedTag == tag,
          onSelected: (selected) {
            setState(() {
              selectedTag = selected ? tag : null;
            });
          },
          labelStyle: Theme.of(context).textTheme.titleSmall,
        );
      }).toList(),
    );
  }

  Widget _buildTitleLabel(bool isNew) {
    return Center(
        child: Text(
      isNew ? "Создать уведомление" : "Изменить уведомление",
      style: Theme.of(context).textTheme.headlineMedium,
    ));
  }

  Widget _buildTagsLabel() {
    return Text(
      'Тег уведомления',
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          'Создать',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onPressed: () {
          if (_validateFieldsEmpty()) {
            DateTime selectedDateTime = _buildDateTime();
            if (_validateDatetime(selectedDateTime)) {
              NotificationObject notification = NotificationObject(
                  id: (DateTime.now().millisecondsSinceEpoch / 100000).round(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  tag: selectedTag,
                  dateTime: selectedDateTime);
              context
                  .read<NotificationProvider>()
                  .add(AddNotificationEvent(notification));
              Navigator.pop(context);
            } else {
              _showAlertDialog('Время должно быть больше текущей минуты');
            }
          } else {
            _showAlertDialog('Все поля должны быть заполнены');
          }
        },
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget _buildTwoButtonsRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              child: Text(
                'Сохранить',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                if (_validateFieldsEmpty()) {
                  DateTime selectedDateTime = _buildDateTime();
                  if (_validateDatetime(selectedDateTime)) {
                    context
                        .read<NotificationProvider>()
                        .add(UpdateNotificationEvent(widget.notification!));
                    Navigator.pop(context);
                  } else {
                    _showAlertDialog('Время должно быть больше текущей минуты');
                  }
                } else {
                  _showAlertDialog('Все поля должны быть заполнены');
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              child: Text(
                'Удалить',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () {
                context
                    .read<NotificationProvider>()
                    .add(DeleteNotificationEvent(widget.notification!.id));
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTextField(String labelText, DateTime? selectedDate) {
    return TextField(
      readOnly: true,
      style: Theme.of(context).textTheme.titleMedium,
      controller: TextEditingController(
        text: selectedDate != null
            ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().substring(2)}'
            : '',
      ),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.all(14),
        suffixIcon: Container(
          padding: const EdgeInsets.all(10),
          child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    selectedDate != null ? Colors.grey.withOpacity(0.2) : null,
              ),
              padding: const EdgeInsets.all(8), // Уменьшаем размер круга
              child: Icon(Icons.today_rounded,
                  size: 24,
                  color: Theme.of(context)
                      .primaryIconTheme
                      .color) // Иконка для даты // Иконка для даты
              ),
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildTimeTextField(String labelText, TimeOfDay? selectedTime) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: AbsorbPointer(
        child: TextField(
          readOnly: true,
          style: Theme.of(context).textTheme.titleMedium,
          controller: TextEditingController(
            text: selectedTime != null
                ? '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}'
                : '',
          ),
          decoration: InputDecoration(
            labelText: labelText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            contentPadding: const EdgeInsets.all(14),
            suffixIcon: Container(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedTime != null
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : null,
                ),
                padding: const EdgeInsets.all(8), // Уменьшаем размер круга
                child: Icon(Icons.access_time,
                    color: Theme.of(context)
                        .primaryIconTheme
                        .color), // Иконка для даты
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // Валидация заполнения полей
  bool _validateFieldsEmpty() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null;
  }

  bool _validateDatetime(DateTime selectedDateTime) {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    return selectedDateTime.isAfter(now);
  }

  DateTime _buildDateTime() {
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  // Отображение сообщения в Snackbar
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

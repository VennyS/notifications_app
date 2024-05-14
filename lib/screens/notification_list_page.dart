import 'package:flutter/material.dart';
import 'notification_form_page.dart';
import '../bloc/notification_provider.dart';
import '../notification_object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'УВЕДОМЛЕНИЯ',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: BlocBuilder<NotificationProvider, List<NotificationObject>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return Center(
              child: Text(
                'Уведомлений пока нет',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                  child: Card(
                    color: state[index].isSent
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
                    child: ListTile(
                        title: Text(
                          state[index].title,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        subtitle: Text(state[index].description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.displaySmall),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                        ),
                        onTap: () {
                          _showModalBottomSheet(context, state[index]);
                        }),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add,
            size: Theme.of(context).iconTheme.size,
            color: Theme.of(context).iconTheme.color),
        onPressed: () {
          _showModalBottomSheet(context, null);
        },
      ),
    );
  }

  void _showModalBottomSheet(
      BuildContext context, NotificationObject? notification) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (context) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.8,
              maxChildSize: 0.9,
              builder: (context, scrollController) => SingleChildScrollView(
                controller: scrollController,
                child: NotificationFormPage(notification: notification),
              ),
            ));
  }
}

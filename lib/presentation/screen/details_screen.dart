import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:push_app/domain/entity/push_message.dart';
import 'package:push_app/presentation/bloc/notification/notification_bloc.dart';

class DetailScreen extends StatelessWidget {

  final String pushMessageId;

  const DetailScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {

    final PushMessage? message = context.watch<NotificationBloc>()
      .getMessageId(pushMessageId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles Push'),
      ),
      body: (message != null)
          ? _DetailsView(message: message)
          : const Center(child: Text('Notificación no existe')),
    );
  }
}

class _DetailsView extends StatelessWidget {

  final PushMessage message;

  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (message.imageUrl != null)
            Image.network(message.imageUrl!),

          const SizedBox(height: 30),
          Text(message.title, style: textStyle.titleMedium),
          Text(message.body),

          const Divider(),
          Text(message.data.toString()),
        ],
      ),
    );
  }
}

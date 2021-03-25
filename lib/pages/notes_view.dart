import 'package:flutter/material.dart';
import 'package:teamgram_poc/api/api_service.dart';
import 'package:teamgram_poc/models/domain_model.dart';

class NotesView extends StatelessWidget {
  final List<DomainModel> domains;

  NotesView({Key key, @required this.domains});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: ListView.builder(
          itemCount: domains.length,
          itemBuilder: (context, index) {
            var _domain = domains[index];
            return ListTile(
              title: Text(_domain.displayName),
              onTap: () {
                print(_domain.name);
                APIService apiService = new APIService();
                apiService.saveDomainName(_domain.name);
              },
            );
          }),
    );
  }
}

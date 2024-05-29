import 'package:flutter/material.dart';
import 'package:notlar/components/themenotifier.dart';
import 'package:provider/provider.dart';
import 'package:notlar/pages/homepage/treelines/changepassword.dart';
import '../../../models/User.dart';

class SettingsPage extends StatefulWidget {
  final User user;
  const SettingsPage({Key? key, required this.user}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  double fontSize = 16.0; // Örnek bir yazı tipi boyutu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return ListTile(
                title: Text('Tema Seçimi'),
                subtitle: Text(themeNotifier.isDarkMode
                    ? 'Uygulamanın temasını karanlık moda geçirin'
                    : 'Uygulamanın temasını aydınlık moda geçirin'),
                trailing: IconButton(
                  icon: Icon(themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                  onPressed: () {
                    themeNotifier.toggleTheme();
                  },
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Şifre Değiştir'),
            subtitle: Text('Şifrenizi değiştirmek için tıklayın'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage(user: widget.user)),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Yazı Tipi Boyutu'),
            subtitle: Text('Yazı tipi boyutunu ayarlamak için tıklayın'),
            onTap: () {
              showFontSizeDialog();
            },
          ),
        ],
      ),
    );
  }

  void showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yazı Tipi Boyutu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Yazı tipi boyutunu seçin:'),
              SizedBox(height: 16.0),
              Slider(
                value: fontSize,
                min: 10,
                max: 30,
                divisions: 20,
                onChanged: (newValue) {
                  setState(() {
                    fontSize = newValue;
                  });
                },
              ),
              Text('${fontSize.toStringAsFixed(1)} pt'), // Yazı tipi boyutunu göster
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}

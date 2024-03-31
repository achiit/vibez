import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/enum.dart';
import 'package:flutter_twitter_clone/ui/page/Auth/qrscanner.dart';
import 'package:flutter_twitter_clone/ui/page/Auth/signup.dart';
import 'package:flutter_twitter_clone/state/authState.dart';
import 'package:flutter_twitter_clone/ui/theme/theme.dart';
import 'package:flutter_twitter_clone/widgets/customFlatButton.dart';
import 'package:flutter_twitter_clone/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../homePage.dart';
import 'signin.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? _walletAddress;

  Future<void> connectWallet() async {
    var state = Provider.of<AuthState>(context, listen: false);
    print("hello bhai aaja");
    //Navigate to the signup page and pass the login callback
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Signup(loginCallback: state.getCurrentUser),
    //   ),
    // );
    // Create a connector
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    // Subscribe to events
    connector.on('connect', (session) => print(session));
    connector.on('session_update', (payload) => print(payload));
    connector.on('disconnect', (session) => print(session));

// Create a new session
    if (!connector.connected) {
      final session = await connector.createSession(
        chainId: 4160,
        onDisplayUri: (uri) => print(uri),
      );
    }

    // Create a new session
    if (!connector.connected) {
      try {
        await connector.createSession(
          chainId: 137, // Polygon
        );
      } catch (e) {
        // Handle error creating session
        print('Error creating session: $e');
        throw Exception('Failed to create session: $e');
      }
    }
  }

  Widget _submitButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: CustomFlatButton(
        label: "Scan QR",
        onPressed: () async {
          var state = Provider.of<AuthState>(context, listen: false);
          print("started");
          try {
            // Connect to MetaMask
            //await connectWallet();

            //Navigate to the signup page and pass the login callback
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         Signup(loginCallback: state.getCurrentUser),
            //   ),
            // );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScanPage()),
            );
          } catch (e) {
            // Handle error connecting to MetaMask
            print('Error connecting to MetaMask: $e');
            // You can show a snackbar or dialog to inform the user about the error.
          }
        },
        borderRadius: 30,
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              height: 40,
              child: Image.asset('assets/images/icon-480.png'),
            ),
            const Spacer(),
            const TitleText(
              'Scan the QR recieved on ANON Aadhar.',
              fontSize: 25,
            ),
            const SizedBox(
              height: 20,
            ),
            _submitButton(),
            // ElevatedButton(onPressed: connectWallet, child: Text("Connect")),
            const Spacer(),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                const TitleText(
                  'Have an account already?',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                InkWell(
                  onTap: () {
                    var state = Provider.of<AuthState>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignIn(loginCallback: state.getCurrentUser),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: TitleText(
                      ' Log in',
                      fontSize: 14,
                      color: TwitterColor.dodgeBlue,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_LOGGED_IN ||
              state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : const HomePage(),
    );
  }
}

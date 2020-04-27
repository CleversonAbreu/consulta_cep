import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:toast/toast.dart';
import 'Cep.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _cep='';
  TextEditingController _controllerCep = new MaskedTextController(mask: '00000-000');

  void _recuperarCep() async{
    String cepRetornado = _controllerCep.text;
    if(cepRetornado!='') {
      String envelope =
          "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
              +
              "xmlns:cli=\"http://cliente.bean.master.sigep.bsb.correios.com.br/\">"
              + "<soapenv:Header/>"
              + "<soapenv:Body>"
              + "<cli:consultaCEP>"
              + "<cep>" + cepRetornado + "</cep>"
              + "</cli:consultaCEP>"
              + "</soapenv:Body>"
              + "</soapenv:Envelope>";

      final response = await http.post(
        "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl",
        headers: {"Content-Type": "text/xml",},
        body: envelope,
      );

      Cep cep = Cep(xml.parse(response.body).findAllElements("soap:Body"));

      setState(() {
        if (cep.erro != null) {
          _cep =' ';
          Toast.show('Cep não encontrado', context,  backgroundColor: Colors.red,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        } else {
          _cep =
              "ENDEREÇO :\n" + cep.end + '\n' + cep.bairro + '\n' + cep.cidade +
                  '/' + cep.uf;
        }
      });
    }else{
      Toast.show("Preencha o CEP", context, backgroundColor: Colors.red, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(35),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset("img/correios_logo.jpg"),
                TextField(
                  maxLength: 9,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'CEP'
                  ),
                  controller: _controllerCep,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton(
                    child: Text(
                        'Consultar',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        )
                    ),
                    color: Colors.orange,
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                    onPressed: _recuperarCep,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20,bottom: 30),
                  child: Text(_cep,
                    style: TextStyle(
                        fontSize: 20
                    ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:xml/xml.dart' as xml;

class Cep{

  String erro;
  String end;
  String bairro;
  String cidade;
  String uf;

  Cep(Iterable<xml.XmlElement> endereco){
    try{
      erro = endereco.first.findAllElements("faultstring").first.text;
    }catch(e){
      end          = endereco.first.findAllElements("end").first.text;
      bairro       = endereco.first.findAllElements("bairro").first.text;
      cidade       = endereco.first.findAllElements("cidade").first.text;
      uf           = endereco.first.findAllElements("uf").first.text;
    }
  }
}
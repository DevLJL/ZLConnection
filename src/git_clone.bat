@echo off

set vendor_path=%cd%\Vendor

if not exist %vendor_path% (
  echo Criando a pasta Vendor em branco...
  mkdir %vendor_path%
)

echo Clonando o repositório do Git dentro da pasta Vendor...
git clone https://github.com/viniciussanchez/dataset-serialize.git %vendor_path%\DataSetSerialize


echo Tudo pronto!

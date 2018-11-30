<?xml version="1.0" encoding="UTF-8"?>
<!-- generated with COPASI 4.24 (Build 197) (http://www.copasi.org) at 2018-11-30 13:18:54 UTC -->
<?oxygen RNGSchema="http://www.copasi.org/static/schema/CopasiML.rng" type="xml"?>
<COPASI xmlns="http://www.copasi.org/static/schema" versionMajor="4" versionMinor="24" versionDevel="197" copasiSourcesModified="0">
  <ListOfFunctions>
    <Function key="Function_39" name="Function for v_1" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv0/KMoutv0*(Glcout-Glcin/Keqv0)/(1+Glcout/KMoutv0+Glcin/KMinv0+alfav0*Glcout*Glcin/KMoutv0/KMinv0)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_268" name="Glcin" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_269" name="Glcout" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_270" name="KMinv0" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_271" name="KMoutv0" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_272" name="Keqv0" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_273" name="Vmaxv0" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_274" name="alfav0" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_275" name="default_compartment" order="7" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_40" name="Function for v_10" type="UserDefined" reversible="unspecified">
      <Expression>
        Vmaxv9*(Gri23P2f+MgGri23P2-Gri3P/Keqv9)/(Gri23P2f+MgGri23P2+K23P2Gv9)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_261" name="Gri23P2f" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_284" name="Gri3P" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_285" name="K23P2Gv9" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_286" name="Keqv9" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_287" name="MgGri23P2" order="4" role="modifier"/>
        <ParameterDescription key="FunctionParameter_288" name="Vmaxv9" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_289" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_41" name="Function for v_11" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv10*(Gri3P-Gri2P/Keqv10)/(Gri3P+K3PGv10*(1+Gri2P/K2PGv10))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_297" name="Gri2P" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_298" name="Gri3P" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_299" name="K2PGv10" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_300" name="K3PGv10" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_301" name="Keqv10" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_302" name="Vmaxv10" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_303" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_42" name="Function for v_12" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv11*(Gri2P-PEP/Keqv11)/(Gri2P+K2PGv11*(1+PEP/KPEPv11))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_311" name="Gri2P" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_312" name="K2PGv11" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_313" name="KPEPv11" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_314" name="Keqv11" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_315" name="PEP" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_316" name="Vmaxv11" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_317" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_43" name="Function for v_13" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv12*(PEP*MgADP-Pyr*MgATP/Keqv12)/((PEP+KPEPv12)*(MgADP+KMgADPv12)*(1+L0v12*(1+(ATPf+MgATP)/KATPv12)^4/((1+PEP/KPEPv12)^4*(1+Fru16P2/KFru16P2v12)^4)))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_332" name="ATPf" order="0" role="modifier"/>
        <ParameterDescription key="FunctionParameter_333" name="Fru16P2" order="1" role="modifier"/>
        <ParameterDescription key="FunctionParameter_334" name="KATPv12" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_335" name="KFru16P2v12" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_336" name="KMgADPv12" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_337" name="KPEPv12" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_338" name="Keqv12" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_339" name="L0v12" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_340" name="MgADP" order="8" role="substrate"/>
        <ParameterDescription key="FunctionParameter_341" name="MgATP" order="9" role="product"/>
        <ParameterDescription key="FunctionParameter_342" name="PEP" order="10" role="substrate"/>
        <ParameterDescription key="FunctionParameter_343" name="Pyr" order="11" role="product"/>
        <ParameterDescription key="FunctionParameter_344" name="Vmaxv12" order="12" role="constant"/>
        <ParameterDescription key="FunctionParameter_345" name="default_compartment" order="13" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_44" name="Function for v_14" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv13*(Pyr*NADH-Lac*NAD/Keqv13)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_250" name="Keqv13" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_262" name="Lac" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_325" name="NAD" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_330" name="NADH" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_328" name="Pyr" order="4" role="substrate"/>
        <ParameterDescription key="FunctionParameter_329" name="Vmaxv13" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_327" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_45" name="Function for v_15" type="UserDefined" reversible="true">
      <Expression>
        kLDHv14*(Pyr*NADPHf-Lac*NADPf/Keqv14)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_367" name="Keqv14" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_368" name="Lac" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_369" name="NADPHf" order="2" role="substrate"/>
        <ParameterDescription key="FunctionParameter_370" name="NADPf" order="3" role="product"/>
        <ParameterDescription key="FunctionParameter_371" name="Pyr" order="4" role="substrate"/>
        <ParameterDescription key="FunctionParameter_372" name="default_compartment" order="5" role="volume"/>
        <ParameterDescription key="FunctionParameter_373" name="kLDHv14" order="6" role="constant"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_46" name="Function for v_16" type="UserDefined" reversible="unspecified">
      <Expression>
        kATPasev15*MgATP/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_267" name="MgATP" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_264" name="default_compartment" order="1" role="volume"/>
        <ParameterDescription key="FunctionParameter_265" name="kATPasev15" order="2" role="constant"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_47" name="Function for v_17" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv16/(KATPv16*KAMPv16)*(MgATP*AMPf-MgADP*ADPf/Keqv16)/((1+MgATP/KATPv16)*(1+AMPf/KAMPv16)+(MgADP+ADPf)/KADPv16+MgADP*ADPf/KADPv16^2)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_390" name="ADPf" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_391" name="AMPf" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_392" name="KADPv16" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_393" name="KAMPv16" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_394" name="KATPv16" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_395" name="Keqv16" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_396" name="MgADP" order="6" role="product"/>
        <ParameterDescription key="FunctionParameter_397" name="MgATP" order="7" role="substrate"/>
        <ParameterDescription key="FunctionParameter_398" name="Vmaxv16" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_399" name="default_compartment" order="9" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_48" name="Function for v_18" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv17/KG6Pv17/KNADPv17*(Glc6P*NADPf-GlcA6P*NADPHf/Keqv17)/(1+NADPf*(1+Glc6P/KG6Pv17)/KNADPv17+(ATPf+MgATP)/KATPv17+NADPHf/KNADPHv17+(Gri23P2f+MgGri23P2)/KPGA23v17)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_416" name="ATPf" order="0" role="modifier"/>
        <ParameterDescription key="FunctionParameter_417" name="Glc6P" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_418" name="GlcA6P" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_419" name="Gri23P2f" order="3" role="modifier"/>
        <ParameterDescription key="FunctionParameter_420" name="KATPv17" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_421" name="KG6Pv17" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_422" name="KNADPHv17" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_423" name="KNADPv17" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_424" name="KPGA23v17" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_425" name="Keqv17" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_426" name="MgATP" order="10" role="modifier"/>
        <ParameterDescription key="FunctionParameter_427" name="MgGri23P2" order="11" role="modifier"/>
        <ParameterDescription key="FunctionParameter_428" name="NADPHf" order="12" role="product"/>
        <ParameterDescription key="FunctionParameter_429" name="NADPf" order="13" role="substrate"/>
        <ParameterDescription key="FunctionParameter_430" name="Vmaxv17" order="14" role="constant"/>
        <ParameterDescription key="FunctionParameter_431" name="default_compartment" order="15" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_49" name="Function for v_19" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv18/K6PG1v18/KNADPv18*(GlcA6P*NADPf-Rul5P*NADPHf/Keqv18)/((1+NADPf/KNADPv18)*(1+GlcA6P/K6PG1v18+(Gri23P2f+MgGri23P2)/KPGA23v18)+(ATPf+MgATP)/KATPv18+NADPHf*(1+GlcA6P/K6PG2v18)/KNADPHv18)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_449" name="ATPf" order="0" role="modifier"/>
        <ParameterDescription key="FunctionParameter_450" name="GlcA6P" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_451" name="Gri23P2f" order="2" role="modifier"/>
        <ParameterDescription key="FunctionParameter_452" name="K6PG1v18" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_453" name="K6PG2v18" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_454" name="KATPv18" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_455" name="KNADPHv18" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_456" name="KNADPv18" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_457" name="KPGA23v18" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_458" name="Keqv18" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_459" name="MgATP" order="10" role="modifier"/>
        <ParameterDescription key="FunctionParameter_460" name="MgGri23P2" order="11" role="modifier"/>
        <ParameterDescription key="FunctionParameter_461" name="NADPHf" order="12" role="product"/>
        <ParameterDescription key="FunctionParameter_462" name="NADPf" order="13" role="substrate"/>
        <ParameterDescription key="FunctionParameter_463" name="Rul5P" order="14" role="product"/>
        <ParameterDescription key="FunctionParameter_464" name="Vmaxv18" order="15" role="constant"/>
        <ParameterDescription key="FunctionParameter_465" name="default_compartment" order="16" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_50" name="Function for v_2" type="UserDefined" reversible="true">
      <Expression>
        Inhibv1*Glcin/(Glcin+KMGlcv1)*(Vmax1v1/KMgATPv1)*(MgATP+Vmax2v1/Vmax1v1*MgATP*Mgf/KMgATPMgv1-Glc6P*MgADP/Keqv1)/(1+MgATP/KMgATPv1*(1+Mgf/KMgATPMgv1)+Mgf/KMgv1+(1.55+Glc6P/KGlc6Pv1)*(1+Mgf/KMgv1)+(Gri23P2f+MgGri23P2)/K23P2Gv1+Mgf*(Gri23P2f+MgGri23P2)/(KMgv1*KMg23P2Gv1))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_485" name="Glc6P" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_486" name="Glcin" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_487" name="Gri23P2f" order="2" role="modifier"/>
        <ParameterDescription key="FunctionParameter_488" name="Inhibv1" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_489" name="K23P2Gv1" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_490" name="KGlc6Pv1" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_491" name="KMGlcv1" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_492" name="KMg23P2Gv1" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_493" name="KMgATPMgv1" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_494" name="KMgATPv1" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_495" name="KMgv1" order="10" role="constant"/>
        <ParameterDescription key="FunctionParameter_496" name="Keqv1" order="11" role="constant"/>
        <ParameterDescription key="FunctionParameter_497" name="MgADP" order="12" role="product"/>
        <ParameterDescription key="FunctionParameter_498" name="MgATP" order="13" role="substrate"/>
        <ParameterDescription key="FunctionParameter_499" name="MgGri23P2" order="14" role="modifier"/>
        <ParameterDescription key="FunctionParameter_500" name="Mgf" order="15" role="modifier"/>
        <ParameterDescription key="FunctionParameter_501" name="Vmax1v1" order="16" role="constant"/>
        <ParameterDescription key="FunctionParameter_502" name="Vmax2v1" order="17" role="constant"/>
        <ParameterDescription key="FunctionParameter_503" name="default_compartment" order="18" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_51" name="Function for v_20" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv19*(GSSG*NADPHf/(KGSSGv19*KNADPHv19)-GSH^2/KGSHv19^2*NADPf/(KNADPv19*Keqv19))/(1+NADPHf*(1+GSSG/KGSSGv19)/KNADPHv19+NADPf/KNADPv19*(1+GSH*(1+GSH/KGSHv19)/KGSHv19))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_483" name="GSH" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_386" name="GSSG" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_389" name="KGSHv19" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_410" name="KGSSGv19" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_448" name="KNADPHv19" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_383" name="KNADPv19" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_415" name="Keqv19" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_387" name="NADPHf" order="7" role="substrate"/>
        <ParameterDescription key="FunctionParameter_523" name="NADPf" order="8" role="product"/>
        <ParameterDescription key="FunctionParameter_524" name="Vmaxv19" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_525" name="default_compartment" order="10" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_52" name="Function for v_21" type="UserDefined" reversible="unspecified">
      <Expression>
        Kv20*GSH/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_413" name="GSH" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_388" name="Kv20" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_385" name="default_compartment" order="2" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_53" name="Function for v_22" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv21*(Rul5P-Xul5P/Keqv21)/(Rul5P+KRu5Pv21*(1+Xul5P/KX5Pv21))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_539" name="KRu5Pv21" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_540" name="KX5Pv21" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_541" name="Keqv21" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_542" name="Rul5P" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_543" name="Vmaxv21" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_544" name="Xul5P" order="5" role="product"/>
        <ParameterDescription key="FunctionParameter_545" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_54" name="Function for v_23" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv22*(Rul5P-Rib5P/Keqv22)/(Rul5P+KRu5Pv22*(1+Rib5P/KR5Pv22))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_553" name="KR5Pv22" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_554" name="KRu5Pv22" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_555" name="Keqv22" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_556" name="Rib5P" order="3" role="product"/>
        <ParameterDescription key="FunctionParameter_557" name="Rul5P" order="4" role="substrate"/>
        <ParameterDescription key="FunctionParameter_558" name="Vmaxv22" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_559" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_55" name="Function for v_24" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv23*(Rib5P*Xul5P-GraP*Sed7P/Keqv23)/((K1v23+Rib5P)*Xul5P+(K2v23+K6v23*Sed7P)*Rib5P+(K3v23+K5v23*Sed7P)*GraP+K4v23*Sed7P+K7v23*Xul5P*GraP)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_574" name="GraP" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_575" name="K1v23" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_576" name="K2v23" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_577" name="K3v23" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_578" name="K4v23" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_579" name="K5v23" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_580" name="K6v23" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_581" name="K7v23" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_582" name="Keqv23" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_583" name="Rib5P" order="9" role="substrate"/>
        <ParameterDescription key="FunctionParameter_584" name="Sed7P" order="10" role="product"/>
        <ParameterDescription key="FunctionParameter_585" name="Vmaxv23" order="11" role="constant"/>
        <ParameterDescription key="FunctionParameter_586" name="Xul5P" order="12" role="substrate"/>
        <ParameterDescription key="FunctionParameter_587" name="default_compartment" order="13" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_56" name="Function for v_25" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv24*(Sed7P*GraP-E4P*Fru6P/Keqv24)/((K1v24+GraP)*Sed7P+(K2v24+K6v24*Fru6P)*GraP+(K3v24+K5v24*Fru6P)*E4P+K4v24*Fru6P+K7v24*Sed7P*E4P)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_602" name="E4P" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_603" name="Fru6P" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_604" name="GraP" order="2" role="substrate"/>
        <ParameterDescription key="FunctionParameter_605" name="K1v24" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_606" name="K2v24" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_607" name="K3v24" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_608" name="K4v24" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_609" name="K5v24" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_610" name="K6v24" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_611" name="K7v24" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_612" name="Keqv24" order="10" role="constant"/>
        <ParameterDescription key="FunctionParameter_613" name="Sed7P" order="11" role="substrate"/>
        <ParameterDescription key="FunctionParameter_614" name="Vmaxv24" order="12" role="constant"/>
        <ParameterDescription key="FunctionParameter_615" name="default_compartment" order="13" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_57" name="Function for v_26" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv25*(Rib5P*MgATP-PRPP*MgAMP/Keqv25)/((KATPv25+MgATP)*(KR5Pv25+Rib5P))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_568" name="KATPv25" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_572" name="KR5Pv25" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_411" name="Keqv25" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_538" name="MgAMP" order="3" role="product"/>
        <ParameterDescription key="FunctionParameter_326" name="MgATP" order="4" role="substrate"/>
        <ParameterDescription key="FunctionParameter_630" name="PRPP" order="5" role="product"/>
        <ParameterDescription key="FunctionParameter_631" name="Rib5P" order="6" role="substrate"/>
        <ParameterDescription key="FunctionParameter_632" name="Vmaxv25" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_633" name="default_compartment" order="8" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_58" name="Function for v_27" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv26*(E4P*Xul5P-GraP*Fru6P/Keqv26)/((K1v26+E4P)*Xul5P+(K2v26+K6v26*Fru6P)*E4P+(K3v26+K5v26*Fru6P)*GraP+K4v26*Fru6P+K7v26*Xul5P*GraP)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_648" name="E4P" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_649" name="Fru6P" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_650" name="GraP" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_651" name="K1v26" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_652" name="K2v26" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_653" name="K3v26" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_654" name="K4v26" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_655" name="K5v26" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_656" name="K6v26" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_657" name="K7v26" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_658" name="Keqv26" order="10" role="constant"/>
        <ParameterDescription key="FunctionParameter_659" name="Vmaxv26" order="11" role="constant"/>
        <ParameterDescription key="FunctionParameter_660" name="Xul5P" order="12" role="substrate"/>
        <ParameterDescription key="FunctionParameter_661" name="default_compartment" order="13" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_59" name="Function for v_28" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv27*(Phiex-Phi/Keqv27)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_569" name="Keqv27" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_644" name="Phi" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_645" name="Phiex" order="2" role="substrate"/>
        <ParameterDescription key="FunctionParameter_643" name="Vmaxv27" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_567" name="default_compartment" order="4" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_60" name="Function for v_29" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv28*(Lacex-Lac/Keqv28)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_677" name="Keqv28" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_678" name="Lac" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_679" name="Lacex" order="2" role="substrate"/>
        <ParameterDescription key="FunctionParameter_680" name="Vmaxv28" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_681" name="default_compartment" order="4" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_61" name="Function for v_3" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv2*(Glc6P-Fru6P/Keqv2)/(Glc6P+KGlc6Pv2*(1+Fru6P/KFru6Pv2))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_689" name="Fru6P" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_690" name="Glc6P" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_691" name="KFru6Pv2" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_692" name="KGlc6Pv2" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_693" name="Keqv2" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_694" name="Vmaxv2" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_695" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_62" name="Function for v_30" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv29*(Pyrex-Pyr/Keqv29)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_646" name="Keqv29" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_647" name="Pyr" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_703" name="Pyrex" order="2" role="substrate"/>
        <ParameterDescription key="FunctionParameter_704" name="Vmaxv29" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_705" name="default_compartment" order="4" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_63" name="Function for v_31" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(MgATP-Mgf*ATPf/KdATP)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_712" name="ATPf" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_713" name="EqMult" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_714" name="KdATP" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_715" name="MgATP" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_716" name="Mgf" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_717" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_64" name="Function for v_32" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(MgADP-Mgf*ADPf/KdADP)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_724" name="ADPf" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_725" name="EqMult" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_726" name="KdADP" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_727" name="MgADP" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_728" name="Mgf" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_729" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_65" name="Function for v_33" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(MgAMP-Mgf*AMPf/KdAMP)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_736" name="AMPf" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_737" name="EqMult" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_738" name="KdAMP" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_739" name="MgAMP" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_740" name="Mgf" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_741" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_66" name="Function for v_34" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(MgGri23P2-Mgf*Gri23P2f/Kd23P2G)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_748" name="EqMult" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_749" name="Gri23P2f" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_750" name="Kd23P2G" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_751" name="MgGri23P2" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_752" name="Mgf" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_753" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_67" name="Function for v_35" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(P1NADP-P1f*NADPf/Kd1)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_760" name="EqMult" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_761" name="Kd1" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_762" name="NADPf" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_763" name="P1NADP" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_764" name="P1f" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_765" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_68" name="Function for v_36" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(P1NADPH-P1f*NADPHf/Kd3)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_772" name="EqMult" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_773" name="Kd3" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_774" name="NADPHf" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_775" name="P1NADPH" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_776" name="P1f" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_777" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_69" name="Function for v_37" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(P2NADP-P2f*NADPf/Kd2)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_784" name="EqMult" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_785" name="Kd2" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_786" name="NADPf" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_787" name="P2NADP" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_788" name="P2f" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_789" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_70" name="Function for v_38" type="UserDefined" reversible="true">
      <Expression>
        EqMult*(P2NADPH-P2f*NADPHf/Kd4)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_796" name="EqMult" order="0" role="constant"/>
        <ParameterDescription key="FunctionParameter_797" name="Kd4" order="1" role="constant"/>
        <ParameterDescription key="FunctionParameter_798" name="NADPHf" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_799" name="P2NADPH" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_800" name="P2f" order="4" role="product"/>
        <ParameterDescription key="FunctionParameter_801" name="default_compartment" order="5" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_71" name="Function for v_4" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv3*(Fru6P*MgATP-Fru16P2*MgADP/Keqv3)/((Fru6P+KFru6Pv3)*(MgATP+KMgATPv3)*(1+L0v3*((1+ATPf/KATPv3)*(1+Mgf/KMgv3)/((1+(AMPf+MgAMP)/KAMPv3)*(1+Fru6P/KFru6Pv3)))^4))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_819" name="AMPf" order="0" role="modifier"/>
        <ParameterDescription key="FunctionParameter_820" name="ATPf" order="1" role="modifier"/>
        <ParameterDescription key="FunctionParameter_821" name="Fru16P2" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_822" name="Fru6P" order="3" role="substrate"/>
        <ParameterDescription key="FunctionParameter_823" name="KAMPv3" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_824" name="KATPv3" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_825" name="KFru6Pv3" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_826" name="KMgATPv3" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_827" name="KMgv3" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_828" name="Keqv3" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_829" name="L0v3" order="10" role="constant"/>
        <ParameterDescription key="FunctionParameter_830" name="MgADP" order="11" role="product"/>
        <ParameterDescription key="FunctionParameter_831" name="MgAMP" order="12" role="modifier"/>
        <ParameterDescription key="FunctionParameter_832" name="MgATP" order="13" role="substrate"/>
        <ParameterDescription key="FunctionParameter_833" name="Mgf" order="14" role="modifier"/>
        <ParameterDescription key="FunctionParameter_834" name="Vmaxv3" order="15" role="constant"/>
        <ParameterDescription key="FunctionParameter_835" name="default_compartment" order="16" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_72" name="Function for v_5" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv4/KFru16P2v4*(Fru16P2-GraP*DHAP/Keqv4)/(1+Fru16P2/KFru16P2v4+GraP/KiGraPv4+DHAP*(GraP+KGraPv4)/(KDHAPv4*KiGraPv4)+Fru16P2*GraP/(KFru16P2v4*KiiGraPv4))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_812" name="DHAP" order="0" role="product"/>
        <ParameterDescription key="FunctionParameter_817" name="Fru16P2" order="1" role="substrate"/>
        <ParameterDescription key="FunctionParameter_688" name="GraP" order="2" role="product"/>
        <ParameterDescription key="FunctionParameter_573" name="KDHAPv4" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_811" name="KFru16P2v4" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_815" name="KGraPv4" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_853" name="Keqv4" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_854" name="KiGraPv4" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_855" name="KiiGraPv4" order="8" role="constant"/>
        <ParameterDescription key="FunctionParameter_856" name="Vmaxv4" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_857" name="default_compartment" order="10" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_73" name="Function for v_6" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv5*(DHAP-GraP/Keqv5)/(DHAP+KDHAPv5*(1+GraP/KGraPv5))/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_814" name="DHAP" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_537" name="GraP" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_813" name="KDHAPv5" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_816" name="KGraPv5" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_869" name="Keqv5" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_870" name="Vmaxv5" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_871" name="default_compartment" order="6" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_74" name="Function for v_7" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv6/(KNADv6*KGraPv6*KPv6)*(NAD*GraP*Phi-Gri13P2*NADH/Keqv6)/((1+NAD/KNADv6)*(1+GraP/KGraPv6)*(1+Phi/KPv6)+(1+NADH/KNADHv6)*(1+Gri13P2/K13P2Gv6)-1)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_885" name="GraP" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_886" name="Gri13P2" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_887" name="K13P2Gv6" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_888" name="KGraPv6" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_889" name="KNADHv6" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_890" name="KNADv6" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_891" name="KPv6" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_892" name="Keqv6" order="7" role="constant"/>
        <ParameterDescription key="FunctionParameter_893" name="NAD" order="8" role="substrate"/>
        <ParameterDescription key="FunctionParameter_894" name="NADH" order="9" role="product"/>
        <ParameterDescription key="FunctionParameter_895" name="Phi" order="10" role="substrate"/>
        <ParameterDescription key="FunctionParameter_896" name="Vmaxv6" order="11" role="constant"/>
        <ParameterDescription key="FunctionParameter_897" name="default_compartment" order="12" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_75" name="Function for v_8" type="UserDefined" reversible="true">
      <Expression>
        Vmaxv7/(KMgADPv7*K13P2Gv7)*(MgADP*Gri13P2-MgATP*Gri3P/Keqv7)/((1+MgADP/KMgADPv7)*(1+Gri13P2/K13P2Gv7)+(1+MgATP/KMgATPv7)*(1+Gri3P/K3PGv7)-1)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_879" name="Gri13P2" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_809" name="Gri3P" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_911" name="K13P2Gv7" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_912" name="K3PGv7" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_913" name="KMgADPv7" order="4" role="constant"/>
        <ParameterDescription key="FunctionParameter_914" name="KMgATPv7" order="5" role="constant"/>
        <ParameterDescription key="FunctionParameter_915" name="Keqv7" order="6" role="constant"/>
        <ParameterDescription key="FunctionParameter_916" name="MgADP" order="7" role="substrate"/>
        <ParameterDescription key="FunctionParameter_917" name="MgATP" order="8" role="product"/>
        <ParameterDescription key="FunctionParameter_918" name="Vmaxv7" order="9" role="constant"/>
        <ParameterDescription key="FunctionParameter_919" name="default_compartment" order="10" role="volume"/>
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_76" name="Function for v_9" type="UserDefined" reversible="true">
      <Expression>
        kDPGMv8*(Gri13P2-(Gri23P2f+MgGri23P2)/Keqv8)/(1+(Gri23P2f+MgGri23P2)/K23P2Gv8)/default_compartment
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_810" name="Gri13P2" order="0" role="substrate"/>
        <ParameterDescription key="FunctionParameter_818" name="Gri23P2f" order="1" role="product"/>
        <ParameterDescription key="FunctionParameter_571" name="K23P2Gv8" order="2" role="constant"/>
        <ParameterDescription key="FunctionParameter_711" name="Keqv8" order="3" role="constant"/>
        <ParameterDescription key="FunctionParameter_931" name="MgGri23P2" order="4" role="modifier"/>
        <ParameterDescription key="FunctionParameter_932" name="default_compartment" order="5" role="volume"/>
        <ParameterDescription key="FunctionParameter_933" name="kDPGMv8" order="6" role="constant"/>
      </ListOfParameterDescriptions>
    </Function>
  </ListOfFunctions>
  <Model key="Model_1" name="holzhutter" simulationType="time" timeUnit="s" volumeUnit="l" areaUnit="m²" lengthUnit="m" quantityUnit="mol" type="deterministic" avogadroConstant="6.0221417899999999e+23">
    <ListOfCompartments>
      <Compartment key="Compartment_0" name="default_compartment" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#' xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:dcterms='http://purl.org/dc/terms/' xmlns:vCard='http://www.w3.org/2001/vcard-rdf/3.0#' xmlns:bqbiol='http://biomodels.net/biology-qualifiers/' xmlns:bqmodel='http://biomodels.net/model-qualifiers/'>  <rdf:Description rdf:about='#Compartment_0'>
    <bqmodel:is>
      <rdf:Bag>
        <rdf:li rdf:resource='http://identifiers.org/biomodels.sbo/SBO:0000410' />
      </rdf:Bag>
    </bqmodel:is>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Compartment>
    </ListOfCompartments>
    <ListOfMetabolites>
      <Metabolite key="Metabolite_0" name="ADPf" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_0">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00008"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_1" name="AMPf" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_1">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00020"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_2" name="ATPf" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_2">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00002"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_3" name="DHAP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_3">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00111"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_4" name="E4P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_4">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00279"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_5" name="Fru16P2" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_5">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00354"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_6" name="Fru6P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_6">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00085"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_7" name="GSH" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_7">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00051"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_8" name="GSSG" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_8">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00127"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_9" name="Glc6P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_9">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00092"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_10" name="GlcA6P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_11" name="Glcin" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_11">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00092"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_12" name="Glcout" simulationType="fixed" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_12">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00293"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_13" name="GraP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_14" name="Gri13P2" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_14">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00236"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_15" name="Gri23P2f" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_15">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C01159"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_16" name="Gri2P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_16">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00631"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_17" name="Gri3P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_17">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00197"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_18" name="Lac" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_18">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C01432"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_19" name="Lacex" simulationType="fixed" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_19">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C01432"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_20" name="MgADP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_21" name="MgAMP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_22" name="MgATP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_23" name="MgGri23P2" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_24" name="Mgf" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_24">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00305"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_25" name="NAD" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_25">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00003"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_26" name="NADH" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_26">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00004"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_27" name="NADPHf" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_27">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00005"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_28" name="NADPf" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_28">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00006"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_29" name="P1NADP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_29">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00006"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_30" name="P1NADPH" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_30">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00005"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_31" name="P1f" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_32" name="P2NADP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_32">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00006"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_33" name="P2NADPH" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_33">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00005"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_34" name="P2f" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_35" name="PEP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_35">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00074"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_36" name="PRPP" simulationType="fixed" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_37" name="Phi" simulationType="reactions" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_38" name="Phiex" simulationType="fixed" compartment="Compartment_0" addNoise="false">
      </Metabolite>
      <Metabolite key="Metabolite_39" name="Pyr" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_39">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00022"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_40" name="Pyrex" simulationType="fixed" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_40">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00022"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_41" name="Rib5P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_41">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00117"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_42" name="Rul5P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_42">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C00199"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_43" name="Sed7P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_43">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C05382"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_44" name="Xul5P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF
   xmlns:CopasiMT="http://www.copasi.org/RDF/MiriamTerms#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description rdf:about="#Metabolite_44">
    <CopasiMT:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/kegg.compound/C03291"/>
      </rdf:Bag>
    </CopasiMT:is>
  </rdf:Description>
</rdf:RDF>

        </MiriamAnnotation>
      </Metabolite>
    </ListOfMetabolites>
    <ListOfModelValues>
      <ModelValue key="ModelValue_0" name="KMg23P2Gv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_1" name="KAMPv16" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_2" name="Keqv28" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_3" name="KNADPHv18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_4" name="K1v24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_5" name="K1v26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_6" name="KPGA23v18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_7" name="Vmaxv2" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_8" name="K1v23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_9" name="Inhibv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_10" name="KNADHv6" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_11" name="KNADPHv17" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_12" name="Mgtot" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_13" name="protein1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_14" name="KR5Pv22" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_15" name="KR5Pv25" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_16" name="Keqv19" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_17" name="kDPGMv8" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_18" name="KATPv3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_19" name="KMgATPMgv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_20" name="Keqv4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_21" name="KGlc6Pv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_22" name="KGlc6Pv2" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_23" name="Vmaxv29" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_24" name="Vmaxv28" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_25" name="EqMult" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_26" name="KMinv0" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_27" name="Vmaxv23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_28" name="Vmaxv22" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_29" name="Vmaxv21" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_30" name="Vmaxv27" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_31" name="Vmaxv26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_32" name="Vmaxv25" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_33" name="Vmaxv24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_34" name="K6v24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_35" name="K6v26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_36" name="Vmaxv3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_37" name="Vmaxv4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_38" name="Vmaxv5" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_39" name="KNADPv17" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_40" name="K6v23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_41" name="KNADPv19" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_42" name="KNADPv18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_43" name="KMgADPv12" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_44" name="KATPv12" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_45" name="Keqv24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_46" name="Keqv27" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_47" name="KPGA23v17" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_48" name="KATPv16" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_49" name="KATPv17" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_50" name="Keqv23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_51" name="Keqv22" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_52" name="L0v3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_53" name="KATPv18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_54" name="Vmaxv7" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_55" name="Keqv29" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_56" name="K5v23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_57" name="Keqv2" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_58" name="KGraPv6" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_59" name="KGraPv4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_60" name="KGraPv5" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_61" name="Vmaxv6" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_62" name="Keqv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_63" name="K2PGv10" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_64" name="K2PGv11" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_65" name="Vmaxv9" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_66" name="KMoutv0" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_67" name="K3v23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_68" name="Keqv11" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_69" name="Keqv12" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_70" name="Keqv13" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_71" name="Keqv14" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_72" name="K3v26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_73" name="Keqv16" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_74" name="K3v24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_75" name="Keqv18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_76" name="KMgv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_77" name="KMgv3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_78" name="K2v24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_79" name="K2v26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_80" name="KMgADPv7" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_81" name="Kd23P2G" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_82" name="GStotal" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_83" name="KRu5Pv21" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_84" name="KMGlcv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_85" name="protein2" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_86" name="Vmaxv12" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_87" name="Vmaxv13" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_88" name="Vmaxv10" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_89" name="Vmaxv11" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_90" name="Vmaxv16" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_91" name="Vmaxv17" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_92" name="kLDHv14" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_93" name="Vmaxv18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_94" name="Vmaxv19" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_95" name="Vmaxv0" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_96" name="KX5Pv21" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_97" name="Vmax1v1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_98" name="K3PGv10" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_99" name="KG6Pv17" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_100" name="Kd4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_101" name="K7v26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_102" name="K7v24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_103" name="K7v23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_104" name="Kd1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_105" name="Kd2" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_106" name="Kd3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_107" name="Keqv10" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_108" name="KGSHv19" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_109" name="KDHAPv5" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_110" name="KDHAPv4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_111" name="K4v26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_112" name="K4v24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_113" name="K4v23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_114" name="KFru16P2v4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_115" name="alfav0" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_116" name="KdADP" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_117" name="KdAMP" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_118" name="KMgATPv7" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_119" name="KMgATPv3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_120" name="KiGraPv4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_121" name="KMgATPv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_122" name="Keqv17" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_123" name="KAMPv3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_124" name="KdATP" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_125" name="Keqv6" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_126" name="Keqv7" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_127" name="KNADv6" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_128" name="Keqv5" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_129" name="KNADPHv19" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_130" name="K5v24" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_131" name="Keqv0" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_132" name="K5v26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_133" name="Keqv8" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_134" name="Keqv9" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_135" name="K2v23" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_136" name="KGSSGv19" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_137" name="Kv20" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_138" name="KiiGraPv4" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_139" name="Vmax2v1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_140" name="Keqv3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_141" name="K23P2Gv9" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_142" name="K23P2Gv8" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_143" name="kATPasev15" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_144" name="K23P2Gv1" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_145" name="Atot" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_146" name="KFru6Pv2" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_147" name="KFru6Pv3" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_148" name="Keqv25" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_149" name="K3PGv7" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_150" name="Keqv26" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_151" name="KADPv16" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_152" name="KRu5Pv22" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_153" name="Keqv21" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_154" name="NADPtot" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_155" name="KPv6" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_156" name="K6PG1v18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_157" name="KPEPv11" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_158" name="KPEPv12" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_159" name="K13P2Gv6" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_160" name="K13P2Gv7" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_161" name="NADtot" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_162" name="KFru16P2v12" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_163" name="L0v12" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_164" name="K6PG2v18" simulationType="fixed" addNoise="false">
      </ModelValue>
      <ModelValue key="ModelValue_165" name="KATPv25" simulationType="fixed" addNoise="false">
      </ModelValue>
    </ListOfModelValues>
    <ListOfReactions>
      <Reaction key="Reaction_0" name="v_1" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_12" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_11" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_1026" name="KMinv0" value="6.69602"/>
          <Constant key="Parameter_1025" name="KMoutv0" value="1.7"/>
          <Constant key="Parameter_1024" name="Keqv0" value="0.544869"/>
          <Constant key="Parameter_1023" name="Vmaxv0" value="33.6"/>
          <Constant key="Parameter_1022" name="alfav0" value="0.54"/>
        </ListOfConstants>
        <KineticLaw function="Function_39" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_268">
              <SourceParameter reference="Metabolite_11"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_269">
              <SourceParameter reference="Metabolite_12"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_270">
              <SourceParameter reference="ModelValue_26"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_271">
              <SourceParameter reference="ModelValue_66"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_272">
              <SourceParameter reference="ModelValue_131"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_273">
              <SourceParameter reference="ModelValue_95"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_274">
              <SourceParameter reference="ModelValue_115"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_275">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_1" name="v_10" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_15" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_17" stoichiometry="1"/>
          <Product metabolite="Metabolite_37" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_23" stoichiometry="1"/>
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_1021" name="K23P2Gv9" value="0.130731"/>
          <Constant key="Parameter_1020" name="Keqv9" value="100000"/>
          <Constant key="Parameter_1019" name="Vmaxv9" value="0.53"/>
        </ListOfConstants>
        <KineticLaw function="Function_40" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_261">
              <SourceParameter reference="Metabolite_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_284">
              <SourceParameter reference="Metabolite_17"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_285">
              <SourceParameter reference="ModelValue_141"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_286">
              <SourceParameter reference="ModelValue_134"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_287">
              <SourceParameter reference="Metabolite_23"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_288">
              <SourceParameter reference="ModelValue_65"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_289">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_2" name="v_11" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_17" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_16" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_1018" name="K2PGv10" value="0.81042"/>
          <Constant key="Parameter_1017" name="K3PGv10" value="5"/>
          <Constant key="Parameter_1016" name="Keqv10" value="0.129854"/>
          <Constant key="Parameter_1015" name="Vmaxv10" value="2000"/>
        </ListOfConstants>
        <KineticLaw function="Function_41" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_297">
              <SourceParameter reference="Metabolite_16"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_298">
              <SourceParameter reference="Metabolite_17"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_299">
              <SourceParameter reference="ModelValue_63"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_300">
              <SourceParameter reference="ModelValue_98"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_301">
              <SourceParameter reference="ModelValue_107"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_302">
              <SourceParameter reference="ModelValue_88"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_303">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_3" name="v_12" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_16" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_35" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_1014" name="K2PGv11" value="1"/>
          <Constant key="Parameter_1013" name="KPEPv11" value="1"/>
          <Constant key="Parameter_1012" name="Keqv11" value="1.7"/>
          <Constant key="Parameter_1011" name="Vmaxv11" value="1500"/>
        </ListOfConstants>
        <KineticLaw function="Function_42" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_311">
              <SourceParameter reference="Metabolite_16"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_312">
              <SourceParameter reference="ModelValue_64"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_313">
              <SourceParameter reference="ModelValue_157"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_314">
              <SourceParameter reference="ModelValue_68"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_315">
              <SourceParameter reference="Metabolite_35"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_316">
              <SourceParameter reference="ModelValue_89"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_317">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_4" name="v_13" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_35" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_20" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_39" stoichiometry="1"/>
          <Product metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_2" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_5" stoichiometry="1"/>
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_1010" name="KATPv12" value="3.39"/>
          <Constant key="Parameter_1009" name="KFru16P2v12" value="0.005"/>
          <Constant key="Parameter_1008" name="KMgADPv12" value="0.4388"/>
          <Constant key="Parameter_1007" name="KPEPv12" value="0.135381"/>
          <Constant key="Parameter_1006" name="Keqv12" value="13987.6"/>
          <Constant key="Parameter_1005" name="L0v12" value="13.2222"/>
          <Constant key="Parameter_1004" name="Vmaxv12" value="570"/>
        </ListOfConstants>
        <KineticLaw function="Function_43" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_332">
              <SourceParameter reference="Metabolite_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_333">
              <SourceParameter reference="Metabolite_5"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_334">
              <SourceParameter reference="ModelValue_44"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_335">
              <SourceParameter reference="ModelValue_162"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_336">
              <SourceParameter reference="ModelValue_43"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_337">
              <SourceParameter reference="ModelValue_158"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_338">
              <SourceParameter reference="ModelValue_69"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_339">
              <SourceParameter reference="ModelValue_163"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_340">
              <SourceParameter reference="Metabolite_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_341">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_342">
              <SourceParameter reference="Metabolite_35"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_343">
              <SourceParameter reference="Metabolite_39"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_344">
              <SourceParameter reference="ModelValue_86"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_345">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_5" name="v_14" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_39" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_26" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_18" stoichiometry="1"/>
          <Product metabolite="Metabolite_25" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_1003" name="Keqv13" value="9090"/>
          <Constant key="Parameter_1002" name="Vmaxv13" value="2.8e+06"/>
        </ListOfConstants>
        <KineticLaw function="Function_44" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_250">
              <SourceParameter reference="ModelValue_70"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_262">
              <SourceParameter reference="Metabolite_18"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_325">
              <SourceParameter reference="Metabolite_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_330">
              <SourceParameter reference="Metabolite_26"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_328">
              <SourceParameter reference="Metabolite_39"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_329">
              <SourceParameter reference="ModelValue_87"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_327">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_6" name="v_15" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_39" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_27" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_18" stoichiometry="1"/>
          <Product metabolite="Metabolite_28" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_1001" name="Keqv14" value="14181.8"/>
          <Constant key="Parameter_1000" name="kLDHv14" value="184.693"/>
        </ListOfConstants>
        <KineticLaw function="Function_45" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_367">
              <SourceParameter reference="ModelValue_71"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_368">
              <SourceParameter reference="Metabolite_18"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_369">
              <SourceParameter reference="Metabolite_27"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_370">
              <SourceParameter reference="Metabolite_28"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_371">
              <SourceParameter reference="Metabolite_39"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_372">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_373">
              <SourceParameter reference="ModelValue_92"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_7" name="v_16" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_20" stoichiometry="1"/>
          <Product metabolite="Metabolite_37" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_999" name="kATPasev15" value="1.68"/>
        </ListOfConstants>
        <KineticLaw function="Function_46" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_267">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_264">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_265">
              <SourceParameter reference="ModelValue_143"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_8" name="v_17" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_22" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_1" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_20" stoichiometry="1"/>
          <Product metabolite="Metabolite_0" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_998" name="KADPv16" value="0.0938091"/>
          <Constant key="Parameter_997" name="KAMPv16" value="0.0997994"/>
          <Constant key="Parameter_996" name="KATPv16" value="0.173482"/>
          <Constant key="Parameter_995" name="Keqv16" value="0.25"/>
          <Constant key="Parameter_994" name="Vmaxv16" value="1380"/>
        </ListOfConstants>
        <KineticLaw function="Function_47" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_390">
              <SourceParameter reference="Metabolite_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_391">
              <SourceParameter reference="Metabolite_1"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_392">
              <SourceParameter reference="ModelValue_151"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_393">
              <SourceParameter reference="ModelValue_1"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_394">
              <SourceParameter reference="ModelValue_48"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_395">
              <SourceParameter reference="ModelValue_73"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_396">
              <SourceParameter reference="Metabolite_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_397">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_398">
              <SourceParameter reference="ModelValue_90"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_399">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_9" name="v_18" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_9" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_28" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_10" stoichiometry="1"/>
          <Product metabolite="Metabolite_27" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_2" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_22" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_15" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_23" stoichiometry="1"/>
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_993" name="KATPv17" value="0.749"/>
          <Constant key="Parameter_992" name="KG6Pv17" value="0.0626136"/>
          <Constant key="Parameter_991" name="KNADPHv17" value="0.00312"/>
          <Constant key="Parameter_990" name="KNADPv17" value="0.00354255"/>
          <Constant key="Parameter_989" name="KPGA23v17" value="2.289"/>
          <Constant key="Parameter_988" name="Keqv17" value="2094.23"/>
          <Constant key="Parameter_987" name="Vmaxv17" value="162"/>
        </ListOfConstants>
        <KineticLaw function="Function_48" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_416">
              <SourceParameter reference="Metabolite_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_417">
              <SourceParameter reference="Metabolite_9"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_418">
              <SourceParameter reference="Metabolite_10"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_419">
              <SourceParameter reference="Metabolite_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_420">
              <SourceParameter reference="ModelValue_49"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_421">
              <SourceParameter reference="ModelValue_99"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_422">
              <SourceParameter reference="ModelValue_11"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_423">
              <SourceParameter reference="ModelValue_39"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_424">
              <SourceParameter reference="ModelValue_47"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_425">
              <SourceParameter reference="ModelValue_122"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_426">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_427">
              <SourceParameter reference="Metabolite_23"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_428">
              <SourceParameter reference="Metabolite_27"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_429">
              <SourceParameter reference="Metabolite_28"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_430">
              <SourceParameter reference="ModelValue_91"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_431">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_10" name="v_19" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_10" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_28" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_42" stoichiometry="1"/>
          <Product metabolite="Metabolite_27" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_23" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_15" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_2" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_986" name="K6PG1v18" value="0.01"/>
          <Constant key="Parameter_985" name="K6PG2v18" value="0.0649971"/>
          <Constant key="Parameter_984" name="KATPv18" value="0.204257"/>
          <Constant key="Parameter_983" name="KNADPHv18" value="0.00179121"/>
          <Constant key="Parameter_982" name="KNADPv18" value="0.018"/>
          <Constant key="Parameter_981" name="KPGA23v18" value="0.0994652"/>
          <Constant key="Parameter_980" name="Keqv18" value="141.7"/>
          <Constant key="Parameter_979" name="Vmaxv18" value="1305.31"/>
        </ListOfConstants>
        <KineticLaw function="Function_49" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_449">
              <SourceParameter reference="Metabolite_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_450">
              <SourceParameter reference="Metabolite_10"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_451">
              <SourceParameter reference="Metabolite_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_452">
              <SourceParameter reference="ModelValue_156"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_453">
              <SourceParameter reference="ModelValue_164"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_454">
              <SourceParameter reference="ModelValue_53"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_455">
              <SourceParameter reference="ModelValue_3"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_456">
              <SourceParameter reference="ModelValue_42"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_457">
              <SourceParameter reference="ModelValue_6"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_458">
              <SourceParameter reference="ModelValue_75"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_459">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_460">
              <SourceParameter reference="Metabolite_23"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_461">
              <SourceParameter reference="Metabolite_27"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_462">
              <SourceParameter reference="Metabolite_28"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_463">
              <SourceParameter reference="Metabolite_42"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_464">
              <SourceParameter reference="ModelValue_93"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_465">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_11" name="v_2" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_11" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_9" stoichiometry="1"/>
          <Product metabolite="Metabolite_20" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_24" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_15" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_23" stoichiometry="1"/>
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_978" name="Inhibv1" value="0.839557"/>
          <Constant key="Parameter_977" name="K23P2Gv1" value="3.08883"/>
          <Constant key="Parameter_976" name="KGlc6Pv1" value="0.0045"/>
          <Constant key="Parameter_975" name="KMGlcv1" value="0.0871729"/>
          <Constant key="Parameter_974" name="KMg23P2Gv1" value="6.21128"/>
          <Constant key="Parameter_973" name="KMgATPMgv1" value="1.14"/>
          <Constant key="Parameter_972" name="KMgATPv1" value="0.90739"/>
          <Constant key="Parameter_971" name="KMgv1" value="1.2666"/>
          <Constant key="Parameter_970" name="Keqv1" value="3900"/>
          <Constant key="Parameter_969" name="Vmax1v1" value="15.8"/>
          <Constant key="Parameter_968" name="Vmax2v1" value="33.2"/>
        </ListOfConstants>
        <KineticLaw function="Function_50" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_485">
              <SourceParameter reference="Metabolite_9"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_486">
              <SourceParameter reference="Metabolite_11"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_487">
              <SourceParameter reference="Metabolite_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_488">
              <SourceParameter reference="ModelValue_9"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_489">
              <SourceParameter reference="ModelValue_144"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_490">
              <SourceParameter reference="ModelValue_21"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_491">
              <SourceParameter reference="ModelValue_84"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_492">
              <SourceParameter reference="ModelValue_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_493">
              <SourceParameter reference="ModelValue_19"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_494">
              <SourceParameter reference="ModelValue_121"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_495">
              <SourceParameter reference="ModelValue_76"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_496">
              <SourceParameter reference="ModelValue_62"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_497">
              <SourceParameter reference="Metabolite_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_498">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_499">
              <SourceParameter reference="Metabolite_23"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_500">
              <SourceParameter reference="Metabolite_24"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_501">
              <SourceParameter reference="ModelValue_97"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_502">
              <SourceParameter reference="ModelValue_139"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_503">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_12" name="v_20" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_8" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_27" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_7" stoichiometry="2"/>
          <Product metabolite="Metabolite_28" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_967" name="KGSHv19" value="23.8369"/>
          <Constant key="Parameter_966" name="KGSSGv19" value="0.0652"/>
          <Constant key="Parameter_965" name="KNADPHv19" value="0.00852"/>
          <Constant key="Parameter_964" name="KNADPv19" value="0.0758862"/>
          <Constant key="Parameter_963" name="Keqv19" value="0.94068"/>
          <Constant key="Parameter_962" name="Vmaxv19" value="90"/>
        </ListOfConstants>
        <KineticLaw function="Function_51" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_483">
              <SourceParameter reference="Metabolite_7"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_386">
              <SourceParameter reference="Metabolite_8"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_389">
              <SourceParameter reference="ModelValue_108"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_410">
              <SourceParameter reference="ModelValue_136"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_448">
              <SourceParameter reference="ModelValue_129"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_383">
              <SourceParameter reference="ModelValue_41"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_415">
              <SourceParameter reference="ModelValue_16"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_387">
              <SourceParameter reference="Metabolite_27"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_523">
              <SourceParameter reference="Metabolite_28"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_524">
              <SourceParameter reference="ModelValue_94"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_525">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_13" name="v_21" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_7" stoichiometry="2"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_8" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_961" name="Kv20" value="0.03"/>
        </ListOfConstants>
        <KineticLaw function="Function_52" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_413">
              <SourceParameter reference="Metabolite_7"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_388">
              <SourceParameter reference="ModelValue_137"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_385">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_14" name="v_22" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_42" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_44" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_960" name="KRu5Pv21" value="0.19"/>
          <Constant key="Parameter_959" name="KX5Pv21" value="0.4877"/>
          <Constant key="Parameter_958" name="Keqv21" value="3.73262"/>
          <Constant key="Parameter_957" name="Vmaxv21" value="4634"/>
        </ListOfConstants>
        <KineticLaw function="Function_53" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_539">
              <SourceParameter reference="ModelValue_83"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_540">
              <SourceParameter reference="ModelValue_96"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_541">
              <SourceParameter reference="ModelValue_153"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_542">
              <SourceParameter reference="Metabolite_42"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_543">
              <SourceParameter reference="ModelValue_29"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_544">
              <SourceParameter reference="Metabolite_44"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_545">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_15" name="v_23" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_42" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_41" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_956" name="KR5Pv22" value="2.2"/>
          <Constant key="Parameter_955" name="KRu5Pv22" value="0.78"/>
          <Constant key="Parameter_954" name="Keqv22" value="3"/>
          <Constant key="Parameter_953" name="Vmaxv22" value="730"/>
        </ListOfConstants>
        <KineticLaw function="Function_54" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_553">
              <SourceParameter reference="ModelValue_14"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_554">
              <SourceParameter reference="ModelValue_152"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_555">
              <SourceParameter reference="ModelValue_51"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_556">
              <SourceParameter reference="Metabolite_41"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_557">
              <SourceParameter reference="Metabolite_42"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_558">
              <SourceParameter reference="ModelValue_28"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_559">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_16" name="v_24" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_41" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_44" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_13" stoichiometry="1"/>
          <Product metabolite="Metabolite_43" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_952" name="K1v23" value="0.388009"/>
          <Constant key="Parameter_951" name="K2v23" value="0.312648"/>
          <Constant key="Parameter_950" name="K3v23" value="12.432"/>
          <Constant key="Parameter_949" name="K4v23" value="0.00409559"/>
          <Constant key="Parameter_948" name="K5v23" value="0.41139"/>
          <Constant key="Parameter_947" name="K6v23" value="0.0137717"/>
          <Constant key="Parameter_946" name="K7v23" value="48.8"/>
          <Constant key="Parameter_945" name="Keqv23" value="1.05"/>
          <Constant key="Parameter_944" name="Vmaxv23" value="25.463"/>
        </ListOfConstants>
        <KineticLaw function="Function_55" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_574">
              <SourceParameter reference="Metabolite_13"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_575">
              <SourceParameter reference="ModelValue_8"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_576">
              <SourceParameter reference="ModelValue_135"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_577">
              <SourceParameter reference="ModelValue_67"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_578">
              <SourceParameter reference="ModelValue_113"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_579">
              <SourceParameter reference="ModelValue_56"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_580">
              <SourceParameter reference="ModelValue_40"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_581">
              <SourceParameter reference="ModelValue_103"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_582">
              <SourceParameter reference="ModelValue_50"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_583">
              <SourceParameter reference="Metabolite_41"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_584">
              <SourceParameter reference="Metabolite_43"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_585">
              <SourceParameter reference="ModelValue_27"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_586">
              <SourceParameter reference="Metabolite_44"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_587">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_17" name="v_25" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_43" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_13" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_4" stoichiometry="1"/>
          <Product metabolite="Metabolite_6" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_943" name="K1v24" value="0.00823"/>
          <Constant key="Parameter_942" name="K2v24" value="0.0541213"/>
          <Constant key="Parameter_941" name="K3v24" value="0.199866"/>
          <Constant key="Parameter_940" name="K4v24" value="0.006095"/>
          <Constant key="Parameter_939" name="K5v24" value="0.8683"/>
          <Constant key="Parameter_938" name="K6v24" value="0.492538"/>
          <Constant key="Parameter_937" name="K7v24" value="2.43161"/>
          <Constant key="Parameter_936" name="Keqv24" value="1.05"/>
          <Constant key="Parameter_935" name="Vmaxv24" value="30.4086"/>
        </ListOfConstants>
        <KineticLaw function="Function_56" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_602">
              <SourceParameter reference="Metabolite_4"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_603">
              <SourceParameter reference="Metabolite_6"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_604">
              <SourceParameter reference="Metabolite_13"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_605">
              <SourceParameter reference="ModelValue_4"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_606">
              <SourceParameter reference="ModelValue_78"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_607">
              <SourceParameter reference="ModelValue_74"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_608">
              <SourceParameter reference="ModelValue_112"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_609">
              <SourceParameter reference="ModelValue_130"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_610">
              <SourceParameter reference="ModelValue_34"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_611">
              <SourceParameter reference="ModelValue_102"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_612">
              <SourceParameter reference="ModelValue_45"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_613">
              <SourceParameter reference="Metabolite_43"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_614">
              <SourceParameter reference="ModelValue_33"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_615">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_18" name="v_26" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_41" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_36" stoichiometry="1"/>
          <Product metabolite="Metabolite_21" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_934" name="KATPv25" value="0.03"/>
          <Constant key="Parameter_933" name="KR5Pv25" value="0.57"/>
          <Constant key="Parameter_932" name="Keqv25" value="100000"/>
          <Constant key="Parameter_931" name="Vmaxv25" value="1.17627"/>
        </ListOfConstants>
        <KineticLaw function="Function_57" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_568">
              <SourceParameter reference="ModelValue_165"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_572">
              <SourceParameter reference="ModelValue_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_411">
              <SourceParameter reference="ModelValue_148"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_538">
              <SourceParameter reference="Metabolite_21"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_326">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_630">
              <SourceParameter reference="Metabolite_36"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_631">
              <SourceParameter reference="Metabolite_41"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_632">
              <SourceParameter reference="ModelValue_32"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_633">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_19" name="v_27" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_4" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_44" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_13" stoichiometry="1"/>
          <Product metabolite="Metabolite_6" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_930" name="K1v26" value="0.00184"/>
          <Constant key="Parameter_929" name="K2v26" value="0.477177"/>
          <Constant key="Parameter_928" name="K3v26" value="0.0567019"/>
          <Constant key="Parameter_927" name="K4v26" value="0.0003"/>
          <Constant key="Parameter_926" name="K5v26" value="0.0287"/>
          <Constant key="Parameter_925" name="K6v26" value="0.110034"/>
          <Constant key="Parameter_924" name="K7v26" value="0.215"/>
          <Constant key="Parameter_923" name="Keqv26" value="1.2"/>
          <Constant key="Parameter_922" name="Vmaxv26" value="36.4911"/>
        </ListOfConstants>
        <KineticLaw function="Function_58" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_648">
              <SourceParameter reference="Metabolite_4"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_649">
              <SourceParameter reference="Metabolite_6"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_650">
              <SourceParameter reference="Metabolite_13"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_651">
              <SourceParameter reference="ModelValue_5"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_652">
              <SourceParameter reference="ModelValue_79"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_653">
              <SourceParameter reference="ModelValue_72"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_654">
              <SourceParameter reference="ModelValue_111"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_655">
              <SourceParameter reference="ModelValue_132"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_656">
              <SourceParameter reference="ModelValue_35"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_657">
              <SourceParameter reference="ModelValue_101"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_658">
              <SourceParameter reference="ModelValue_150"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_659">
              <SourceParameter reference="ModelValue_31"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_660">
              <SourceParameter reference="Metabolite_44"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_661">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_20" name="v_28" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_38" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_37" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_921" name="Keqv27" value="1"/>
          <Constant key="Parameter_920" name="Vmaxv27" value="100"/>
        </ListOfConstants>
        <KineticLaw function="Function_59" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_569">
              <SourceParameter reference="ModelValue_46"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_644">
              <SourceParameter reference="Metabolite_37"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_645">
              <SourceParameter reference="Metabolite_38"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_643">
              <SourceParameter reference="ModelValue_30"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_567">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_21" name="v_29" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_19" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_18" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_919" name="Keqv28" value="1"/>
          <Constant key="Parameter_918" name="Vmaxv28" value="10000"/>
        </ListOfConstants>
        <KineticLaw function="Function_60" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_677">
              <SourceParameter reference="ModelValue_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_678">
              <SourceParameter reference="Metabolite_18"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_679">
              <SourceParameter reference="Metabolite_19"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_680">
              <SourceParameter reference="ModelValue_24"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_681">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_22" name="v_3" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_9" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_6" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_917" name="KFru6Pv2" value="0.071"/>
          <Constant key="Parameter_916" name="KGlc6Pv2" value="0.161171"/>
          <Constant key="Parameter_915" name="Keqv2" value="0.3925"/>
          <Constant key="Parameter_914" name="Vmaxv2" value="935"/>
        </ListOfConstants>
        <KineticLaw function="Function_61" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_689">
              <SourceParameter reference="Metabolite_6"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_690">
              <SourceParameter reference="Metabolite_9"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_691">
              <SourceParameter reference="ModelValue_146"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_692">
              <SourceParameter reference="ModelValue_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_693">
              <SourceParameter reference="ModelValue_57"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_694">
              <SourceParameter reference="ModelValue_7"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_695">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_23" name="v_30" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_40" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_39" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_913" name="Keqv29" value="1"/>
          <Constant key="Parameter_912" name="Vmaxv29" value="10000"/>
        </ListOfConstants>
        <KineticLaw function="Function_62" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_646">
              <SourceParameter reference="ModelValue_55"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_647">
              <SourceParameter reference="Metabolite_39"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_703">
              <SourceParameter reference="Metabolite_40"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_704">
              <SourceParameter reference="ModelValue_23"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_705">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_24" name="v_31" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_2" stoichiometry="1"/>
          <Product metabolite="Metabolite_24" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_911" name="EqMult" value="1000"/>
          <Constant key="Parameter_910" name="KdATP" value="0.072"/>
        </ListOfConstants>
        <KineticLaw function="Function_63" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_712">
              <SourceParameter reference="Metabolite_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_713">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_714">
              <SourceParameter reference="ModelValue_124"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_715">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_716">
              <SourceParameter reference="Metabolite_24"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_717">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_25" name="v_32" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_20" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_0" stoichiometry="1"/>
          <Product metabolite="Metabolite_24" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_909" name="EqMult" value="1000"/>
          <Constant key="Parameter_908" name="KdADP" value="0.617685"/>
        </ListOfConstants>
        <KineticLaw function="Function_64" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_724">
              <SourceParameter reference="Metabolite_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_725">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_726">
              <SourceParameter reference="ModelValue_116"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_727">
              <SourceParameter reference="Metabolite_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_728">
              <SourceParameter reference="Metabolite_24"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_729">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_26" name="v_33" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_21" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_1" stoichiometry="1"/>
          <Product metabolite="Metabolite_24" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_907" name="EqMult" value="1000"/>
          <Constant key="Parameter_906" name="KdAMP" value="10.9717"/>
        </ListOfConstants>
        <KineticLaw function="Function_65" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_736">
              <SourceParameter reference="Metabolite_1"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_737">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_738">
              <SourceParameter reference="ModelValue_117"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_739">
              <SourceParameter reference="Metabolite_21"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_740">
              <SourceParameter reference="Metabolite_24"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_741">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_27" name="v_34" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_23" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_15" stoichiometry="1"/>
          <Product metabolite="Metabolite_24" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_905" name="EqMult" value="1000"/>
          <Constant key="Parameter_904" name="Kd23P2G" value="1.667"/>
        </ListOfConstants>
        <KineticLaw function="Function_66" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_748">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_749">
              <SourceParameter reference="Metabolite_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_750">
              <SourceParameter reference="ModelValue_81"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_751">
              <SourceParameter reference="Metabolite_23"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_752">
              <SourceParameter reference="Metabolite_24"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_753">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_28" name="v_35" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_29" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_31" stoichiometry="1"/>
          <Product metabolite="Metabolite_28" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_903" name="EqMult" value="1000"/>
          <Constant key="Parameter_902" name="Kd1" value="0.0002"/>
        </ListOfConstants>
        <KineticLaw function="Function_67" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_760">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_761">
              <SourceParameter reference="ModelValue_104"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_762">
              <SourceParameter reference="Metabolite_28"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_763">
              <SourceParameter reference="Metabolite_29"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_764">
              <SourceParameter reference="Metabolite_31"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_765">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_29" name="v_36" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_30" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_31" stoichiometry="1"/>
          <Product metabolite="Metabolite_27" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_901" name="EqMult" value="1000"/>
          <Constant key="Parameter_900" name="Kd3" value="1e-05"/>
        </ListOfConstants>
        <KineticLaw function="Function_68" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_772">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_773">
              <SourceParameter reference="ModelValue_106"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_774">
              <SourceParameter reference="Metabolite_27"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_775">
              <SourceParameter reference="Metabolite_30"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_776">
              <SourceParameter reference="Metabolite_31"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_777">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_30" name="v_37" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_32" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_34" stoichiometry="1"/>
          <Product metabolite="Metabolite_28" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_899" name="EqMult" value="1000"/>
          <Constant key="Parameter_898" name="Kd2" value="1e-05"/>
        </ListOfConstants>
        <KineticLaw function="Function_69" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_784">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_785">
              <SourceParameter reference="ModelValue_105"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_786">
              <SourceParameter reference="Metabolite_28"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_787">
              <SourceParameter reference="Metabolite_32"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_788">
              <SourceParameter reference="Metabolite_34"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_789">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_31" name="v_38" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_33" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_34" stoichiometry="1"/>
          <Product metabolite="Metabolite_27" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_897" name="EqMult" value="1000"/>
          <Constant key="Parameter_896" name="Kd4" value="0.0002"/>
        </ListOfConstants>
        <KineticLaw function="Function_70" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_796">
              <SourceParameter reference="ModelValue_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_797">
              <SourceParameter reference="ModelValue_100"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_798">
              <SourceParameter reference="Metabolite_27"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_799">
              <SourceParameter reference="Metabolite_33"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_800">
              <SourceParameter reference="Metabolite_34"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_801">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_32" name="v_4" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_6" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_5" stoichiometry="1"/>
          <Product metabolite="Metabolite_20" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_1" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_21" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_2" stoichiometry="1"/>
          <Modifier metabolite="Metabolite_24" stoichiometry="1"/>
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_895" name="KAMPv3" value="0.033"/>
          <Constant key="Parameter_894" name="KATPv3" value="0.01"/>
          <Constant key="Parameter_893" name="KFru6Pv3" value="0.10678"/>
          <Constant key="Parameter_892" name="KMgATPv3" value="0.068"/>
          <Constant key="Parameter_891" name="KMgv3" value="0.44"/>
          <Constant key="Parameter_890" name="Keqv3" value="100000"/>
          <Constant key="Parameter_889" name="L0v3" value="0.001072"/>
          <Constant key="Parameter_888" name="Vmaxv3" value="239"/>
        </ListOfConstants>
        <KineticLaw function="Function_71" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_819">
              <SourceParameter reference="Metabolite_1"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_820">
              <SourceParameter reference="Metabolite_2"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_821">
              <SourceParameter reference="Metabolite_5"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_822">
              <SourceParameter reference="Metabolite_6"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_823">
              <SourceParameter reference="ModelValue_123"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_824">
              <SourceParameter reference="ModelValue_18"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_825">
              <SourceParameter reference="ModelValue_147"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_826">
              <SourceParameter reference="ModelValue_119"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_827">
              <SourceParameter reference="ModelValue_77"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_828">
              <SourceParameter reference="ModelValue_140"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_829">
              <SourceParameter reference="ModelValue_52"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_830">
              <SourceParameter reference="Metabolite_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_831">
              <SourceParameter reference="Metabolite_21"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_832">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_833">
              <SourceParameter reference="Metabolite_24"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_834">
              <SourceParameter reference="ModelValue_36"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_835">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_33" name="v_5" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_5" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_13" stoichiometry="1"/>
          <Product metabolite="Metabolite_3" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_887" name="KDHAPv4" value="0.0364"/>
          <Constant key="Parameter_886" name="KFru16P2v4" value="0.00835053"/>
          <Constant key="Parameter_885" name="KGraPv4" value="0.296226"/>
          <Constant key="Parameter_884" name="Keqv4" value="0.114"/>
          <Constant key="Parameter_883" name="KiGraPv4" value="0.0572"/>
          <Constant key="Parameter_882" name="KiiGraPv4" value="0.176"/>
          <Constant key="Parameter_881" name="Vmaxv4" value="82.8424"/>
        </ListOfConstants>
        <KineticLaw function="Function_72" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_812">
              <SourceParameter reference="Metabolite_3"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_817">
              <SourceParameter reference="Metabolite_5"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_688">
              <SourceParameter reference="Metabolite_13"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_573">
              <SourceParameter reference="ModelValue_110"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_811">
              <SourceParameter reference="ModelValue_114"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_815">
              <SourceParameter reference="ModelValue_59"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_853">
              <SourceParameter reference="ModelValue_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_854">
              <SourceParameter reference="ModelValue_120"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_855">
              <SourceParameter reference="ModelValue_138"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_856">
              <SourceParameter reference="ModelValue_37"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_857">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_34" name="v_6" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_3" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_13" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_880" name="KDHAPv5" value="0.94974"/>
          <Constant key="Parameter_879" name="KGraPv5" value="0.428"/>
          <Constant key="Parameter_878" name="Keqv5" value="0.0404861"/>
          <Constant key="Parameter_877" name="Vmaxv5" value="4404.7"/>
        </ListOfConstants>
        <KineticLaw function="Function_73" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_814">
              <SourceParameter reference="Metabolite_3"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_537">
              <SourceParameter reference="Metabolite_13"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_813">
              <SourceParameter reference="ModelValue_109"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_816">
              <SourceParameter reference="ModelValue_60"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_869">
              <SourceParameter reference="ModelValue_128"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_870">
              <SourceParameter reference="ModelValue_38"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_871">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_35" name="v_7" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_13" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_37" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_25" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_14" stoichiometry="1"/>
          <Product metabolite="Metabolite_26" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_876" name="K13P2Gv6" value="0.0035"/>
          <Constant key="Parameter_875" name="KGraPv6" value="0.00635644"/>
          <Constant key="Parameter_874" name="KNADHv6" value="0.0105041"/>
          <Constant key="Parameter_873" name="KNADv6" value="0.05"/>
          <Constant key="Parameter_872" name="KPv6" value="3.7559"/>
          <Constant key="Parameter_871" name="Keqv6" value="0.000167624"/>
          <Constant key="Parameter_870" name="Vmaxv6" value="4300"/>
        </ListOfConstants>
        <KineticLaw function="Function_74" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_885">
              <SourceParameter reference="Metabolite_13"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_886">
              <SourceParameter reference="Metabolite_14"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_887">
              <SourceParameter reference="ModelValue_159"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_888">
              <SourceParameter reference="ModelValue_58"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_889">
              <SourceParameter reference="ModelValue_10"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_890">
              <SourceParameter reference="ModelValue_127"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_891">
              <SourceParameter reference="ModelValue_155"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_892">
              <SourceParameter reference="ModelValue_125"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_893">
              <SourceParameter reference="Metabolite_25"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_894">
              <SourceParameter reference="Metabolite_26"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_895">
              <SourceParameter reference="Metabolite_37"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_896">
              <SourceParameter reference="ModelValue_61"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_897">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_36" name="v_8" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_14" stoichiometry="1"/>
          <Substrate metabolite="Metabolite_20" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_17" stoichiometry="1"/>
          <Product metabolite="Metabolite_22" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_869" name="K13P2Gv7" value="0.002"/>
          <Constant key="Parameter_868" name="K3PGv7" value="1.14526"/>
          <Constant key="Parameter_867" name="KMgADPv7" value="0.354968"/>
          <Constant key="Parameter_866" name="KMgATPv7" value="0.373185"/>
          <Constant key="Parameter_865" name="Keqv7" value="1455"/>
          <Constant key="Parameter_864" name="Vmaxv7" value="5000"/>
        </ListOfConstants>
        <KineticLaw function="Function_75" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_879">
              <SourceParameter reference="Metabolite_14"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_809">
              <SourceParameter reference="Metabolite_17"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_911">
              <SourceParameter reference="ModelValue_160"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_912">
              <SourceParameter reference="ModelValue_149"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_913">
              <SourceParameter reference="ModelValue_80"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_914">
              <SourceParameter reference="ModelValue_118"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_915">
              <SourceParameter reference="ModelValue_126"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_916">
              <SourceParameter reference="Metabolite_20"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_917">
              <SourceParameter reference="Metabolite_22"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_918">
              <SourceParameter reference="ModelValue_54"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_919">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_37" name="v_9" reversible="true" fast="false" addNoise="false">
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_14" stoichiometry="1"/>
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_15" stoichiometry="1"/>
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_23" stoichiometry="1"/>
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_863" name="K23P2Gv8" value="0.0349411"/>
          <Constant key="Parameter_862" name="Keqv8" value="141914"/>
          <Constant key="Parameter_861" name="kDPGMv8" value="76000"/>
        </ListOfConstants>
        <KineticLaw function="Function_76" unitType="Default" scalingCompartment="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_810">
              <SourceParameter reference="Metabolite_14"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_818">
              <SourceParameter reference="Metabolite_15"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_571">
              <SourceParameter reference="ModelValue_142"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_711">
              <SourceParameter reference="ModelValue_133"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_931">
              <SourceParameter reference="Metabolite_23"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_932">
              <SourceParameter reference="Compartment_0"/>
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_933">
              <SourceParameter reference="ModelValue_17"/>
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
    </ListOfReactions>
    <ListOfModelParameterSets activeSet="ModelParameterSet_1">
      <ModelParameterSet key="ModelParameterSet_1" name="Initial State">
        <ModelParameterGroup cn="String=Initial Time" type="Group">
          <ModelParameter cn="CN=Root,Model=holzhutter" value="0" type="Model" simulationType="time"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Compartment Sizes" type="Group">
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment]" value="1" type="Compartment" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Species Values" type="Group">
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[ADPf]" value="1.5055354475e+23" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[AMPf]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[ATPf]" value="1.5055354475e+23" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[DHAP]" value="8.9850355506800002e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[E4P]" value="3.7939493276999997e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Fru16P2]" value="5.8414775363000001e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Fru6P]" value="9.213876938699999e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[GSH]" value="1.8750540677344e+24" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[GSSG]" value="2.4088567160000001e+20" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Glc6P]" value="2.3727238652599999e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[GlcA6P]" value="1.5055354475e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Glcin]" value="2.7498906055676998e+24" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Glcout]" value="3.0110708949999998e+24" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[GraP]" value="3.6735064918999999e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Gri13P2]" value="3.0110708950000003e+20" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Gri23P2f]" value="1.2406214301578997e+24" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Gri2P]" value="5.0585991036e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Gri3P]" value="3.9625692978199998e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Lac]" value="1.0119004849736999e+24" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Lacex]" value="1.01171982072e+24" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[MgADP]" value="6.0221417900000001e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[MgAMP]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[MgATP]" value="8.4309985059999996e+23" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[MgGri23P2]" value="3.0110708949999999e+23" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Mgf]" value="4.817713432e+23" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[NAD]" value="3.9324585888699994e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[NADH]" value="1.204428358e+20" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[NADPHf]" value="2.4088567160000002e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[NADPf]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[P1NADP]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[P1NADPH]" value="1.4453140296e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[P1f]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[P2NADP]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[P2NADPH]" value="1.4453140296e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[P2f]" value="0" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[PEP]" value="6.5641345510999998e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[PRPP]" value="6.0221417899999999e+23" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Phi]" value="6.0173240765679997e+23" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Phiex]" value="6.0221417899999999e+23" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Pyr]" value="5.0585991036000002e+22" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Pyrex]" value="5.0585991036000002e+22" type="Species" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Rib5P]" value="8.430998506e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Rul5P]" value="2.8304066412999999e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Sed7P]" value="9.2740983566000005e+21" type="Species" simulationType="reactions"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Compartments[default_compartment],Vector=Metabolites[Xul5P]" value="7.6481200732999999e+21" type="Species" simulationType="reactions"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMg23P2Gv1]" value="6.2112798362100001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KAMPv16]" value="0.099799402336500004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv28]" value="1" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADPHv18]" value="0.0017912094278199999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K1v24]" value="0.0082299999999999995" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K1v26]" value="0.0018400000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KPGA23v18]" value="0.099465165072699993" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv2]" value="935" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K1v23]" value="0.38800878022200003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Inhibv1]" value="0.83955687095499998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADHv6]" value="0.0105041027811" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADPHv17]" value="0.0031199999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Mgtot]" value="2.7999999999999998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[protein1]" value="0.021778762863100001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KR5Pv22]" value="2.2000000000000002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KR5Pv25]" value="0.56999999999999995" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv19]" value="0.94067979629300003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[kDPGMv8]" value="76000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KATPv3]" value="0.01" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgATPMgv1]" value="1.1399999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv4]" value="0.114" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KGlc6Pv1]" value="0.0044999999999999997" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KGlc6Pv2]" value="0.16117113233399999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv29]" value="10000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv28]" value="10000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[EqMult]" value="1000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMinv0]" value="6.6960176783899996" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv23]" value="25.462998451600001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv22]" value="730" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv21]" value="4634" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv27]" value="100" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv26]" value="36.491131885199998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv25]" value="1.1762736713399999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv24]" value="30.408629637499999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K6v24]" value="0.492538064921" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K6v26]" value="0.11003398765" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv3]" value="239" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv4]" value="82.842423015999998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv5]" value="4404.6958028600002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADPv17]" value="0.0035425542217000002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K6v23]" value="0.0137716737587" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADPv19]" value="0.075886172789000006" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADPv18]" value="0.017999999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgADPv12]" value="0.43880012784599998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KATPv12]" value="3.3900000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv24]" value="1.05" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv27]" value="1" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KPGA23v17]" value="2.2890000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KATPv16]" value="0.173482270839" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KATPv17]" value="0.749" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv23]" value="1.05" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv22]" value="3" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[L0v3]" value="0.001072" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KATPv18]" value="0.204257236072" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv7]" value="5000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv29]" value="1" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K5v23]" value="0.41138999999999998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv2]" value="0.39250000000000002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KGraPv6]" value="0.0063564418874099997" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KGraPv4]" value="0.29622622155" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KGraPv5]" value="0.42799999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv6]" value="4300" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv1]" value="3900" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K2PGv10]" value="0.81042046031000003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K2PGv11]" value="1" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv9]" value="0.53000000000000003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMoutv0]" value="1.7" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K3v23]" value="12.432" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv11]" value="1.7" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv12]" value="13987.566805500001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv13]" value="9090" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv14]" value="14181.799999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K3v26]" value="0.056701949841700003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv16]" value="0.25" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K3v24]" value="0.19986555159200001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv18]" value="141.69999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgv1]" value="1.2665998361899999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgv3]" value="0.44" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K2v24]" value="0.054121268449899999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K2v26]" value="0.47717693486000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgADPv7]" value="0.354968059457" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Kd23P2G]" value="1.667" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[GStotal]" value="3.04495540456" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KRu5Pv21]" value="0.19" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMGlcv1]" value="0.087172865688099996" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[protein2]" value="0.027372076237700001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv12]" value="570" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv13]" value="2800000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv10]" value="2000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv11]" value="1500" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv16]" value="1380" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv17]" value="162" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[kLDHv14]" value="184.692751921" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv18]" value="1305.3099174199999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv19]" value="90" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmaxv0]" value="33.600000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KX5Pv21]" value="0.48770031935300001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmax1v1]" value="15.800000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K3PGv10]" value="5" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KG6Pv17]" value="0.062613649003300006" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Kd4]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K7v26]" value="0.215" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K7v24]" value="2.43160734777" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K7v23]" value="48.799999999999997" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Kd1]" value="0.00020000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Kd2]" value="1.0000000000000001e-05" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Kd3]" value="1.0000000000000001e-05" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv10]" value="0.12985368837299999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KGSHv19]" value="23.8368666995" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KDHAPv5]" value="0.94973961113200001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KDHAPv4]" value="0.036400000000000002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K4v26]" value="0.00029999999999999997" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K4v24]" value="0.0060949999999999997" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K4v23]" value="0.00409559213329" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KFru16P2v4]" value="0.0083505290070899994" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[alfav0]" value="0.54000000000000004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KdADP]" value="0.61768530074700001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KdAMP]" value="10.971735779299999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgATPv7]" value="0.373185469426" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgATPv3]" value="0.068000000000000005" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KiGraPv4]" value="0.057200000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KMgATPv1]" value="0.907389917504" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv17]" value="2094.2252309700002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KAMPv3]" value="0.033000000000000002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KdATP]" value="0.071999999999999995" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv6]" value="0.000167623949645" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv7]" value="1455" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADv6]" value="0.050000000000000003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv5]" value="0.040486060055600001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KNADPHv19]" value="0.0085199999999999998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K5v24]" value="0.86829999999999996" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv0]" value="0.54486899878100004" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K5v26]" value="0.0287" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv8]" value="141914.358423" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv9]" value="100000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K2v23]" value="0.31264788198499999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KGSSGv19]" value="0.065199999999999994" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Kv20]" value="0.029999999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KiiGraPv4]" value="0.17599999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Vmax2v1]" value="33.200000000000003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv3]" value="100000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K23P2Gv9]" value="0.13073126530000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K23P2Gv8]" value="0.034941139166499997" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[kATPasev15]" value="1.6799999999999999" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K23P2Gv1]" value="3.0888334303799998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Atot]" value="2.63210940537" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KFru6Pv2]" value="0.070999999999999994" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KFru6Pv3]" value="0.10678026016" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv25]" value="100000" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K3PGv7]" value="1.1452571222600001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv26]" value="1.2" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KADPv16]" value="0.093809107968500005" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KRu5Pv22]" value="0.78000000000000003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[Keqv21]" value="3.7326230208800002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[NADPtot]" value="0.051999999999999998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KPv6]" value="3.7558974895300001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K6PG1v18]" value="0.01" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KPEPv11]" value="1" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KPEPv12]" value="0.13538074424900001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K13P2Gv6]" value="0.0035000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K13P2Gv7]" value="0.002" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[NADtot]" value="0.065500000000000003" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KFru16P2v12]" value="0.0050000000000000001" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[L0v12]" value="13.2222019644" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[K6PG2v18]" value="0.064997069307799998" type="ModelValue" simulationType="fixed"/>
          <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Values[KATPv25]" value="0.029999999999999999" type="ModelValue" simulationType="fixed"/>
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_1]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_1],ParameterGroup=Parameters,Parameter=KMinv0" value="6.6960176783899996" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMinv0],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_1],ParameterGroup=Parameters,Parameter=KMoutv0" value="1.7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMoutv0],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_1],ParameterGroup=Parameters,Parameter=Keqv0" value="0.54486899878100004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv0],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_1],ParameterGroup=Parameters,Parameter=Vmaxv0" value="33.600000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv0],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_1],ParameterGroup=Parameters,Parameter=alfav0" value="0.54000000000000004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[alfav0],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_10]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_10],ParameterGroup=Parameters,Parameter=K23P2Gv9" value="0.13073126530000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K23P2Gv9],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_10],ParameterGroup=Parameters,Parameter=Keqv9" value="100000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv9],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_10],ParameterGroup=Parameters,Parameter=Vmaxv9" value="0.53000000000000003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv9],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_11]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_11],ParameterGroup=Parameters,Parameter=K2PGv10" value="0.81042046031000003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K2PGv10],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_11],ParameterGroup=Parameters,Parameter=K3PGv10" value="5" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K3PGv10],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_11],ParameterGroup=Parameters,Parameter=Keqv10" value="0.12985368837299999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv10],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_11],ParameterGroup=Parameters,Parameter=Vmaxv10" value="2000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv10],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_12]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_12],ParameterGroup=Parameters,Parameter=K2PGv11" value="1" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K2PGv11],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_12],ParameterGroup=Parameters,Parameter=KPEPv11" value="1" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KPEPv11],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_12],ParameterGroup=Parameters,Parameter=Keqv11" value="1.7" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv11],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_12],ParameterGroup=Parameters,Parameter=Vmaxv11" value="1500" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv11],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13],ParameterGroup=Parameters,Parameter=KATPv12" value="3.3900000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KATPv12],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13],ParameterGroup=Parameters,Parameter=KFru16P2v12" value="0.0050000000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KFru16P2v12],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13],ParameterGroup=Parameters,Parameter=KMgADPv12" value="0.43880012784599998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgADPv12],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13],ParameterGroup=Parameters,Parameter=KPEPv12" value="0.13538074424900001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KPEPv12],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13],ParameterGroup=Parameters,Parameter=Keqv12" value="13987.566805500001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv12],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13],ParameterGroup=Parameters,Parameter=L0v12" value="13.2222019644" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[L0v12],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_13],ParameterGroup=Parameters,Parameter=Vmaxv12" value="570" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv12],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_14]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_14],ParameterGroup=Parameters,Parameter=Keqv13" value="9090" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv13],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_14],ParameterGroup=Parameters,Parameter=Vmaxv13" value="2800000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv13],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_15]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_15],ParameterGroup=Parameters,Parameter=Keqv14" value="14181.799999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv14],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_15],ParameterGroup=Parameters,Parameter=kLDHv14" value="184.692751921" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[kLDHv14],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_16]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_16],ParameterGroup=Parameters,Parameter=kATPasev15" value="1.6799999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[kATPasev15],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_17]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_17],ParameterGroup=Parameters,Parameter=KADPv16" value="0.093809107968500005" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KADPv16],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_17],ParameterGroup=Parameters,Parameter=KAMPv16" value="0.099799402336500004" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KAMPv16],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_17],ParameterGroup=Parameters,Parameter=KATPv16" value="0.173482270839" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KATPv16],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_17],ParameterGroup=Parameters,Parameter=Keqv16" value="0.25" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv16],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_17],ParameterGroup=Parameters,Parameter=Vmaxv16" value="1380" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv16],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18],ParameterGroup=Parameters,Parameter=KATPv17" value="0.749" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KATPv17],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18],ParameterGroup=Parameters,Parameter=KG6Pv17" value="0.062613649003300006" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KG6Pv17],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18],ParameterGroup=Parameters,Parameter=KNADPHv17" value="0.0031199999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADPHv17],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18],ParameterGroup=Parameters,Parameter=KNADPv17" value="0.0035425542217000002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADPv17],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18],ParameterGroup=Parameters,Parameter=KPGA23v17" value="2.2890000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KPGA23v17],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18],ParameterGroup=Parameters,Parameter=Keqv17" value="2094.2252309700002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv17],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_18],ParameterGroup=Parameters,Parameter=Vmaxv17" value="162" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv17],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=K6PG1v18" value="0.01" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K6PG1v18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=K6PG2v18" value="0.064997069307799998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K6PG2v18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=KATPv18" value="0.204257236072" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KATPv18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=KNADPHv18" value="0.0017912094278199999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADPHv18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=KNADPv18" value="0.017999999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADPv18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=KPGA23v18" value="0.099465165072699993" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KPGA23v18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=Keqv18" value="141.69999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_19],ParameterGroup=Parameters,Parameter=Vmaxv18" value="1305.3099174199999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv18],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=Inhibv1" value="0.83955687095499998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Inhibv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=K23P2Gv1" value="3.0888334303799998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K23P2Gv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=KGlc6Pv1" value="0.0044999999999999997" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KGlc6Pv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=KMGlcv1" value="0.087172865688099996" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMGlcv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=KMg23P2Gv1" value="6.2112798362100001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMg23P2Gv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=KMgATPMgv1" value="1.1399999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgATPMgv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=KMgATPv1" value="0.907389917504" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgATPv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=KMgv1" value="1.2665998361899999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=Keqv1" value="3900" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=Vmax1v1" value="15.800000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmax1v1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_2],ParameterGroup=Parameters,Parameter=Vmax2v1" value="33.200000000000003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmax2v1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_20]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_20],ParameterGroup=Parameters,Parameter=KGSHv19" value="23.8368666995" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KGSHv19],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_20],ParameterGroup=Parameters,Parameter=KGSSGv19" value="0.065199999999999994" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KGSSGv19],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_20],ParameterGroup=Parameters,Parameter=KNADPHv19" value="0.0085199999999999998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADPHv19],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_20],ParameterGroup=Parameters,Parameter=KNADPv19" value="0.075886172789000006" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADPv19],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_20],ParameterGroup=Parameters,Parameter=Keqv19" value="0.94067979629300003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv19],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_20],ParameterGroup=Parameters,Parameter=Vmaxv19" value="90" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv19],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_21]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_21],ParameterGroup=Parameters,Parameter=Kv20" value="0.029999999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Kv20],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_22]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_22],ParameterGroup=Parameters,Parameter=KRu5Pv21" value="0.19" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KRu5Pv21],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_22],ParameterGroup=Parameters,Parameter=KX5Pv21" value="0.48770031935300001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KX5Pv21],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_22],ParameterGroup=Parameters,Parameter=Keqv21" value="3.7326230208800002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv21],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_22],ParameterGroup=Parameters,Parameter=Vmaxv21" value="4634" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv21],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_23]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_23],ParameterGroup=Parameters,Parameter=KR5Pv22" value="2.2000000000000002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KR5Pv22],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_23],ParameterGroup=Parameters,Parameter=KRu5Pv22" value="0.78000000000000003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KRu5Pv22],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_23],ParameterGroup=Parameters,Parameter=Keqv22" value="3" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv22],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_23],ParameterGroup=Parameters,Parameter=Vmaxv22" value="730" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv22],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=K1v23" value="0.38800878022200003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K1v23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=K2v23" value="0.31264788198499999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K2v23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=K3v23" value="12.432" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K3v23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=K4v23" value="0.00409559213329" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K4v23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=K5v23" value="0.41138999999999998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K5v23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=K6v23" value="0.0137716737587" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K6v23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=K7v23" value="48.799999999999997" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K7v23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=Keqv23" value="1.05" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_24],ParameterGroup=Parameters,Parameter=Vmaxv23" value="25.462998451600001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv23],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=K1v24" value="0.0082299999999999995" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K1v24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=K2v24" value="0.054121268449899999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K2v24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=K3v24" value="0.19986555159200001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K3v24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=K4v24" value="0.0060949999999999997" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K4v24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=K5v24" value="0.86829999999999996" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K5v24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=K6v24" value="0.492538064921" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K6v24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=K7v24" value="2.43160734777" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K7v24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=Keqv24" value="1.05" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_25],ParameterGroup=Parameters,Parameter=Vmaxv24" value="30.408629637499999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv24],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_26]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_26],ParameterGroup=Parameters,Parameter=KATPv25" value="0.029999999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KATPv25],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_26],ParameterGroup=Parameters,Parameter=KR5Pv25" value="0.56999999999999995" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KR5Pv25],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_26],ParameterGroup=Parameters,Parameter=Keqv25" value="100000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv25],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_26],ParameterGroup=Parameters,Parameter=Vmaxv25" value="1.1762736713399999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv25],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=K1v26" value="0.0018400000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K1v26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=K2v26" value="0.47717693486000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K2v26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=K3v26" value="0.056701949841700003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K3v26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=K4v26" value="0.00029999999999999997" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K4v26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=K5v26" value="0.0287" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K5v26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=K6v26" value="0.11003398765" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K6v26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=K7v26" value="0.215" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K7v26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=Keqv26" value="1.2" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_27],ParameterGroup=Parameters,Parameter=Vmaxv26" value="36.491131885199998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv26],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_28]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_28],ParameterGroup=Parameters,Parameter=Keqv27" value="1" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv27],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_28],ParameterGroup=Parameters,Parameter=Vmaxv27" value="100" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv27],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_29]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_29],ParameterGroup=Parameters,Parameter=Keqv28" value="1" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv28],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_29],ParameterGroup=Parameters,Parameter=Vmaxv28" value="10000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv28],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_3]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_3],ParameterGroup=Parameters,Parameter=KFru6Pv2" value="0.070999999999999994" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KFru6Pv2],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_3],ParameterGroup=Parameters,Parameter=KGlc6Pv2" value="0.16117113233399999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KGlc6Pv2],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_3],ParameterGroup=Parameters,Parameter=Keqv2" value="0.39250000000000002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv2],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_3],ParameterGroup=Parameters,Parameter=Vmaxv2" value="935" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv2],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_30]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_30],ParameterGroup=Parameters,Parameter=Keqv29" value="1" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv29],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_30],ParameterGroup=Parameters,Parameter=Vmaxv29" value="10000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv29],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_31]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_31],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_31],ParameterGroup=Parameters,Parameter=KdATP" value="0.071999999999999995" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KdATP],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_32]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_32],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_32],ParameterGroup=Parameters,Parameter=KdADP" value="0.61768530074700001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KdADP],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_33]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_33],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_33],ParameterGroup=Parameters,Parameter=KdAMP" value="10.971735779299999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KdAMP],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_34]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_34],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_34],ParameterGroup=Parameters,Parameter=Kd23P2G" value="1.667" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Kd23P2G],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_35]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_35],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_35],ParameterGroup=Parameters,Parameter=Kd1" value="0.00020000000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Kd1],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_36]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_36],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_36],ParameterGroup=Parameters,Parameter=Kd3" value="1.0000000000000001e-05" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Kd3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_37]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_37],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_37],ParameterGroup=Parameters,Parameter=Kd2" value="1.0000000000000001e-05" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Kd2],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_38]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_38],ParameterGroup=Parameters,Parameter=EqMult" value="1000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[EqMult],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_38],ParameterGroup=Parameters,Parameter=Kd4" value="0.00020000000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Kd4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=KAMPv3" value="0.033000000000000002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KAMPv3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=KATPv3" value="0.01" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KATPv3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=KFru6Pv3" value="0.10678026016" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KFru6Pv3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=KMgATPv3" value="0.068000000000000005" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgATPv3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=KMgv3" value="0.44" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgv3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=Keqv3" value="100000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=L0v3" value="0.001072" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[L0v3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_4],ParameterGroup=Parameters,Parameter=Vmaxv3" value="239" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv3],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5],ParameterGroup=Parameters,Parameter=KDHAPv4" value="0.036400000000000002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KDHAPv4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5],ParameterGroup=Parameters,Parameter=KFru16P2v4" value="0.0083505290070899994" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KFru16P2v4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5],ParameterGroup=Parameters,Parameter=KGraPv4" value="0.29622622155" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KGraPv4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5],ParameterGroup=Parameters,Parameter=Keqv4" value="0.114" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5],ParameterGroup=Parameters,Parameter=KiGraPv4" value="0.057200000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KiGraPv4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5],ParameterGroup=Parameters,Parameter=KiiGraPv4" value="0.17599999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KiiGraPv4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_5],ParameterGroup=Parameters,Parameter=Vmaxv4" value="82.842423015999998" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv4],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_6]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_6],ParameterGroup=Parameters,Parameter=KDHAPv5" value="0.94973961113200001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KDHAPv5],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_6],ParameterGroup=Parameters,Parameter=KGraPv5" value="0.42799999999999999" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KGraPv5],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_6],ParameterGroup=Parameters,Parameter=Keqv5" value="0.040486060055600001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv5],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_6],ParameterGroup=Parameters,Parameter=Vmaxv5" value="4404.6958028600002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv5],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7],ParameterGroup=Parameters,Parameter=K13P2Gv6" value="0.0035000000000000001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K13P2Gv6],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7],ParameterGroup=Parameters,Parameter=KGraPv6" value="0.0063564418874099997" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KGraPv6],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7],ParameterGroup=Parameters,Parameter=KNADHv6" value="0.0105041027811" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADHv6],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7],ParameterGroup=Parameters,Parameter=KNADv6" value="0.050000000000000003" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KNADv6],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7],ParameterGroup=Parameters,Parameter=KPv6" value="3.7558974895300001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KPv6],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7],ParameterGroup=Parameters,Parameter=Keqv6" value="0.000167623949645" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv6],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_7],ParameterGroup=Parameters,Parameter=Vmaxv6" value="4300" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv6],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_8]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_8],ParameterGroup=Parameters,Parameter=K13P2Gv7" value="0.002" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K13P2Gv7],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_8],ParameterGroup=Parameters,Parameter=K3PGv7" value="1.1452571222600001" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K3PGv7],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_8],ParameterGroup=Parameters,Parameter=KMgADPv7" value="0.354968059457" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgADPv7],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_8],ParameterGroup=Parameters,Parameter=KMgATPv7" value="0.373185469426" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[KMgATPv7],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_8],ParameterGroup=Parameters,Parameter=Keqv7" value="1455" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv7],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_8],ParameterGroup=Parameters,Parameter=Vmaxv7" value="5000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Vmaxv7],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=holzhutter,Vector=Reactions[v_9]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_9],ParameterGroup=Parameters,Parameter=K23P2Gv8" value="0.034941139166499997" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[K23P2Gv8],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_9],ParameterGroup=Parameters,Parameter=Keqv8" value="141914.358423" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[Keqv8],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
            <ModelParameter cn="CN=Root,Model=holzhutter,Vector=Reactions[v_9],ParameterGroup=Parameters,Parameter=kDPGMv8" value="76000" type="ReactionParameter" simulationType="assignment">
              <InitialExpression>
                &lt;CN=Root,Model=holzhutter,Vector=Values[kDPGMv8],Reference=InitialValue>
              </InitialExpression>
            </ModelParameter>
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
    </ListOfModelParameterSets>
    <StateTemplate>
      <StateTemplateVariable objectReference="Model_1"/>
      <StateTemplateVariable objectReference="Metabolite_7"/>
      <StateTemplateVariable objectReference="Metabolite_22"/>
      <StateTemplateVariable objectReference="Metabolite_13"/>
      <StateTemplateVariable objectReference="Metabolite_27"/>
      <StateTemplateVariable objectReference="Metabolite_6"/>
      <StateTemplateVariable objectReference="Metabolite_24"/>
      <StateTemplateVariable objectReference="Metabolite_37"/>
      <StateTemplateVariable objectReference="Metabolite_39"/>
      <StateTemplateVariable objectReference="Metabolite_28"/>
      <StateTemplateVariable objectReference="Metabolite_42"/>
      <StateTemplateVariable objectReference="Metabolite_17"/>
      <StateTemplateVariable objectReference="Metabolite_9"/>
      <StateTemplateVariable objectReference="Metabolite_14"/>
      <StateTemplateVariable objectReference="Metabolite_41"/>
      <StateTemplateVariable objectReference="Metabolite_3"/>
      <StateTemplateVariable objectReference="Metabolite_18"/>
      <StateTemplateVariable objectReference="Metabolite_0"/>
      <StateTemplateVariable objectReference="Metabolite_44"/>
      <StateTemplateVariable objectReference="Metabolite_16"/>
      <StateTemplateVariable objectReference="Metabolite_11"/>
      <StateTemplateVariable objectReference="Metabolite_15"/>
      <StateTemplateVariable objectReference="Metabolite_4"/>
      <StateTemplateVariable objectReference="Metabolite_21"/>
      <StateTemplateVariable objectReference="Metabolite_10"/>
      <StateTemplateVariable objectReference="Metabolite_31"/>
      <StateTemplateVariable objectReference="Metabolite_35"/>
      <StateTemplateVariable objectReference="Metabolite_26"/>
      <StateTemplateVariable objectReference="Metabolite_5"/>
      <StateTemplateVariable objectReference="Metabolite_1"/>
      <StateTemplateVariable objectReference="Metabolite_32"/>
      <StateTemplateVariable objectReference="Metabolite_29"/>
      <StateTemplateVariable objectReference="Metabolite_43"/>
      <StateTemplateVariable objectReference="Metabolite_20"/>
      <StateTemplateVariable objectReference="Metabolite_33"/>
      <StateTemplateVariable objectReference="Metabolite_2"/>
      <StateTemplateVariable objectReference="Metabolite_30"/>
      <StateTemplateVariable objectReference="Metabolite_23"/>
      <StateTemplateVariable objectReference="Metabolite_8"/>
      <StateTemplateVariable objectReference="Metabolite_25"/>
      <StateTemplateVariable objectReference="Metabolite_34"/>
      <StateTemplateVariable objectReference="Metabolite_12"/>
      <StateTemplateVariable objectReference="Metabolite_19"/>
      <StateTemplateVariable objectReference="Metabolite_36"/>
      <StateTemplateVariable objectReference="Metabolite_38"/>
      <StateTemplateVariable objectReference="Metabolite_40"/>
      <StateTemplateVariable objectReference="Compartment_0"/>
      <StateTemplateVariable objectReference="ModelValue_0"/>
      <StateTemplateVariable objectReference="ModelValue_1"/>
      <StateTemplateVariable objectReference="ModelValue_2"/>
      <StateTemplateVariable objectReference="ModelValue_3"/>
      <StateTemplateVariable objectReference="ModelValue_4"/>
      <StateTemplateVariable objectReference="ModelValue_5"/>
      <StateTemplateVariable objectReference="ModelValue_6"/>
      <StateTemplateVariable objectReference="ModelValue_7"/>
      <StateTemplateVariable objectReference="ModelValue_8"/>
      <StateTemplateVariable objectReference="ModelValue_9"/>
      <StateTemplateVariable objectReference="ModelValue_10"/>
      <StateTemplateVariable objectReference="ModelValue_11"/>
      <StateTemplateVariable objectReference="ModelValue_12"/>
      <StateTemplateVariable objectReference="ModelValue_13"/>
      <StateTemplateVariable objectReference="ModelValue_14"/>
      <StateTemplateVariable objectReference="ModelValue_15"/>
      <StateTemplateVariable objectReference="ModelValue_16"/>
      <StateTemplateVariable objectReference="ModelValue_17"/>
      <StateTemplateVariable objectReference="ModelValue_18"/>
      <StateTemplateVariable objectReference="ModelValue_19"/>
      <StateTemplateVariable objectReference="ModelValue_20"/>
      <StateTemplateVariable objectReference="ModelValue_21"/>
      <StateTemplateVariable objectReference="ModelValue_22"/>
      <StateTemplateVariable objectReference="ModelValue_23"/>
      <StateTemplateVariable objectReference="ModelValue_24"/>
      <StateTemplateVariable objectReference="ModelValue_25"/>
      <StateTemplateVariable objectReference="ModelValue_26"/>
      <StateTemplateVariable objectReference="ModelValue_27"/>
      <StateTemplateVariable objectReference="ModelValue_28"/>
      <StateTemplateVariable objectReference="ModelValue_29"/>
      <StateTemplateVariable objectReference="ModelValue_30"/>
      <StateTemplateVariable objectReference="ModelValue_31"/>
      <StateTemplateVariable objectReference="ModelValue_32"/>
      <StateTemplateVariable objectReference="ModelValue_33"/>
      <StateTemplateVariable objectReference="ModelValue_34"/>
      <StateTemplateVariable objectReference="ModelValue_35"/>
      <StateTemplateVariable objectReference="ModelValue_36"/>
      <StateTemplateVariable objectReference="ModelValue_37"/>
      <StateTemplateVariable objectReference="ModelValue_38"/>
      <StateTemplateVariable objectReference="ModelValue_39"/>
      <StateTemplateVariable objectReference="ModelValue_40"/>
      <StateTemplateVariable objectReference="ModelValue_41"/>
      <StateTemplateVariable objectReference="ModelValue_42"/>
      <StateTemplateVariable objectReference="ModelValue_43"/>
      <StateTemplateVariable objectReference="ModelValue_44"/>
      <StateTemplateVariable objectReference="ModelValue_45"/>
      <StateTemplateVariable objectReference="ModelValue_46"/>
      <StateTemplateVariable objectReference="ModelValue_47"/>
      <StateTemplateVariable objectReference="ModelValue_48"/>
      <StateTemplateVariable objectReference="ModelValue_49"/>
      <StateTemplateVariable objectReference="ModelValue_50"/>
      <StateTemplateVariable objectReference="ModelValue_51"/>
      <StateTemplateVariable objectReference="ModelValue_52"/>
      <StateTemplateVariable objectReference="ModelValue_53"/>
      <StateTemplateVariable objectReference="ModelValue_54"/>
      <StateTemplateVariable objectReference="ModelValue_55"/>
      <StateTemplateVariable objectReference="ModelValue_56"/>
      <StateTemplateVariable objectReference="ModelValue_57"/>
      <StateTemplateVariable objectReference="ModelValue_58"/>
      <StateTemplateVariable objectReference="ModelValue_59"/>
      <StateTemplateVariable objectReference="ModelValue_60"/>
      <StateTemplateVariable objectReference="ModelValue_61"/>
      <StateTemplateVariable objectReference="ModelValue_62"/>
      <StateTemplateVariable objectReference="ModelValue_63"/>
      <StateTemplateVariable objectReference="ModelValue_64"/>
      <StateTemplateVariable objectReference="ModelValue_65"/>
      <StateTemplateVariable objectReference="ModelValue_66"/>
      <StateTemplateVariable objectReference="ModelValue_67"/>
      <StateTemplateVariable objectReference="ModelValue_68"/>
      <StateTemplateVariable objectReference="ModelValue_69"/>
      <StateTemplateVariable objectReference="ModelValue_70"/>
      <StateTemplateVariable objectReference="ModelValue_71"/>
      <StateTemplateVariable objectReference="ModelValue_72"/>
      <StateTemplateVariable objectReference="ModelValue_73"/>
      <StateTemplateVariable objectReference="ModelValue_74"/>
      <StateTemplateVariable objectReference="ModelValue_75"/>
      <StateTemplateVariable objectReference="ModelValue_76"/>
      <StateTemplateVariable objectReference="ModelValue_77"/>
      <StateTemplateVariable objectReference="ModelValue_78"/>
      <StateTemplateVariable objectReference="ModelValue_79"/>
      <StateTemplateVariable objectReference="ModelValue_80"/>
      <StateTemplateVariable objectReference="ModelValue_81"/>
      <StateTemplateVariable objectReference="ModelValue_82"/>
      <StateTemplateVariable objectReference="ModelValue_83"/>
      <StateTemplateVariable objectReference="ModelValue_84"/>
      <StateTemplateVariable objectReference="ModelValue_85"/>
      <StateTemplateVariable objectReference="ModelValue_86"/>
      <StateTemplateVariable objectReference="ModelValue_87"/>
      <StateTemplateVariable objectReference="ModelValue_88"/>
      <StateTemplateVariable objectReference="ModelValue_89"/>
      <StateTemplateVariable objectReference="ModelValue_90"/>
      <StateTemplateVariable objectReference="ModelValue_91"/>
      <StateTemplateVariable objectReference="ModelValue_92"/>
      <StateTemplateVariable objectReference="ModelValue_93"/>
      <StateTemplateVariable objectReference="ModelValue_94"/>
      <StateTemplateVariable objectReference="ModelValue_95"/>
      <StateTemplateVariable objectReference="ModelValue_96"/>
      <StateTemplateVariable objectReference="ModelValue_97"/>
      <StateTemplateVariable objectReference="ModelValue_98"/>
      <StateTemplateVariable objectReference="ModelValue_99"/>
      <StateTemplateVariable objectReference="ModelValue_100"/>
      <StateTemplateVariable objectReference="ModelValue_101"/>
      <StateTemplateVariable objectReference="ModelValue_102"/>
      <StateTemplateVariable objectReference="ModelValue_103"/>
      <StateTemplateVariable objectReference="ModelValue_104"/>
      <StateTemplateVariable objectReference="ModelValue_105"/>
      <StateTemplateVariable objectReference="ModelValue_106"/>
      <StateTemplateVariable objectReference="ModelValue_107"/>
      <StateTemplateVariable objectReference="ModelValue_108"/>
      <StateTemplateVariable objectReference="ModelValue_109"/>
      <StateTemplateVariable objectReference="ModelValue_110"/>
      <StateTemplateVariable objectReference="ModelValue_111"/>
      <StateTemplateVariable objectReference="ModelValue_112"/>
      <StateTemplateVariable objectReference="ModelValue_113"/>
      <StateTemplateVariable objectReference="ModelValue_114"/>
      <StateTemplateVariable objectReference="ModelValue_115"/>
      <StateTemplateVariable objectReference="ModelValue_116"/>
      <StateTemplateVariable objectReference="ModelValue_117"/>
      <StateTemplateVariable objectReference="ModelValue_118"/>
      <StateTemplateVariable objectReference="ModelValue_119"/>
      <StateTemplateVariable objectReference="ModelValue_120"/>
      <StateTemplateVariable objectReference="ModelValue_121"/>
      <StateTemplateVariable objectReference="ModelValue_122"/>
      <StateTemplateVariable objectReference="ModelValue_123"/>
      <StateTemplateVariable objectReference="ModelValue_124"/>
      <StateTemplateVariable objectReference="ModelValue_125"/>
      <StateTemplateVariable objectReference="ModelValue_126"/>
      <StateTemplateVariable objectReference="ModelValue_127"/>
      <StateTemplateVariable objectReference="ModelValue_128"/>
      <StateTemplateVariable objectReference="ModelValue_129"/>
      <StateTemplateVariable objectReference="ModelValue_130"/>
      <StateTemplateVariable objectReference="ModelValue_131"/>
      <StateTemplateVariable objectReference="ModelValue_132"/>
      <StateTemplateVariable objectReference="ModelValue_133"/>
      <StateTemplateVariable objectReference="ModelValue_134"/>
      <StateTemplateVariable objectReference="ModelValue_135"/>
      <StateTemplateVariable objectReference="ModelValue_136"/>
      <StateTemplateVariable objectReference="ModelValue_137"/>
      <StateTemplateVariable objectReference="ModelValue_138"/>
      <StateTemplateVariable objectReference="ModelValue_139"/>
      <StateTemplateVariable objectReference="ModelValue_140"/>
      <StateTemplateVariable objectReference="ModelValue_141"/>
      <StateTemplateVariable objectReference="ModelValue_142"/>
      <StateTemplateVariable objectReference="ModelValue_143"/>
      <StateTemplateVariable objectReference="ModelValue_144"/>
      <StateTemplateVariable objectReference="ModelValue_145"/>
      <StateTemplateVariable objectReference="ModelValue_146"/>
      <StateTemplateVariable objectReference="ModelValue_147"/>
      <StateTemplateVariable objectReference="ModelValue_148"/>
      <StateTemplateVariable objectReference="ModelValue_149"/>
      <StateTemplateVariable objectReference="ModelValue_150"/>
      <StateTemplateVariable objectReference="ModelValue_151"/>
      <StateTemplateVariable objectReference="ModelValue_152"/>
      <StateTemplateVariable objectReference="ModelValue_153"/>
      <StateTemplateVariable objectReference="ModelValue_154"/>
      <StateTemplateVariable objectReference="ModelValue_155"/>
      <StateTemplateVariable objectReference="ModelValue_156"/>
      <StateTemplateVariable objectReference="ModelValue_157"/>
      <StateTemplateVariable objectReference="ModelValue_158"/>
      <StateTemplateVariable objectReference="ModelValue_159"/>
      <StateTemplateVariable objectReference="ModelValue_160"/>
      <StateTemplateVariable objectReference="ModelValue_161"/>
      <StateTemplateVariable objectReference="ModelValue_162"/>
      <StateTemplateVariable objectReference="ModelValue_163"/>
      <StateTemplateVariable objectReference="ModelValue_164"/>
      <StateTemplateVariable objectReference="ModelValue_165"/>
    </StateTemplate>
    <InitialState type="initialState">
      0 1.8750540677344e+24 8.4309985059999996e+23 3.6735064918999999e+21 2.4088567160000002e+21 9.213876938699999e+21 4.817713432e+23 6.0173240765679997e+23 5.0585991036000002e+22 0 2.8304066412999999e+21 3.9625692978199998e+22 2.3727238652599999e+22 3.0110708950000003e+20 8.430998506e+21 8.9850355506800002e+22 1.0119004849736999e+24 1.5055354475e+23 7.6481200732999999e+21 5.0585991036e+21 2.7498906055676998e+24 1.2406214301578997e+24 3.7939493276999997e+21 0 1.5055354475e+22 0 6.5641345510999998e+21 1.204428358e+20 5.8414775363000001e+21 0 0 0 9.2740983566000005e+21 6.0221417900000001e+22 1.4453140296e+22 1.5055354475e+23 1.4453140296e+22 3.0110708949999999e+23 2.4088567160000001e+20 3.9324585888699994e+22 0 3.0110708949999998e+24 1.01171982072e+24 6.0221417899999999e+23 6.0221417899999999e+23 5.0585991036000002e+22 1 6.2112798362100001 0.099799402336500004 1 0.0017912094278199999 0.0082299999999999995 0.0018400000000000001 0.099465165072699993 935 0.38800878022200003 0.83955687095499998 0.0105041027811 0.0031199999999999999 2.7999999999999998 0.021778762863100001 2.2000000000000002 0.56999999999999995 0.94067979629300003 76000 0.01 1.1399999999999999 0.114 0.0044999999999999997 0.16117113233399999 10000 10000 1000 6.6960176783899996 25.462998451600001 730 4634 100 36.491131885199998 1.1762736713399999 30.408629637499999 0.492538064921 0.11003398765 239 82.842423015999998 4404.6958028600002 0.0035425542217000002 0.0137716737587 0.075886172789000006 0.017999999999999999 0.43880012784599998 3.3900000000000001 1.05 1 2.2890000000000001 0.173482270839 0.749 1.05 3 0.001072 0.204257236072 5000 1 0.41138999999999998 0.39250000000000002 0.0063564418874099997 0.29622622155 0.42799999999999999 4300 3900 0.81042046031000003 1 0.53000000000000003 1.7 12.432 1.7 13987.566805500001 9090 14181.799999999999 0.056701949841700003 0.25 0.19986555159200001 141.69999999999999 1.2665998361899999 0.44 0.054121268449899999 0.47717693486000001 0.354968059457 1.667 3.04495540456 0.19 0.087172865688099996 0.027372076237700001 570 2800000 2000 1500 1380 162 184.692751921 1305.3099174199999 90 33.600000000000001 0.48770031935300001 15.800000000000001 5 0.062613649003300006 0.00020000000000000001 0.215 2.43160734777 48.799999999999997 0.00020000000000000001 1.0000000000000001e-05 1.0000000000000001e-05 0.12985368837299999 23.8368666995 0.94973961113200001 0.036400000000000002 0.00029999999999999997 0.0060949999999999997 0.00409559213329 0.0083505290070899994 0.54000000000000004 0.61768530074700001 10.971735779299999 0.373185469426 0.068000000000000005 0.057200000000000001 0.907389917504 2094.2252309700002 0.033000000000000002 0.071999999999999995 0.000167623949645 1455 0.050000000000000003 0.040486060055600001 0.0085199999999999998 0.86829999999999996 0.54486899878100004 0.0287 141914.358423 100000 0.31264788198499999 0.065199999999999994 0.029999999999999999 0.17599999999999999 33.200000000000003 100000 0.13073126530000001 0.034941139166499997 1.6799999999999999 3.0888334303799998 2.63210940537 0.070999999999999994 0.10678026016 100000 1.1452571222600001 1.2 0.093809107968500005 0.78000000000000003 3.7326230208800002 0.051999999999999998 3.7558974895300001 0.01 1 0.13538074424900001 0.0035000000000000001 0.002 0.065500000000000003 0.0050000000000000001 13.2222019644 0.064997069307799998 0.029999999999999999 
    </InitialState>
  </Model>
    <ListOfTasks>
    <Task key="Task_14" name="Steady-State" type="steadyState" scheduled="true" updateModel="false">
      <Report reference="Report_9" target="mutant_output.txt" append="1" confirmOverwrite="1"/>
      <Problem>
        <Parameter name="JacobianRequested" type="bool" value="1"/>
        <Parameter name="StabilityAnalysisRequested" type="bool" value="1"/>
      </Problem>
      <Method name="Enhanced Newton" type="EnhancedNewton">
        <Parameter name="Resolution" type="unsignedFloat" value="1.0000000000000001e-12"/>
        <Parameter name="Derivation Factor" type="unsignedFloat" value="0.001"/>
        <Parameter name="Use Newton" type="bool" value="1"/>
        <Parameter name="Use Integration" type="bool" value="1"/>
        <Parameter name="Use Back Integration" type="bool" value="0"/>
        <Parameter name="Accept Negative Concentrations" type="bool" value="0"/>
        <Parameter name="Iteration Limit" type="unsignedInteger" value="50"/>
        <Parameter name="Maximum duration for forward integration" type="unsignedFloat" value="1000000000"/>
        <Parameter name="Maximum duration for backward integration" type="unsignedFloat" value="1000000"/>
      </Method>
    </Task>
  </ListOfTasks>

  <ListOfReports>
    <Report key="Report_9" name="Steady-State" taskType="steadyState" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Steady-State]"/>
      </Footer>
    </Report>
    <Report key="Report_10" name="Elementary Flux Modes" taskType="fluxMode" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Elementary Flux Modes],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_11" name="Optimization" taskType="optimization" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Object=Description"/>
        <Object cn="String=\[Function Evaluations\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Value\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Parameters\]"/>
      </Header>
      <Body>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Function Evaluations"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Best Value"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Best Parameters"/>
      </Body>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_12" name="Parameter Estimation" taskType="parameterFitting" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Object=Description"/>
        <Object cn="String=\[Function Evaluations\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Value\]"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="String=\[Best Parameters\]"/>
      </Header>
      <Body>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Function Evaluations"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Best Value"/>
        <Object cn="Separator=&#x09;"/>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Best Parameters"/>
      </Body>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_13" name="Metabolic Control Analysis" taskType="metabolicControlAnalysis" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_14" name="Lyapunov Exponents" taskType="lyapunovExponents" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Lyapunov Exponents],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Lyapunov Exponents],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_15" name="Time Scale Separation Analysis" taskType="timeScaleSeparationAnalysis" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Time Scale Separation Analysis],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Time Scale Separation Analysis],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_16" name="Sensitivities" taskType="sensitivities" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Sensitivities],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Sensitivities],Object=Result"/>
      </Footer>
    </Report>
    <Report key="Report_17" name="Linear Noise Approximation" taskType="linearNoiseApproximation" separator="&#x09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Linear Noise Approximation],Object=Description"/>
      </Header>
      <Footer>
        <Object cn="String=&#x0a;"/>
        <Object cn="CN=Root,Vector=TaskList[Linear Noise Approximation],Object=Result"/>
      </Footer>
    </Report>
  </ListOfReports>
  <SBMLReference file="mutant.xml">
    <SBMLMap SBMLid="ADPf" COPASIkey="Metabolite_0"/>
    <SBMLMap SBMLid="AMPf" COPASIkey="Metabolite_1"/>
    <SBMLMap SBMLid="ATPf" COPASIkey="Metabolite_2"/>
    <SBMLMap SBMLid="Atot" COPASIkey="ModelValue_145"/>
    <SBMLMap SBMLid="DHAP" COPASIkey="Metabolite_3"/>
    <SBMLMap SBMLid="E4P" COPASIkey="Metabolite_4"/>
    <SBMLMap SBMLid="EqMult" COPASIkey="ModelValue_25"/>
    <SBMLMap SBMLid="Fru16P2" COPASIkey="Metabolite_5"/>
    <SBMLMap SBMLid="Fru6P" COPASIkey="Metabolite_6"/>
    <SBMLMap SBMLid="GSH" COPASIkey="Metabolite_7"/>
    <SBMLMap SBMLid="GSSG" COPASIkey="Metabolite_8"/>
    <SBMLMap SBMLid="GStotal" COPASIkey="ModelValue_82"/>
    <SBMLMap SBMLid="Glc6P" COPASIkey="Metabolite_9"/>
    <SBMLMap SBMLid="GlcA6P" COPASIkey="Metabolite_10"/>
    <SBMLMap SBMLid="Glcin" COPASIkey="Metabolite_11"/>
    <SBMLMap SBMLid="Glcout" COPASIkey="Metabolite_12"/>
    <SBMLMap SBMLid="GraP" COPASIkey="Metabolite_13"/>
    <SBMLMap SBMLid="Gri13P2" COPASIkey="Metabolite_14"/>
    <SBMLMap SBMLid="Gri23P2f" COPASIkey="Metabolite_15"/>
    <SBMLMap SBMLid="Gri2P" COPASIkey="Metabolite_16"/>
    <SBMLMap SBMLid="Gri3P" COPASIkey="Metabolite_17"/>
    <SBMLMap SBMLid="Inhibv1" COPASIkey="ModelValue_9"/>
    <SBMLMap SBMLid="K13P2Gv6" COPASIkey="ModelValue_159"/>
    <SBMLMap SBMLid="K13P2Gv7" COPASIkey="ModelValue_160"/>
    <SBMLMap SBMLid="K1v23" COPASIkey="ModelValue_8"/>
    <SBMLMap SBMLid="K1v24" COPASIkey="ModelValue_4"/>
    <SBMLMap SBMLid="K1v26" COPASIkey="ModelValue_5"/>
    <SBMLMap SBMLid="K23P2Gv1" COPASIkey="ModelValue_144"/>
    <SBMLMap SBMLid="K23P2Gv8" COPASIkey="ModelValue_142"/>
    <SBMLMap SBMLid="K23P2Gv9" COPASIkey="ModelValue_141"/>
    <SBMLMap SBMLid="K2PGv10" COPASIkey="ModelValue_63"/>
    <SBMLMap SBMLid="K2PGv11" COPASIkey="ModelValue_64"/>
    <SBMLMap SBMLid="K2v23" COPASIkey="ModelValue_135"/>
    <SBMLMap SBMLid="K2v24" COPASIkey="ModelValue_78"/>
    <SBMLMap SBMLid="K2v26" COPASIkey="ModelValue_79"/>
    <SBMLMap SBMLid="K3PGv10" COPASIkey="ModelValue_98"/>
    <SBMLMap SBMLid="K3PGv7" COPASIkey="ModelValue_149"/>
    <SBMLMap SBMLid="K3v23" COPASIkey="ModelValue_67"/>
    <SBMLMap SBMLid="K3v24" COPASIkey="ModelValue_74"/>
    <SBMLMap SBMLid="K3v26" COPASIkey="ModelValue_72"/>
    <SBMLMap SBMLid="K4v23" COPASIkey="ModelValue_113"/>
    <SBMLMap SBMLid="K4v24" COPASIkey="ModelValue_112"/>
    <SBMLMap SBMLid="K4v26" COPASIkey="ModelValue_111"/>
    <SBMLMap SBMLid="K5v23" COPASIkey="ModelValue_56"/>
    <SBMLMap SBMLid="K5v24" COPASIkey="ModelValue_130"/>
    <SBMLMap SBMLid="K5v26" COPASIkey="ModelValue_132"/>
    <SBMLMap SBMLid="K6PG1v18" COPASIkey="ModelValue_156"/>
    <SBMLMap SBMLid="K6PG2v18" COPASIkey="ModelValue_164"/>
    <SBMLMap SBMLid="K6v23" COPASIkey="ModelValue_40"/>
    <SBMLMap SBMLid="K6v24" COPASIkey="ModelValue_34"/>
    <SBMLMap SBMLid="K6v26" COPASIkey="ModelValue_35"/>
    <SBMLMap SBMLid="K7v23" COPASIkey="ModelValue_103"/>
    <SBMLMap SBMLid="K7v24" COPASIkey="ModelValue_102"/>
    <SBMLMap SBMLid="K7v26" COPASIkey="ModelValue_101"/>
    <SBMLMap SBMLid="KADPv16" COPASIkey="ModelValue_151"/>
    <SBMLMap SBMLid="KAMPv16" COPASIkey="ModelValue_1"/>
    <SBMLMap SBMLid="KAMPv3" COPASIkey="ModelValue_123"/>
    <SBMLMap SBMLid="KATPv12" COPASIkey="ModelValue_44"/>
    <SBMLMap SBMLid="KATPv16" COPASIkey="ModelValue_48"/>
    <SBMLMap SBMLid="KATPv17" COPASIkey="ModelValue_49"/>
    <SBMLMap SBMLid="KATPv18" COPASIkey="ModelValue_53"/>
    <SBMLMap SBMLid="KATPv25" COPASIkey="ModelValue_165"/>
    <SBMLMap SBMLid="KATPv3" COPASIkey="ModelValue_18"/>
    <SBMLMap SBMLid="KDHAPv4" COPASIkey="ModelValue_110"/>
    <SBMLMap SBMLid="KDHAPv5" COPASIkey="ModelValue_109"/>
    <SBMLMap SBMLid="KFru16P2v12" COPASIkey="ModelValue_162"/>
    <SBMLMap SBMLid="KFru16P2v4" COPASIkey="ModelValue_114"/>
    <SBMLMap SBMLid="KFru6Pv2" COPASIkey="ModelValue_146"/>
    <SBMLMap SBMLid="KFru6Pv3" COPASIkey="ModelValue_147"/>
    <SBMLMap SBMLid="KG6Pv17" COPASIkey="ModelValue_99"/>
    <SBMLMap SBMLid="KGSHv19" COPASIkey="ModelValue_108"/>
    <SBMLMap SBMLid="KGSSGv19" COPASIkey="ModelValue_136"/>
    <SBMLMap SBMLid="KGlc6Pv1" COPASIkey="ModelValue_21"/>
    <SBMLMap SBMLid="KGlc6Pv2" COPASIkey="ModelValue_22"/>
    <SBMLMap SBMLid="KGraPv4" COPASIkey="ModelValue_59"/>
    <SBMLMap SBMLid="KGraPv5" COPASIkey="ModelValue_60"/>
    <SBMLMap SBMLid="KGraPv6" COPASIkey="ModelValue_58"/>
    <SBMLMap SBMLid="KMGlcv1" COPASIkey="ModelValue_84"/>
    <SBMLMap SBMLid="KMg23P2Gv1" COPASIkey="ModelValue_0"/>
    <SBMLMap SBMLid="KMgADPv12" COPASIkey="ModelValue_43"/>
    <SBMLMap SBMLid="KMgADPv7" COPASIkey="ModelValue_80"/>
    <SBMLMap SBMLid="KMgATPMgv1" COPASIkey="ModelValue_19"/>
    <SBMLMap SBMLid="KMgATPv1" COPASIkey="ModelValue_121"/>
    <SBMLMap SBMLid="KMgATPv3" COPASIkey="ModelValue_119"/>
    <SBMLMap SBMLid="KMgATPv7" COPASIkey="ModelValue_118"/>
    <SBMLMap SBMLid="KMgv1" COPASIkey="ModelValue_76"/>
    <SBMLMap SBMLid="KMgv3" COPASIkey="ModelValue_77"/>
    <SBMLMap SBMLid="KMinv0" COPASIkey="ModelValue_26"/>
    <SBMLMap SBMLid="KMoutv0" COPASIkey="ModelValue_66"/>
    <SBMLMap SBMLid="KNADHv6" COPASIkey="ModelValue_10"/>
    <SBMLMap SBMLid="KNADPHv17" COPASIkey="ModelValue_11"/>
    <SBMLMap SBMLid="KNADPHv18" COPASIkey="ModelValue_3"/>
    <SBMLMap SBMLid="KNADPHv19" COPASIkey="ModelValue_129"/>
    <SBMLMap SBMLid="KNADPv17" COPASIkey="ModelValue_39"/>
    <SBMLMap SBMLid="KNADPv18" COPASIkey="ModelValue_42"/>
    <SBMLMap SBMLid="KNADPv19" COPASIkey="ModelValue_41"/>
    <SBMLMap SBMLid="KNADv6" COPASIkey="ModelValue_127"/>
    <SBMLMap SBMLid="KPEPv11" COPASIkey="ModelValue_157"/>
    <SBMLMap SBMLid="KPEPv12" COPASIkey="ModelValue_158"/>
    <SBMLMap SBMLid="KPGA23v17" COPASIkey="ModelValue_47"/>
    <SBMLMap SBMLid="KPGA23v18" COPASIkey="ModelValue_6"/>
    <SBMLMap SBMLid="KPv6" COPASIkey="ModelValue_155"/>
    <SBMLMap SBMLid="KR5Pv22" COPASIkey="ModelValue_14"/>
    <SBMLMap SBMLid="KR5Pv25" COPASIkey="ModelValue_15"/>
    <SBMLMap SBMLid="KRu5Pv21" COPASIkey="ModelValue_83"/>
    <SBMLMap SBMLid="KRu5Pv22" COPASIkey="ModelValue_152"/>
    <SBMLMap SBMLid="KX5Pv21" COPASIkey="ModelValue_96"/>
    <SBMLMap SBMLid="Kd1" COPASIkey="ModelValue_104"/>
    <SBMLMap SBMLid="Kd2" COPASIkey="ModelValue_105"/>
    <SBMLMap SBMLid="Kd23P2G" COPASIkey="ModelValue_81"/>
    <SBMLMap SBMLid="Kd3" COPASIkey="ModelValue_106"/>
    <SBMLMap SBMLid="Kd4" COPASIkey="ModelValue_100"/>
    <SBMLMap SBMLid="KdADP" COPASIkey="ModelValue_116"/>
    <SBMLMap SBMLid="KdAMP" COPASIkey="ModelValue_117"/>
    <SBMLMap SBMLid="KdATP" COPASIkey="ModelValue_124"/>
    <SBMLMap SBMLid="Keqv0" COPASIkey="ModelValue_131"/>
    <SBMLMap SBMLid="Keqv1" COPASIkey="ModelValue_62"/>
    <SBMLMap SBMLid="Keqv10" COPASIkey="ModelValue_107"/>
    <SBMLMap SBMLid="Keqv11" COPASIkey="ModelValue_68"/>
    <SBMLMap SBMLid="Keqv12" COPASIkey="ModelValue_69"/>
    <SBMLMap SBMLid="Keqv13" COPASIkey="ModelValue_70"/>
    <SBMLMap SBMLid="Keqv14" COPASIkey="ModelValue_71"/>
    <SBMLMap SBMLid="Keqv16" COPASIkey="ModelValue_73"/>
    <SBMLMap SBMLid="Keqv17" COPASIkey="ModelValue_122"/>
    <SBMLMap SBMLid="Keqv18" COPASIkey="ModelValue_75"/>
    <SBMLMap SBMLid="Keqv19" COPASIkey="ModelValue_16"/>
    <SBMLMap SBMLid="Keqv2" COPASIkey="ModelValue_57"/>
    <SBMLMap SBMLid="Keqv21" COPASIkey="ModelValue_153"/>
    <SBMLMap SBMLid="Keqv22" COPASIkey="ModelValue_51"/>
    <SBMLMap SBMLid="Keqv23" COPASIkey="ModelValue_50"/>
    <SBMLMap SBMLid="Keqv24" COPASIkey="ModelValue_45"/>
    <SBMLMap SBMLid="Keqv25" COPASIkey="ModelValue_148"/>
    <SBMLMap SBMLid="Keqv26" COPASIkey="ModelValue_150"/>
    <SBMLMap SBMLid="Keqv27" COPASIkey="ModelValue_46"/>
    <SBMLMap SBMLid="Keqv28" COPASIkey="ModelValue_2"/>
    <SBMLMap SBMLid="Keqv29" COPASIkey="ModelValue_55"/>
    <SBMLMap SBMLid="Keqv3" COPASIkey="ModelValue_140"/>
    <SBMLMap SBMLid="Keqv4" COPASIkey="ModelValue_20"/>
    <SBMLMap SBMLid="Keqv5" COPASIkey="ModelValue_128"/>
    <SBMLMap SBMLid="Keqv6" COPASIkey="ModelValue_125"/>
    <SBMLMap SBMLid="Keqv7" COPASIkey="ModelValue_126"/>
    <SBMLMap SBMLid="Keqv8" COPASIkey="ModelValue_133"/>
    <SBMLMap SBMLid="Keqv9" COPASIkey="ModelValue_134"/>
    <SBMLMap SBMLid="KiGraPv4" COPASIkey="ModelValue_120"/>
    <SBMLMap SBMLid="KiiGraPv4" COPASIkey="ModelValue_138"/>
    <SBMLMap SBMLid="Kv20" COPASIkey="ModelValue_137"/>
    <SBMLMap SBMLid="L0v12" COPASIkey="ModelValue_163"/>
    <SBMLMap SBMLid="L0v3" COPASIkey="ModelValue_52"/>
    <SBMLMap SBMLid="Lac" COPASIkey="Metabolite_18"/>
    <SBMLMap SBMLid="Lacex" COPASIkey="Metabolite_19"/>
    <SBMLMap SBMLid="MgADP" COPASIkey="Metabolite_20"/>
    <SBMLMap SBMLid="MgAMP" COPASIkey="Metabolite_21"/>
    <SBMLMap SBMLid="MgATP" COPASIkey="Metabolite_22"/>
    <SBMLMap SBMLid="MgGri23P2" COPASIkey="Metabolite_23"/>
    <SBMLMap SBMLid="Mgf" COPASIkey="Metabolite_24"/>
    <SBMLMap SBMLid="Mgtot" COPASIkey="ModelValue_12"/>
    <SBMLMap SBMLid="NAD" COPASIkey="Metabolite_25"/>
    <SBMLMap SBMLid="NADH" COPASIkey="Metabolite_26"/>
    <SBMLMap SBMLid="NADPHf" COPASIkey="Metabolite_27"/>
    <SBMLMap SBMLid="NADPf" COPASIkey="Metabolite_28"/>
    <SBMLMap SBMLid="NADPtot" COPASIkey="ModelValue_154"/>
    <SBMLMap SBMLid="NADtot" COPASIkey="ModelValue_161"/>
    <SBMLMap SBMLid="P1NADP" COPASIkey="Metabolite_29"/>
    <SBMLMap SBMLid="P1NADPH" COPASIkey="Metabolite_30"/>
    <SBMLMap SBMLid="P1f" COPASIkey="Metabolite_31"/>
    <SBMLMap SBMLid="P2NADP" COPASIkey="Metabolite_32"/>
    <SBMLMap SBMLid="P2NADPH" COPASIkey="Metabolite_33"/>
    <SBMLMap SBMLid="P2f" COPASIkey="Metabolite_34"/>
    <SBMLMap SBMLid="PEP" COPASIkey="Metabolite_35"/>
    <SBMLMap SBMLid="PRPP" COPASIkey="Metabolite_36"/>
    <SBMLMap SBMLid="Phi" COPASIkey="Metabolite_37"/>
    <SBMLMap SBMLid="Phiex" COPASIkey="Metabolite_38"/>
    <SBMLMap SBMLid="Pyr" COPASIkey="Metabolite_39"/>
    <SBMLMap SBMLid="Pyrex" COPASIkey="Metabolite_40"/>
    <SBMLMap SBMLid="Rib5P" COPASIkey="Metabolite_41"/>
    <SBMLMap SBMLid="Rul5P" COPASIkey="Metabolite_42"/>
    <SBMLMap SBMLid="Sed7P" COPASIkey="Metabolite_43"/>
    <SBMLMap SBMLid="Vmax1v1" COPASIkey="ModelValue_97"/>
    <SBMLMap SBMLid="Vmax2v1" COPASIkey="ModelValue_139"/>
    <SBMLMap SBMLid="Vmaxv0" COPASIkey="ModelValue_95"/>
    <SBMLMap SBMLid="Vmaxv10" COPASIkey="ModelValue_88"/>
    <SBMLMap SBMLid="Vmaxv11" COPASIkey="ModelValue_89"/>
    <SBMLMap SBMLid="Vmaxv12" COPASIkey="ModelValue_86"/>
    <SBMLMap SBMLid="Vmaxv13" COPASIkey="ModelValue_87"/>
    <SBMLMap SBMLid="Vmaxv16" COPASIkey="ModelValue_90"/>
    <SBMLMap SBMLid="Vmaxv17" COPASIkey="ModelValue_91"/>
    <SBMLMap SBMLid="Vmaxv18" COPASIkey="ModelValue_93"/>
    <SBMLMap SBMLid="Vmaxv19" COPASIkey="ModelValue_94"/>
    <SBMLMap SBMLid="Vmaxv2" COPASIkey="ModelValue_7"/>
    <SBMLMap SBMLid="Vmaxv21" COPASIkey="ModelValue_29"/>
    <SBMLMap SBMLid="Vmaxv22" COPASIkey="ModelValue_28"/>
    <SBMLMap SBMLid="Vmaxv23" COPASIkey="ModelValue_27"/>
    <SBMLMap SBMLid="Vmaxv24" COPASIkey="ModelValue_33"/>
    <SBMLMap SBMLid="Vmaxv25" COPASIkey="ModelValue_32"/>
    <SBMLMap SBMLid="Vmaxv26" COPASIkey="ModelValue_31"/>
    <SBMLMap SBMLid="Vmaxv27" COPASIkey="ModelValue_30"/>
    <SBMLMap SBMLid="Vmaxv28" COPASIkey="ModelValue_24"/>
    <SBMLMap SBMLid="Vmaxv29" COPASIkey="ModelValue_23"/>
    <SBMLMap SBMLid="Vmaxv3" COPASIkey="ModelValue_36"/>
    <SBMLMap SBMLid="Vmaxv4" COPASIkey="ModelValue_37"/>
    <SBMLMap SBMLid="Vmaxv5" COPASIkey="ModelValue_38"/>
    <SBMLMap SBMLid="Vmaxv6" COPASIkey="ModelValue_61"/>
    <SBMLMap SBMLid="Vmaxv7" COPASIkey="ModelValue_54"/>
    <SBMLMap SBMLid="Vmaxv9" COPASIkey="ModelValue_65"/>
    <SBMLMap SBMLid="Xul5P" COPASIkey="Metabolite_44"/>
    <SBMLMap SBMLid="alfav0" COPASIkey="ModelValue_115"/>
    <SBMLMap SBMLid="default_compartment" COPASIkey="Compartment_0"/>
    <SBMLMap SBMLid="kATPasev15" COPASIkey="ModelValue_143"/>
    <SBMLMap SBMLid="kDPGMv8" COPASIkey="ModelValue_17"/>
    <SBMLMap SBMLid="kLDHv14" COPASIkey="ModelValue_92"/>
    <SBMLMap SBMLid="protein1" COPASIkey="ModelValue_13"/>
    <SBMLMap SBMLid="protein2" COPASIkey="ModelValue_85"/>
    <SBMLMap SBMLid="v_1" COPASIkey="Reaction_0"/>
    <SBMLMap SBMLid="v_10" COPASIkey="Reaction_1"/>
    <SBMLMap SBMLid="v_11" COPASIkey="Reaction_2"/>
    <SBMLMap SBMLid="v_12" COPASIkey="Reaction_3"/>
    <SBMLMap SBMLid="v_13" COPASIkey="Reaction_4"/>
    <SBMLMap SBMLid="v_14" COPASIkey="Reaction_5"/>
    <SBMLMap SBMLid="v_15" COPASIkey="Reaction_6"/>
    <SBMLMap SBMLid="v_16" COPASIkey="Reaction_7"/>
    <SBMLMap SBMLid="v_17" COPASIkey="Reaction_8"/>
    <SBMLMap SBMLid="v_18" COPASIkey="Reaction_9"/>
    <SBMLMap SBMLid="v_19" COPASIkey="Reaction_10"/>
    <SBMLMap SBMLid="v_2" COPASIkey="Reaction_11"/>
    <SBMLMap SBMLid="v_20" COPASIkey="Reaction_12"/>
    <SBMLMap SBMLid="v_21" COPASIkey="Reaction_13"/>
    <SBMLMap SBMLid="v_22" COPASIkey="Reaction_14"/>
    <SBMLMap SBMLid="v_23" COPASIkey="Reaction_15"/>
    <SBMLMap SBMLid="v_24" COPASIkey="Reaction_16"/>
    <SBMLMap SBMLid="v_25" COPASIkey="Reaction_17"/>
    <SBMLMap SBMLid="v_26" COPASIkey="Reaction_18"/>
    <SBMLMap SBMLid="v_27" COPASIkey="Reaction_19"/>
    <SBMLMap SBMLid="v_28" COPASIkey="Reaction_20"/>
    <SBMLMap SBMLid="v_29" COPASIkey="Reaction_21"/>
    <SBMLMap SBMLid="v_3" COPASIkey="Reaction_22"/>
    <SBMLMap SBMLid="v_30" COPASIkey="Reaction_23"/>
    <SBMLMap SBMLid="v_31" COPASIkey="Reaction_24"/>
    <SBMLMap SBMLid="v_32" COPASIkey="Reaction_25"/>
    <SBMLMap SBMLid="v_33" COPASIkey="Reaction_26"/>
    <SBMLMap SBMLid="v_34" COPASIkey="Reaction_27"/>
    <SBMLMap SBMLid="v_35" COPASIkey="Reaction_28"/>
    <SBMLMap SBMLid="v_36" COPASIkey="Reaction_29"/>
    <SBMLMap SBMLid="v_37" COPASIkey="Reaction_30"/>
    <SBMLMap SBMLid="v_38" COPASIkey="Reaction_31"/>
    <SBMLMap SBMLid="v_4" COPASIkey="Reaction_32"/>
    <SBMLMap SBMLid="v_5" COPASIkey="Reaction_33"/>
    <SBMLMap SBMLid="v_6" COPASIkey="Reaction_34"/>
    <SBMLMap SBMLid="v_7" COPASIkey="Reaction_35"/>
    <SBMLMap SBMLid="v_8" COPASIkey="Reaction_36"/>
    <SBMLMap SBMLid="v_9" COPASIkey="Reaction_37"/>
  </SBMLReference>
  <ListOfUnitDefinitions>
    <UnitDefinition key="Unit_0" name="meter" symbol="m">
      <Expression>
        m
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_2" name="second" symbol="s">
      <Expression>
        s
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_6" name="Avogadro" symbol="Avogadro">
      <Expression>
        Avogadro
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_8" name="item" symbol="#">
      <Expression>
        #
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_17" name="liter" symbol="l">
      <Expression>
        0.001*m^3
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_20" name="mole" symbol="mol">
      <Expression>
        Avogadro*#
      </Expression>
    </UnitDefinition>
  </ListOfUnitDefinitions>
</COPASI>

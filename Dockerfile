FROM ubuntu:14.04

RUN apt-get update && apt-get install -y curl

CMD curl -k 'https://kyrules.chfsinet.ky.gov/KY_EDBC_DRIVER_WCFEdbcService/KyHbeEdbcDriverService.svc?wsdl'>/dev/null 

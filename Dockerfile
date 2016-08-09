FROM alpine:latest

#RUN apt-get update && apt-get install -y curl
RUN apk add curl

CMD curl -k 'https://kyrules.chfsinet.ky.gov/KY_EDBC_DRIVER_WCFEdbcService/KyHbeEdbcDriverService.svc?wsdl'>/dev/null 

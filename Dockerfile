FROM alpine:latest

#RUN apt-get update && apt-get install -y curl     #
RUN apk add --update curl


ENV DNSHost kyrules.chfsinet.ky.gov

CMD curl -k https://$DNSHost/KY_EDBC_DRIVER_WCFEdbcService/KyHbeEdbcDriverService.svc?wsdl > /dev/null 
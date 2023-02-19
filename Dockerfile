FROM eclipse-temurin:11-jdk as node
LABEL name="corda-notary-node" version="0.0.1"

COPY /corda/nodes/notary/ /corda/
COPY /corda/libs/ /corda/libs/

COPY node-entrypoint.sh /

CMD [ "/node-entrypoint.sh" ]
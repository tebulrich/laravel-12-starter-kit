FROM rabbitmq:3.9.11-management-alpine

RUN rabbitmq-plugins enable rabbitmq_management

ADD helper/rabbitmq.config /etc/rabbitmq/
ADD helper/definitions.json /etc/rabbitmq/

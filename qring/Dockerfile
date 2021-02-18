FROM debian:buster

COPY ./setup.sh ./entrypoint.sh /
RUN chmod +x /setup.sh ./entrypoint.sh && ./setup.sh
ENTRYPOINT ["/entrypoint.sh"]

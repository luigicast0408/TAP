FROM alpine:latest
COPY script.sh /app/script.sh
RUN chmod +x /app/script.sh
CMD ["/app/script.sh"]
ENV USER=Luigi
ENTRYPOINT ["/app/script.sh"]
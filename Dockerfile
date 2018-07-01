FROM alpine:3.7 as builder
ADD novocraftV3.09.00.Linux3.10.0.tar.gz .
RUN apk add --update alpine-sdk curl zlib-dev bzip2-dev ncurses-dev xz-dev curl-dev
RUN curl -L -O https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 \
    && tar jxf samtools-1.7.tar.bz2 \
    && cd samtools-1.7 \
    && ./configure --prefix=/app/samtools-1.7 \
    && make


FROM alpine:3.7
RUN apk add --no-cache procps zlib libcurl libbz2 xz-libs ncurses
COPY --from=builder /samtools-1.7/samtools /usr/local/bin/samtools
COPY --from=builder /novocraft/novoalign   /usr/local/bin/novoalign
COPY --from=builder /novocraft/novosort    /usr/local/bin/novosort  
COPY --from=builder /novocraft/novoindex   /usr/local/bin/novoindex 
COPY --from=builder /novocraft/novoutil    /usr/local/bin/novoutil  

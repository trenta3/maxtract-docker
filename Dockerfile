FROM i386/ubuntu:14.04

RUN apt update -qy && apt install -y pdftk poppler-utils imagemagick
COPY maxtract .

CMD ["./process_file.sh", "test.pdf"]
